using System.ComponentModel.DataAnnotations;

namespace DentalCore.API.Models;

/// <summary>
/// Representa um paciente cadastrado na clínica.
/// </summary>
public class Paciente : BaseEntity
{
    /// <summary>Nome completo do paciente.</summary>
    [Required]
    [MaxLength(150)]
    public string Nome { get; set; } = string.Empty;

    /// <summary>CPF do paciente (único).</summary>
    [Required]
    [MaxLength(14)]
    public string Cpf { get; set; } = string.Empty;

    /// <summary>Telefone para contato (WhatsApp, ligação).</summary>
    [MaxLength(20)]
    public string? Telefone { get; set; }

    /// <summary>Data e hora em que o paciente foi cadastrado no sistema (UTC).</summary>
    public DateTime DataCadastro { get; set; } = DateTime.UtcNow;

    // ── Navegação ──────────────────────────────────────────────
    /// <summary>Coleção de consultas vinculadas a este paciente.</summary>
    public ICollection<Consulta> Consultas { get; set; } = new List<Consulta>();
}
