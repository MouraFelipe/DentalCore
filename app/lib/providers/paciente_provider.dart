import 'package:flutter/material.dart';
import '../models/paciente_model.dart';
import '../services/api_service.dart';

class PacienteProvider with ChangeNotifier {
  final ApiService _apiService;
  List<PacienteModel> _pacientes = [];
  bool _isLoading = false;
  String? _erro;

  PacienteProvider(this._apiService);

  List<PacienteModel> get pacientes => _pacientes;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  Future<void> fetchPacientes() async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    final response = await _apiService.getPacientes();
    if (response.sucesso) {
      _pacientes = response.dados ?? [];
    } else {
      _erro = response.mensagem;
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> adicionarPaciente(PacienteModel paciente) async {
    final response = await _apiService.criarPaciente(paciente);
    if (response.sucesso) {
      _pacientes.add(response.dados!);
      notifyListeners();
      return true;
    }
    _erro = response.mensagem;
    notifyListeners();
    return false;
  }
}
