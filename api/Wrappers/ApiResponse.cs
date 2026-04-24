namespace DentalCore.API.Wrappers;

/// <summary>
/// Envelope padronizado para todas as respostas da API.
/// Garantindo que o cliente frontend sempre receba um formato conhecido.
/// </summary>
public class ApiResponse<T>
{
    public bool Sucesso { get; set; }
    public T? Dados { get; set; }
    public string? Mensagem { get; set; }

    public ApiResponse()
    {
    }

    public ApiResponse(T dados, string mensagem = "")
    {
        Sucesso = true;
        Dados = dados;
        Mensagem = mensagem;
    }

    public ApiResponse(string mensagem)
    {
        Sucesso = false;
        Mensagem = mensagem;
    }

    public static ApiResponse<T> Ok(T dados, string mensagem = "") => new(dados, mensagem);
    public static ApiResponse<T> Erro(string mensagem) => new(mensagem);
}
