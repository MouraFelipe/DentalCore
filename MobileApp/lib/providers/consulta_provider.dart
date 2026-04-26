import 'package:flutter/material.dart';
import '../models/consulta_model.dart';
import '../services/api_service.dart';

class ConsultaProvider with ChangeNotifier {
  final ApiService _apiService;
  List<ConsultaModel> _consultas = [];
  bool _isLoading = false;
  DateTime _diaSelecionado = DateTime.now();
  String? _erro;

  ConsultaProvider(this._apiService);

  List<ConsultaModel> get consultas => _consultas;
  bool get isLoading => _isLoading;
  DateTime get diaSelecionado => _diaSelecionado;
  String? get erro => _erro;

  Future<void> fetchConsultas(DateTime data) async {
    _diaSelecionado = data;
    _isLoading = true;
    _erro = null;
    notifyListeners();

    final response = await _apiService.getConsultasDoDia(data);
    
    if (response.sucesso) {
      _consultas = response.dados ?? [];
    } else {
      _erro = response.mensagem;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> atualizarStatus(int id, int novoStatus) async {
    final response = await _apiService.atualizarStatus(id, novoStatus);
    if (response.sucesso) {
      final index = _consultas.indexWhere((c) => c.id == id);
      if (index != -1) {
        _consultas[index] = response.dados!;
        notifyListeners();
      }
      return true;
    }
    _erro = response.mensagem;
    notifyListeners();
    return false;
  }
}
