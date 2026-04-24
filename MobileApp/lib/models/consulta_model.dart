class ConsultaModel {
  final int id;
  final int pacienteId;
  final String nomePaciente;
  final DateTime dataHora;
  final int statusConsulta; // 1=Agendada, 2=Realizada, 3=Faltou, 4=Cancelada
  final String statusConsultaLabel;
  final String? observacao;

  ConsultaModel({
    required this.id,
    required this.pacienteId,
    required this.nomePaciente,
    required this.dataHora,
    required this.statusConsulta,
    required this.statusConsultaLabel,
    this.observacao,
  });

  factory ConsultaModel.fromJson(Map<String, dynamic> json) {
    return ConsultaModel(
      id: json['id'] as int,
      pacienteId: json['pacienteId'] as int,
      nomePaciente: json['nomePaciente'] as String,
      dataHora: DateTime.parse(json['dataHora'] as String).toLocal(),
      statusConsulta: json['statusConsulta'] as int,
      statusConsultaLabel: json['statusConsultaLabel'] as String,
      observacao: json['observacao'] as String?,
    );
  }
}
