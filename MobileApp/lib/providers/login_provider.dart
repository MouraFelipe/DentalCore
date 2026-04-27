import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import '../models/api_response.dart';
import '../services/api_service.dart';

class LoginProvider with ChangeNotifier {
  final ApiService _apiService;
  AuthModel? _auth;
  bool _isLoading = false;

  LoginProvider(this._apiService) {
    _loadSession();
  }

  AuthModel? get auth => _auth;
  bool get isAuthenticated => _auth != null && !_auth!.isExpired;
  bool get isLoading => _isLoading;

  Future<ApiResponse<AuthModel>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    final response = await _apiService.login(email, password);

    if (response.sucesso && response.dados != null) {
      _auth = response.dados;
      _apiService.setToken(_auth!.token);
      await _saveSession(_auth!.token);
    }

    _isLoading = false;
    notifyListeners();
    return response;
  }

  Future<void> logout() async {
    _auth = null;
    _apiService.setToken(null);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    notifyListeners();
  }

  Future<void> _saveSession(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null) {
      _apiService.setToken(token);
      // Nota: Em um app real, aqui buscaríamos os dados do usuário com o token
      // Para o MVP, vamos assumir que o token ainda é válido ou deixar o interceptor tratar o 401
    }
  }
}
