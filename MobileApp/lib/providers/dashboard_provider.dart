import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import '../services/api_service.dart';

class DashboardProvider with ChangeNotifier {
  final ApiService _apiService;
  DashboardModel? _dashboard;
  bool _isLoading = false;
  String? _erro;

  DashboardProvider(this._apiService);

  DashboardModel? get dashboard => _dashboard;
  bool get isLoading => _isLoading;
  String? get erro => _erro;

  Future<void> fetchDashboard(DateTime? data) async {
    _isLoading = true;
    _erro = null;
    notifyListeners();

    final response = await _apiService.getDashboard(data);
    
    if (response.sucesso) {
      _dashboard = response.dados;
    } else {
      _erro = response.mensagem;
    }

    _isLoading = false;
    notifyListeners();
  }
}
