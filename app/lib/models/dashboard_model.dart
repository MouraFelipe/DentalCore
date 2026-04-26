import 'package:intl/intl.dart';

/// Espelho exato do DashboardDto do backend.
class DashboardModel {
  final DateTime data;
  final int total;
  final int agendadas;
  final int realizadas;
  final int faltas;
  final int canceladas;

  DashboardModel({
    required this.data,
    required this.total,
    required this.agendadas,
    required this.realizadas,
    required this.faltas,
    required this.canceladas,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      data:       DateTime.parse(json['data']),
      total:      json['total']      ?? 0,
      agendadas:  json['agendadas']  ?? 0,
      realizadas: json['realizadas'] ?? 0,
      faltas:     json['faltas']     ?? 0,
      canceladas: json['canceladas'] ?? 0,
    );
  }

  String get dataFormatada => DateFormat("dd 'de' MMMM", 'pt_BR').format(data);
  double get taxaRealizacao => total == 0 ? 0 : realizadas / total;
}
