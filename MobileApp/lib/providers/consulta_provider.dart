import 'package:flutter/material.dart';
import '../models/consulta_model.dart';
import '../services/api_service.dart';

class ConsultaProvider with ChangeNotifier {
  final ApiService _apiService;
  List<ConsultaModel> _consultasDoDia = [];
  bool _isLoading = false;
  DateTime _dataSelecionada = DateTime.now();
  String? _errorMessage;

  ConsultaProvider(this._apiService);

  List<ConsultaModel> get consultas => _consultasDoDia;
  bool get isLoading => _isLoading;
  DateTime get dataSelecionada => _dataSelecionada;
  String? get errorMessage => _errorMessage;

  Future<void> carregarConsultas(DateTime data) async {
    _dataSelecionada = data;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final response = await _apiService.getConsultasDoDia(data);
    
    if (response.sucesso) {
      _consultasDoDia = response.dados ?? [];
    } else {
      _errorMessage = response.mensagem;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> atualizarStatusConsulta(int id, int novoStatus) async {
    final response = await _apiService.atualizarStatus(id, novoStatus);
    if (response.sucesso) {
      final index = _consultasDoDia.indexWhere((c) => c.id == id);
      if (index != -1) {
        _consultasDoDia[index] = response.dados!;
        notifyListeners();
      }
      return true;
    }
    _errorMessage = response.mensagem;
    notifyListeners();
    return false;
  }
}
