import 'package:flutter/material.dart';
import '../models/consulta_model.dart';
import '../services/api_service.dart';

class AgendaProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Consulta> _consultas = [];
  bool _isLoading = false;
  DateTime _diaSelecionado = DateTime.now();

  List<Consulta> get consultas => _consultas;
  bool get isLoading => _isLoading;
  DateTime get diaSelecionado => _diaSelecionado;

  Future<void> fetchConsultas(DateTime data) async {
    _diaSelecionado = data;
    _isLoading = true;
    notifyListeners();

    final response = await _apiService.getConsultasPorDia(data);
    if (response.sucesso) {
      _consultas = response.dados ?? [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> mudarStatus(int id, int novoStatus) async {
    final response = await _apiService.atualizarStatusConsulta(id, novoStatus);
    if (response.sucesso) {
      final index = _consultas.indexWhere((c) => c.id == id);
      if (index != -1) {
        _consultas[index] = response.dados!;
        notifyListeners();
      }
      return true;
    }
    return false;
  }
}
