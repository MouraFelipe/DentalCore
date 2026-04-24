using System.ComponentModel.DataAnnotations;
using DentalCore.API.Enums;

namespace DentalCore.API.DTOs.Consulta;

public class AtualizarStatusDto
{
    [Required(ErrorMessage = "O novo status é obrigatório.")]
    [EnumDataType(typeof(StatusConsulta), ErrorMessage = "Status inválido.")]
    public StatusConsulta NovoStatus { get; set; }
}
