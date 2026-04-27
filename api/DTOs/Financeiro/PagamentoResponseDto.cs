using DentalCore.API.Enums;

namespace DentalCore.API.DTOs.Financeiro;

public class PagamentoResponseDto
{
    public int     Id               { get; set; }
    public int     ConsultaId       { get; set; }
    public string  NomePaciente     { get; set; } = string.Empty;
    public string  HoraConsulta     { get; set; } = string.Empty;
    public decimal Valor            { get; set; }
    public int     FormaPagamento   { get; set; }
    public string  FormaPagamentoLabel  { get; set; } = string.Empty;
    public int     StatusPagamento  { get; set; }
    public string  StatusPagamentoLabel { get; set; } = string.Empty;
    public DateTime? DataPagamento  { get; set; }
    public DateTime  DataLancamento { get; set; }
    public string?   Observacao     { get; set; }
}
