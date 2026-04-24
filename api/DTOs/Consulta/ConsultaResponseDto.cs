namespace DentalCore.API.DTOs.Consulta;

public class ConsultaResponseDto
{
    public int Id { get; set; }
    public int PacienteId { get; set; }
    public string NomePaciente { get; set; } = string.Empty;
    public DateTime DataHora { get; set; }
    public int StatusConsulta { get; set; }
    public string StatusConsultaLabel { get; set; } = string.Empty;
    public string? Observacao { get; set; }
}
