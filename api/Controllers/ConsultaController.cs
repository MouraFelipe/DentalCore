using DentalCore.API.Wrappers;
using DentalCore.API.Data;
using DentalCore.API.DTOs.Consulta;
using DentalCore.API.Enums;
using DentalCore.API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;
using System.Collections.Generic;

namespace DentalCore.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    [Microsoft.AspNetCore.Authorization.Authorize]
    public class ConsultaController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ConsultaController(AppDbContext context)
        {
            _context = context;
        }

        // ── HELPER DE FUSO HORÁRIO ──────────────────────────────────────────────
        // Regra 1: Timezone E. South America Standard Time (UTC-3, Brasília)
        private static DateTime ObterAgoraLocal()
        {
            try
            {
                // Tenta o padrão Windows
                var tz = TimeZoneInfo.FindSystemTimeZoneById("E. South America Standard Time");
                return TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, tz);
            }
            catch (TimeZoneNotFoundException)
            {
                // Fallback para Linux/Docker (IANA Time Zone)
                var tz = TimeZoneInfo.FindSystemTimeZoneById("America/Sao_Paulo");
                return TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, tz);
            }
        }

        // ════════════════════════════════════════════════════════════════════════
        // POST /api/consultas
        // ════════════════════════════════════════════════════════════════════════
        [HttpPost]
        public async Task<IActionResult> Criar([FromBody] ConsultaRequestDto dto)
        {
            var agoraLocal = ObterAgoraLocal();

            if (dto.DataHora <= agoraLocal)
                return BadRequest(ApiResponse<ConsultaResponseDto>.Erro("Não é permitido agendar consultas em datas e horários passados."));

            var pacienteExiste = await _context.Pacientes.AnyAsync(p => p.Id == dto.PacienteId);
            if (!pacienteExiste)
                return NotFound(ApiResponse<ConsultaResponseDto>.Erro($"Paciente com Id {dto.PacienteId} não encontrado."));

            var conflitoHorario = await _context.Consultas
                .AnyAsync(c => c.DataHora == dto.DataHora && c.StatusConsulta != StatusConsulta.Cancelada);
            
            if (conflitoHorario)
                return BadRequest(ApiResponse<ConsultaResponseDto>.Erro($"Já existe uma consulta agendada para {dto.DataHora:dd/MM/yyyy HH:mm}."));

            var consulta = new Consulta
            {
                PacienteId = dto.PacienteId,
                DataHora = dto.DataHora,
                Observacao = dto.Observacao,
                StatusConsulta = StatusConsulta.Agendada
            };

            _context.Consultas.Add(consulta);
            await _context.SaveChangesAsync();

            var paciente = await _context.Pacientes.FirstAsync(p => p.Id == consulta.PacienteId);
            var response = MapToResponseDto(consulta, paciente.Nome);

            return CreatedAtAction(nameof(ObterPorId), new { id = consulta.Id }, ApiResponse<ConsultaResponseDto>.Ok(response, "Consulta agendada com sucesso."));
        }

        // ════════════════════════════════════════════════════════════════════════
        // GET /api/consultas/dia
        // ════════════════════════════════════════════════════════════════════════
        [HttpGet("dia")]
        public async Task<IActionResult> ListarPorDia([FromQuery] DateTime? data)
        {
            var diaAlvo = (data ?? ObterAgoraLocal()).Date;
            
            var inicioDia = diaAlvo;
            var fimDia = inicioDia.AddDays(1);

            var consultas = await _context.Consultas
                .Include(c => c.Paciente)
                .Where(c => c.DataHora >= inicioDia && c.DataHora < fimDia)
                .OrderBy(c => c.DataHora)
                .ToListAsync();

            var response = consultas.Select(c => MapToResponseDto(c, c.Paciente!.Nome)).ToList();

            return Ok(ApiResponse<List<ConsultaResponseDto>>.Ok(response));
        }

        // ════════════════════════════════════════════════════════════════════════
        // GET /api/consultas/dashboard
        // ════════════════════════════════════════════════════════════════════════
        [HttpGet("dashboard")]
        public async Task<IActionResult> Dashboard([FromQuery] DateTime? data)
        {
            var diaAlvo = (data ?? ObterAgoraLocal()).Date;
            var inicioDia = diaAlvo;
            var fimDia = inicioDia.AddDays(1);

            var agrupamento = await _context.Consultas
                .Where(c => c.DataHora >= inicioDia && c.DataHora < fimDia)
                .GroupBy(c => c.StatusConsulta)
                .Select(g => new { Status = g.Key, Quantidade = g.Count() })
                .ToDictionaryAsync(x => x.Status, x => x.Quantidade);

            var dashboard = new DashboardDto
            {
                Data = diaAlvo,
                Total = agrupamento.Values.Sum(),
                Agendadas = agrupamento.GetValueOrDefault(StatusConsulta.Agendada, 0),
                Realizadas = agrupamento.GetValueOrDefault(StatusConsulta.Realizada, 0),
                Faltas = agrupamento.GetValueOrDefault(StatusConsulta.Faltou, 0),
                Canceladas = agrupamento.GetValueOrDefault(StatusConsulta.Cancelada, 0)
            };

            return Ok(ApiResponse<DashboardDto>.Ok(dashboard));
        }

        // ════════════════════════════════════════════════════════════════════════
        // PATCH /api/consultas/{id}/status
        // ════════════════════════════════════════════════════════════════════════
        [HttpPatch("{id:int}/status")]
        public async Task<IActionResult> AtualizarStatus(int id, [FromBody] AtualizarStatusDto dto)
        {
            var consulta = await _context.Consultas
                .Include(c => c.Paciente)
                .FirstOrDefaultAsync(c => c.Id == id);

            if (consulta == null)
                return NotFound(ApiResponse<ConsultaResponseDto>.Erro($"Consulta com Id {id} não encontrada."));

            var agoraLocal = ObterAgoraLocal();
            var statusAtual = consulta.StatusConsulta;

            if (statusAtual == StatusConsulta.Realizada || statusAtual == StatusConsulta.Cancelada)
                return BadRequest(ApiResponse<ConsultaResponseDto>.Erro($"A consulta já está '{statusAtual}' e não pode ser alterada."));

            if (statusAtual == StatusConsulta.Faltou && dto.NovoStatus != StatusConsulta.Agendada)
                return BadRequest(ApiResponse<ConsultaResponseDto>.Erro("Uma consulta sinalizada como 'Faltou' só pode retornar para 'Agendada'."));

            if (dto.NovoStatus == StatusConsulta.Realizada && agoraLocal < consulta.DataHora)
                return BadRequest(ApiResponse<ConsultaResponseDto>.Erro("Não é possível marcar uma consulta como 'Realizada' antes do horário de início."));

            consulta.StatusConsulta = dto.NovoStatus;
            await _context.SaveChangesAsync();

            var response = MapToResponseDto(consulta, consulta.Paciente!.Nome);
            return Ok(ApiResponse<ConsultaResponseDto>.Ok(response, $"Status atualizado para {dto.NovoStatus}."));
        }

        // ════════════════════════════════════════════════════════════════════════
        // GET /api/consultas/{id} (Auxiliar)
        // ════════════════════════════════════════════════════════════════════════
        [HttpGet("{id:int}")]
        public async Task<IActionResult> ObterPorId(int id)
        {
            var consulta = await _context.Consultas
                .Include(c => c.Paciente)
                .FirstOrDefaultAsync(c => c.Id == id);

            if (consulta == null)
                return NotFound(ApiResponse<ConsultaResponseDto>.Erro("Consulta não encontrada."));

            return Ok(ApiResponse<ConsultaResponseDto>.Ok(MapToResponseDto(consulta, consulta.Paciente!.Nome)));
        }

        private static ConsultaResponseDto MapToResponseDto(Consulta consulta, string nomePaciente)
        {
            return new ConsultaResponseDto
            {
                Id = consulta.Id,
                PacienteId = consulta.PacienteId,
                NomePaciente = nomePaciente,
                DataHora = consulta.DataHora,
                StatusConsulta = (int)consulta.StatusConsulta,
                StatusConsultaLabel = consulta.StatusConsulta.ToString(),
                Observacao = consulta.Observacao
            };
        }
    }
}
