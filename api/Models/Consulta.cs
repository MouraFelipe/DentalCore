using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using DentalCore.API.Enums;

namespace DentalCore.API.Models;

/// <summary>
/// Representa um agendamento/consulta odontológica.
/// </summary>
public class Consulta : BaseEntity
{
    // ── Chave Estrangeira ──────────────────────────────────────
    /// <summary>FK para o paciente dono desta consulta.</summary>
    [Required]
    public int PacienteId { get; set; }

    // ── Dados da Consulta ──────────────────────────────────────
    /// <summary>Data e hora exata do agendamento (UTC no banco).</summary>
    [Required]
    public DateTime DataHora { get; set; }

    /// <summary>Duração da consulta em minutos. Necessário para checar conflitos.</summary>
    [Required]
    public int DuracaoMinutos { get; set; } = 30;

    /// <summary>Status atual da consulta (Agendada, Realizada, Faltou, Cancelada).</summary>
    [Required]
    public StatusConsulta StatusConsulta { get; set; } = StatusConsulta.Agendada;

    /// <summary>Observações livres (procedimento, anestesia, plano de tratamento, etc.).</summary>
    [MaxLength(500)]
    public string? Observacao { get; set; }

    // ── Propriedade Calculada (Descartada do BD) ───────────────
    [NotMapped]
    public DateTime DataHoraFim => DataHora.AddMinutes(DuracaoMinutos);

    // ── Navegação ──────────────────────────────────────────────
    /// <summary>Entidade Paciente associada (carregada via Include).</summary>
    [ForeignKey(nameof(PacienteId))]
    public Paciente? Paciente { get; set; }
}
