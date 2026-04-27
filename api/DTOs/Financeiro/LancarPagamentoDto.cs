using System.ComponentModel.DataAnnotations;
using DentalCore.API.Enums;

namespace DentalCore.API.DTOs.Financeiro;

public class LancarPagamentoDto
{
    [Required(ErrorMessage = "O valor é obrigatório.")]
    [Range(0.01, double.MaxValue, ErrorMessage = "O valor deve ser maior que zero.")]
    public decimal Valor { get; set; }

    [Required(ErrorMessage = "A forma de pagamento é obrigatória.")]
    [EnumDataType(typeof(FormaPagamento), ErrorMessage = "Forma inválida. Use: 1=Dinheiro, 2=Pix, 3=Cartão, 4=Convênio.")]
    public FormaPagamento FormaPagamento { get; set; }

    [Required(ErrorMessage = "O status do pagamento é obrigatório.")]
    [EnumDataType(typeof(StatusPagamento), ErrorMessage = "Status inválido. Use: 1=Pago, 2=Pendente.")]
    public StatusPagamento StatusPagamento { get; set; }

    [MaxLength(300)]
    public string? Observacao { get; set; }
}
