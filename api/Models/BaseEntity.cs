namespace DentalCore.API.Models;

/// <summary>
/// Classe base com campos comuns a todas as entidades.
/// Centraliza Id e Soft Delete para evitar repetição.
/// </summary>
public abstract class BaseEntity
{
    /// <summary>
    /// Identificador único da entidade (PK auto-increment).
    /// </summary>
    public int Id { get; set; }

    /// <summary>
    /// Data e hora da exclusão lógica (Soft Delete).
    /// Nulo significa que o registro está ativo.
    /// </summary>
    public DateTime? DataExclusao { get; set; }
}
