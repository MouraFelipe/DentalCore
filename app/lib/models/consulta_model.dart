import 'package:intl/intl.dart';

/// Espelho exato do ConsultaResponseDto do backend.
class ConsultaModel {
  final int id;
  final int pacienteId;
  final String nomePaciente;
  final DateTime dataHora;
  final int statusConsulta;         
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
      id:                  json['id'],
      pacienteId:          json['pacienteId'],
      nomePaciente:        json['nomePaciente'] ?? '',
      dataHora:            DateTime.parse(json['dataHora']),
      statusConsulta:      json['statusConsulta'],
      statusConsultaLabel: json['statusConsultaLabel'] ?? '',
      observacao:          json['observacao'],
    );
  }

  String get horaFormatada => DateFormat('HH:mm').format(dataHora);
  String get dataFormatada => DateFormat('dd/MM/yyyy').format(dataHora);

  bool get statusFinal => statusConsulta == 2 || statusConsulta == 4;
  bool get podeAtualizarStatus => statusConsulta == 1 || statusConsulta == 3;
}
