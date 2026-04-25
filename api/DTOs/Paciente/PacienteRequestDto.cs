using System.ComponentModel.DataAnnotations;

namespace DentalCore.API.DTOs.Paciente;

public class PacienteRequestDto
{
    [Required(ErrorMessage = "Nome é obrigatório.")]
    [MaxLength(150, ErrorMessage = "Nome não pode exceder 150 caracteres.")]
    [MinLength(3, ErrorMessage = "Nome deve ter no mínimo 3 caracteres.")]
    public string Nome { get; set; } = string.Empty;

    [Required(ErrorMessage = "CPF é obrigatório.")]
    [RegularExpression(@"^\d{3}\.\d{3}\.\d{3}-\d{2}$|^\d{11}$", ErrorMessage = "CPF inválido (formato: 000.000.000-00 ou 00000000000).")]
    public string Cpf { get; set; } = string.Empty;

    [MaxLength(20, ErrorMessage = "Telefone não pode exceder 20 caracteres.")]
    [RegularExpression(@"^[\d\s\-\(\)]+$", ErrorMessage = "Telefone inválido.")]
    public string? Telefone { get; set; }
}
