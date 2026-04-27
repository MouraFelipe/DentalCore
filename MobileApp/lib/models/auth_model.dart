import '../enums/role.dart';

class AuthModel {
  final String token;
  final String nome;
  final String email;
  final Role role;
  final DateTime expiration;

  AuthModel({
    required this.token,
    required this.nome,
    required this.email,
    required this.role,
    required this.expiration,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      token: json['token'],
      nome: json['nome'],
      email: json['email'],
      role: Role.values.firstWhere((e) => e.toString().contains(json['role'])),
      expiration: DateTime.parse(json['expiration']),
    );
  }

  bool get isExpired => DateTime.now().isAfter(expiration);
}
