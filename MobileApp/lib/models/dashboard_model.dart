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
      data: DateTime.parse(json['data'] as String).toLocal(),
      total: json['total'] as int? ?? 0,
      agendadas: json['agendadas'] as int? ?? 0,
      realizadas: json['realizadas'] as int? ?? 0,
      faltas: json['faltas'] as int? ?? 0,
      canceladas: json['canceladas'] as int? ?? 0,
    );
  }
}
