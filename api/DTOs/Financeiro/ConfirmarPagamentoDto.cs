using System.ComponentModel.DataAnnotations;
using DentalCore.API.Enums;

namespace DentalCore.API.DTOs.Financeiro;

public class ConfirmarPagamentoDto
{
    [EnumDataType(typeof(FormaPagamento), ErrorMessage = "Forma inválida. Use: 1=Dinheiro, 2=Pix, 3=Cartão, 4=Convênio.")]
    public FormaPagamento? FormaPagamento { get; set; }

    [MaxLength(300)]
    public string? Observacao { get; set; }
}
