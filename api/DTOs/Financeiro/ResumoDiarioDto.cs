namespace DentalCore.API.DTOs.Financeiro;

public class ResumoDiarioDto
{
    public DateTime Data             { get; set; }

    public decimal TotalRecebido     { get; set; }
    public decimal TotalPendente     { get; set; }
    public decimal TotalFaturado     { get; set; }

    public decimal TotalDinheiro     { get; set; }
    public decimal TotalPix          { get; set; }
    public decimal TotalCartao       { get; set; }
    public decimal TotalConvenio     { get; set; }

    public int QtdPagamentosLancados { get; set; }
    public int QtdPendentes          { get; set; }
}
