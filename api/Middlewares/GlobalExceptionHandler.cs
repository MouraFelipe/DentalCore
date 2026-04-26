using DentalCore.API.Wrappers;
using Microsoft.AspNetCore.Diagnostics;
using System.Net;

namespace DentalCore.API.Middlewares;

/// <summary>
/// Captura qualquer exceção não tratada na aplicação e formata a saída
/// garantindo que o Flutter (Frontend) sempre receba o ApiResponse<T>.
/// </summary>
public class GlobalExceptionHandler : IExceptionHandler
{
    private readonly ILogger<GlobalExceptionHandler> _logger;

    public GlobalExceptionHandler(ILogger<GlobalExceptionHandler> logger)
    {
        _logger = logger;
    }

    public async ValueTask<bool> TryHandleAsync(
        HttpContext httpContext,
        Exception exception,
        CancellationToken cancellationToken)
    {
        // 1. Loga o erro real no console/servidor para o desenvolvedor investigar
        _logger.LogError(exception, "Erro não tratado capturado: {Mensagem}", exception.Message);

        // 2. Define o status HTTP padrão para erro interno
        httpContext.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
        httpContext.Response.ContentType = "application/json";

        // 3. Monta a resposta amigável para o usuário/app
        var resposta = ApiResponse<object>.Erro("Ocorreu um erro interno no servidor. Nossa equipe já foi notificada.");

        // Se for um erro conhecido de validação, podemos tratar diferente
        if (exception is ArgumentException || exception is InvalidOperationException)
        {
            httpContext.Response.StatusCode = (int)HttpStatusCode.BadRequest;
            resposta = ApiResponse<object>.Erro(exception.Message);
        }

        // 4. Escreve o JSON na resposta
        await httpContext.Response.WriteAsJsonAsync(resposta, cancellationToken);

        // Retorna true para avisar ao pipeline do .NET que o erro já foi tratado
        return true; 
    }
}
