class ApiResponse<T> {
  final bool sucesso;
  final T? dados;
  final String? mensagem;

  ApiResponse({
    required this.sucesso,
    this.dados,
    this.mensagem,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json)? fromJsonT) {
    return ApiResponse<T>(
      sucesso: json['sucesso'] as bool? ?? false,
      mensagem: json['mensagem'] as String?,
      dados: json['sucesso'] == true && json['dados'] != null && fromJsonT != null
          ? fromJsonT(json['dados'])
          : null,
    );
  }
}
