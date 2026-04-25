namespace DentalCore.API.DTOs.Paciente;

public class PacienteResponseDto
{
    public int Id { get; set; }
    public string Nome { get; set; } = string.Empty;
    public string Cpf { get; set; } = string.Empty;
    public string? Telefone { get; set; }
    public DateTime DataCadastro { get; set; }
    public int TotalConsultas { get; set; }
}
