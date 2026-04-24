using System.ComponentModel.DataAnnotations;

namespace DentalCore.API.DTOs.Consulta;

public class ConsultaRequestDto
{
    [Required(ErrorMessage = "O PacienteId é obrigatório.")]
    [Range(1, int.MaxValue, ErrorMessage = "PacienteId inválido.")]
    public int PacienteId { get; set; }

    [Required(ErrorMessage = "A data e hora são obrigatórias.")]
    public DateTime DataHora { get; set; }

    [MaxLength(500, ErrorMessage = "Observação deve ter no máximo 500 caracteres.")]
    public string? Observacao { get; set; }
}
