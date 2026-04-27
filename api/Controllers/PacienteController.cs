using DentalCore.API.Data;
using DentalCore.API.DTOs.Paciente;
using DentalCore.API.Models;
using DentalCore.API.Wrappers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DentalCore.API.Controllers
{
    /// <summary>
    /// Controller responsável por gerenciar os pacientes da clínica.
    /// Implementa Soft Delete (exclusão lógica) para manter a integridade dos históricos de consulta.
    /// </summary>
    [ApiController]
    [Route("api/[controller]")]
    [Produces("application/json")]
    [Microsoft.AspNetCore.Authorization.Authorize]
    public class PacienteController : ControllerBase
    {
        private readonly AppDbContext _context;

        public PacienteController(AppDbContext context)
        {
            _context = context;
        }

        // ════════════════════════════════════════════════════════════════════════
        // POST /api/paciente
        // Cria um novo paciente
        // ════════════════════════════════════════════════════════════════════════
        [HttpPost]
        [ProducesResponseType(typeof(ApiResponse<PacienteResponseDto>), StatusCodes.Status201Created)]
        [ProducesResponseType(typeof(ApiResponse<PacienteResponseDto>), StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> Criar([FromBody] PacienteRequestDto dto)
        {
            var cpfJaExiste = await _context.Pacientes.AnyAsync(p => p.Cpf == dto.Cpf);
            if (cpfJaExiste)
                return BadRequest(ApiResponse<PacienteResponseDto>.Erro("CPF já cadastrado."));

            var paciente = new Paciente
            {
                Nome = dto.Nome,
                Cpf = dto.Cpf,
                Telefone = dto.Telefone,
                DataCadastro = DateTime.UtcNow
            };

            _context.Pacientes.Add(paciente);
            await _context.SaveChangesAsync();

            var response = MapToResponseDto(paciente);

            return CreatedAtAction(
                nameof(ObterPorId), 
                new { id = paciente.Id }, 
                ApiResponse<PacienteResponseDto>.Ok(response, "Paciente cadastrado com sucesso.")
            );
        }

        // ════════════════════════════════════════════════════════════════════════
        // GET /api/paciente
        // Lista todos os pacientes ativos
        // ════════════════════════════════════════════════════════════════════════
        [HttpGet]
        [ProducesResponseType(typeof(ApiResponse<List<PacienteResponseDto>>), StatusCodes.Status200OK)]
        public async Task<IActionResult> ListarTodos()
        {
            var pacientes = await _context.Pacientes
                .Include(p => p.Consultas)
                .OrderBy(p => p.Nome)
                .ToListAsync();

            var response = pacientes.Select(MapToResponseDto).ToList();

            return Ok(ApiResponse<List<PacienteResponseDto>>.Ok(response));
        }

        // ════════════════════════════════════════════════════════════════════════
        // GET /api/paciente/{id}
        // Busca um paciente específico
        // ════════════════════════════════════════════════════════════════════════
        [HttpGet("{id:int}")]
        [ProducesResponseType(typeof(ApiResponse<PacienteResponseDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<PacienteResponseDto>), StatusCodes.Status404NotFound)]
        public async Task<IActionResult> ObterPorId(int id)
        {
            var paciente = await _context.Pacientes
                .Include(p => p.Consultas)
                .FirstOrDefaultAsync(p => p.Id == id);

            if (paciente == null)
                return NotFound(ApiResponse<PacienteResponseDto>.Erro($"Paciente com Id {id} não encontrado."));

            return Ok(ApiResponse<PacienteResponseDto>.Ok(MapToResponseDto(paciente)));
        }

        // ════════════════════════════════════════════════════════════════════════
        // PUT /api/paciente/{id}
        // Atualiza os dados cadastrais do paciente
        // ════════════════════════════════════════════════════════════════════════
        [HttpPut("{id:int}")]
        [ProducesResponseType(typeof(ApiResponse<PacienteResponseDto>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<PacienteResponseDto>), StatusCodes.Status404NotFound)]
        public async Task<IActionResult> Atualizar(int id, [FromBody] PacienteRequestDto dto)
        {
            var paciente = await _context.Pacientes.FindAsync(id);

            if (paciente == null)
                return NotFound(ApiResponse<PacienteResponseDto>.Erro($"Paciente com Id {id} não encontrado."));

            var cpfJaExiste = await _context.Pacientes.AnyAsync(p => p.Cpf == dto.Cpf && p.Id != id);
            if (cpfJaExiste)
                return BadRequest(ApiResponse<PacienteResponseDto>.Erro("CPF já cadastrado por outro paciente."));

            paciente.Nome = dto.Nome;
            paciente.Cpf = dto.Cpf;
            paciente.Telefone = dto.Telefone;

            await _context.SaveChangesAsync();

            return Ok(ApiResponse<PacienteResponseDto>.Ok(MapToResponseDto(paciente), "Dados atualizados com sucesso."));
        }

        // ════════════════════════════════════════════════════════════════════════
        // DELETE /api/paciente/{id}
        // Exclusão Lógica (Soft Delete)
        // ════════════════════════════════════════════════════════════════════════
        [HttpDelete("{id:int}")]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status200OK)]
        [ProducesResponseType(typeof(ApiResponse<object>), StatusCodes.Status404NotFound)]
        public async Task<IActionResult> Excluir(int id)
        {
            var paciente = await _context.Pacientes.FindAsync(id);

            if (paciente == null)
                return NotFound(ApiResponse<object>.Erro($"Paciente com Id {id} não encontrado."));

            paciente.DataExclusao = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return Ok(ApiResponse<object>.Ok(null, "Paciente removido com sucesso."));
        }

        // ── MAPPER AUXILIAR ─────────────────────────────────────────────────────
        private static PacienteResponseDto MapToResponseDto(Paciente paciente)
        {
            return new PacienteResponseDto
            {
                Id = paciente.Id,
                Nome = paciente.Nome,
                Cpf = paciente.Cpf,
                Telefone = paciente.Telefone,
                DataCadastro = paciente.DataCadastro,
                TotalConsultas = paciente.Consultas?.Count ?? 0
            };
        }
    }
}
