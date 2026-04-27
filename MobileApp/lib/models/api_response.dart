/// Espelho exato do `ApiResponse<T>` do backend C#.
/// Envelope padrão de TODAS as respostas da API.
class ApiResponse<T> {
  final bool sucesso;
  final T? dados;
  final String? mensagem;

  ApiResponse({
    required this.sucesso,
    this.dados,
    this.mensagem,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return ApiResponse<T>(
      sucesso:  json['sucesso'] ?? false,
      mensagem: json['mensagem'],
      dados: json['dados'] != null ? fromJsonT(json['dados']) : null,
    );
  }

  factory ApiResponse.erro(String mensagem) {
    return ApiResponse<T>(sucesso: false, mensagem: mensagem);
  }
}
