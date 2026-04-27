using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DentalCore.API.Enums;

namespace DentalCore.API.Models;

/// <summary>
/// Representa um pagamento vinculado a uma consulta.
/// </summary>
public class Pagamento : BaseEntity
{
    [Required]
    public int ConsultaId { get; set; }

    [Required]
    [Column(TypeName = "decimal(10,2)")]
    [Range(0.01, double.MaxValue, ErrorMessage = "O valor deve ser maior que zero.")]
    public decimal Valor { get; set; }

    [Required]
    public FormaPagamento FormaPagamento { get; set; }

    [Required]
    public StatusPagamento StatusPagamento { get; set; } = StatusPagamento.Pendente;

    public DateTime? DataPagamento { get; set; }

    public DateTime DataLancamento { get; set; } = DateTime.UtcNow;

    [MaxLength(300)]
    public string? Observacao { get; set; }

    [ForeignKey(nameof(ConsultaId))]
    public Consulta? Consulta { get; set; }
}
