using DentalCore.API.Wrappers;
using DentalCore.API.Data;
using DentalCore.API.DTOs.Financeiro;
using DentalCore.API.Enums;
using DentalCore.API.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace DentalCore.API.Controllers;

[ApiController]
[Route("api/[controller]")]
[Produces("application/json")]
public class FinanceiroController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly ILogger<FinanceiroController> _logger;

    private static readonly TimeZoneInfo _fusoHorarioBrasil =
        TimeZoneInfo.FindSystemTimeZoneById("E. South America Standard Time");

    public FinanceiroController(AppDbContext context, ILogger<FinanceiroController> logger)
    {
        _context = context;
        _logger  = logger;
    }

    [HttpPost("consultas/{consultaId:int}/pagamento")]
    public async Task<IActionResult> LancarPagamento(int consultaId, [FromBody] LancarPagamentoDto dto)
    {
        if (!ModelState.IsValid)
        {
            var erros = ModelState.Values.SelectMany(v => v.Errors).Select(e => e.ErrorMessage);
            return BadRequest(ApiResponse<PagamentoResponseDto>.Erro($"Dados inválidos: {string.Join(" | ", erros)}"));
        }

        var consulta = await _context.Consultas
            .Include(c => c.Paciente)
            .Include(c => c.Pagamentos)
            .FirstOrDefaultAsync(c => c.Id == consultaId);

        if (consulta is null)
            return NotFound(ApiResponse<PagamentoResponseDto>.Erro($"Consulta {consultaId} não encontrada ou inativa."));

        if (consulta.StatusConsulta != StatusConsulta.Realizada)
            return BadRequest(ApiResponse<PagamentoResponseDto>.Erro($"Só é possível lançar pagamento em consultas Realizadas. Status atual: '{consulta.StatusConsulta}'."));

        var jaTemPagamentoPago = consulta.Pagamentos.Any(p => p.StatusPagamento == StatusPagamento.Pago);
        if (jaTemPagamentoPago && dto.StatusPagamento == StatusPagamento.Pago)
            return BadRequest(ApiResponse<PagamentoResponseDto>.Erro("Esta consulta já possui um pagamento confirmado. Use o endpoint de confirmação para pagamentos pendentes."));

        var agoraLocal = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, _fusoHorarioBrasil);

        var pagamento = new Pagamento
        {
            ConsultaId = consultaId,
            Valor = dto.Valor,
            FormaPagamento = dto.FormaPagamento,
            StatusPagamento = dto.StatusPagamento,
            DataPagamento = dto.StatusPagamento == StatusPagamento.Pago ? agoraLocal : null,
            DataLancamento = agoraLocal,
            Observacao = dto.Observacao
        };

        _context.Pagamentos.Add(pagamento);
        await _context.SaveChangesAsync();

        _logger.LogInformation("Pagamento lançado. PagId: {Id} | ConsultaId: {CId} | Valor: {Valor}", pagamento.Id, consultaId, dto.Valor);

        var response = MapToResponseDto(pagamento, consulta.Paciente!.Nome, consulta.DataHora);

        return CreatedAtAction(nameof(ListarPagamentosConsulta), new { consultaId }, ApiResponse<PagamentoResponseDto>.Ok(response, "Pagamento lançado com sucesso."));
    }

    [HttpPatch("pagamentos/{pagamentoId:int}/confirmar")]
    public async Task<IActionResult> ConfirmarPagamento(int pagamentoId, [FromBody] ConfirmarPagamentoDto dto)
    {
        var pagamento = await _context.Pagamentos
            .Include(p => p.Consulta).ThenInclude(c => c!.Paciente)
            .FirstOrDefaultAsync(p => p.Id == pagamentoId);

        if (pagamento is null)
            return NotFound(ApiResponse<PagamentoResponseDto>.Erro($"Pagamento {pagamentoId} não encontrado."));

        if (pagamento.StatusPagamento == StatusPagamento.Pago)
            return BadRequest(ApiResponse<PagamentoResponseDto>.Erro("Este pagamento já está confirmado."));

        var agoraLocal = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, _fusoHorarioBrasil);

        if (dto.FormaPagamento.HasValue)
            pagamento.FormaPagamento = dto.FormaPagamento.Value;

        if (dto.Observacao is not null)
            pagamento.Observacao = dto.Observacao;

        pagamento.StatusPagamento = StatusPagamento.Pago;
        pagamento.DataPagamento = agoraLocal;

        await _context.SaveChangesAsync();

        _logger.LogInformation("Pagamento confirmado. PagId: {Id} | Valor: {Valor}", pagamento.Id, pagamento.Valor);

        var nomePaciente = pagamento.Consulta?.Paciente?.Nome ?? "—";
        var response = MapToResponseDto(pagamento, nomePaciente, pagamento.Consulta?.DataHora ?? DateTime.UtcNow);

        return Ok(ApiResponse<PagamentoResponseDto>.Ok(response, "Pagamento confirmado com sucesso."));
    }

    [HttpGet("consultas/{consultaId:int}/pagamentos")]
    public async Task<IActionResult> ListarPagamentosConsulta(int consultaId)
    {
        var consulta = await _context.Consultas
            .Include(c => c.Paciente)
            .Include(c => c.Pagamentos)
            .FirstOrDefaultAsync(c => c.Id == consultaId);

        if (consulta is null)
            return NotFound(ApiResponse<List<PagamentoResponseDto>>.Erro($"Consulta {consultaId} não encontrada."));

        var response = consulta.Pagamentos
            .OrderByDescending(p => p.DataLancamento)
            .Select(p => MapToResponseDto(p, consulta.Paciente!.Nome, consulta.DataHora))
            .ToList();

        return Ok(ApiResponse<List<PagamentoResponseDto>>.Ok(response, $"{response.Count} pagamento(s) encontrado(s)."));
    }

    [HttpGet("resumo")]
    public async Task<IActionResult> ResumoDiario([FromQuery] DateTime? data)
    {
        var agoraLocal = TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, _fusoHorarioBrasil);
        var diaAlvo = (data ?? agoraLocal).Date;
        var inicioDia = diaAlvo;
        var fimDia = diaAlvo.AddDays(1);

        var pagamentos = await _context.Pagamentos
            .Where(p => p.DataLancamento >= inicioDia && p.DataLancamento < fimDia)
            .Select(p => new { p.Valor, p.StatusPagamento, p.FormaPagamento })
            .ToListAsync();

        var recebido = pagamentos.Where(p => p.StatusPagamento == StatusPagamento.Pago).Sum(p => p.Valor);
        var pendente = pagamentos.Where(p => p.StatusPagamento == StatusPagamento.Pendente).Sum(p => p.Valor);

        decimal Soma(FormaPagamento forma) => pagamentos.Where(p => p.StatusPagamento == StatusPagamento.Pago && p.FormaPagamento == forma).Sum(p => p.Valor);

        var resumo = new ResumoDiarioDto
        {
            Data = diaAlvo,
            TotalRecebido = recebido,
            TotalPendente = pendente,
            TotalFaturado = recebido + pendente,
            TotalDinheiro = Soma(FormaPagamento.Dinheiro),
            TotalPix = Soma(FormaPagamento.Pix),
            TotalCartao = Soma(FormaPagamento.Cartao),
            TotalConvenio = Soma(FormaPagamento.Convenio),
            QtdPagamentosLancados = pagamentos.Count,
            QtdPendentes = pagamentos.Count(p => p.StatusPagamento == StatusPagamento.Pendente)
        };

        return Ok(ApiResponse<ResumoDiarioDto>.Ok(resumo));
    }

    [HttpGet("pendentes")]
    public async Task<IActionResult> ListarPendentes()
    {
        var pendentes = await _context.Pagamentos
            .Include(p => p.Consulta).ThenInclude(c => c!.Paciente)
            .Where(p => p.StatusPagamento == StatusPagamento.Pendente)
            .OrderBy(p => p.DataLancamento)
            .ToListAsync();

        var response = pendentes.Select(p => MapToResponseDto(p, p.Consulta?.Paciente?.Nome ?? "—", p.Consulta?.DataHora ?? DateTime.UtcNow)).ToList();

        return Ok(ApiResponse<List<PagamentoResponseDto>>.Ok(response, $"{response.Count} pagamento(s) pendente(s)."));
    }

    private PagamentoResponseDto MapToResponseDto(Pagamento pagamento, string nomePaciente, DateTime dataHoraConsulta)
    {
        var horaLocal = TimeZoneInfo.ConvertTimeFromUtc(dataHoraConsulta.ToUniversalTime(), _fusoHorarioBrasil).ToString("HH:mm");

        return new PagamentoResponseDto
        {
            Id = pagamento.Id,
            ConsultaId = pagamento.ConsultaId,
            NomePaciente = nomePaciente,
            HoraConsulta = horaLocal,
            Valor = pagamento.Valor,
            FormaPagamento = (int)pagamento.FormaPagamento,
            FormaPagamentoLabel = pagamento.FormaPagamento.ToString(),
            StatusPagamento = (int)pagamento.StatusPagamento,
            StatusPagamentoLabel = pagamento.StatusPagamento.ToString(),
            DataPagamento = pagamento.DataPagamento,
            DataLancamento = pagamento.DataLancamento,
            Observacao = pagamento.Observacao
        };
    }
}
