namespace DentalCore.API.Enums;

/// <summary>
/// Define os possíveis estados de uma consulta odontológica.
/// </summary>
public enum StatusConsulta
{
    /// <summary>Consulta marcada, aguardando realização.</summary>
    Agendada = 1,

    /// <summary>Consulta concluída com sucesso.</summary>
    Realizada = 2,

    /// <summary>Paciente não compareceu sem aviso.</summary>
    Faltou = 3,

    /// <summary>Consulta cancelada pela clínica ou paciente.</summary>
    Cancelada = 4
}
