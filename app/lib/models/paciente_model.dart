class PacienteModel {
  final int id;
  final String nome;
  final String cpf;
  final String telefone;

  PacienteModel({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.telefone,
  });

  factory PacienteModel.fromJson(Map<String, dynamic> json) {
    return PacienteModel(
      id: json['id'],
      nome: json['nome'] ?? '',
      cpf: json['cpf'] ?? '',
      telefone: json['telefone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
      'telefone': telefone,
    };
  }
}
