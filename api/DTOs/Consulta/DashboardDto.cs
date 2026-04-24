namespace DentalCore.API.DTOs.Consulta;

public class DashboardDto
{
    public DateTime Data { get; set; }
    public int Total { get; set; }
    public int Agendadas { get; set; }
    public int Realizadas { get; set; }
    public int Faltas { get; set; }
    public int Canceladas { get; set; }
}
