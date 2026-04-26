import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/api_response.dart';
import '../models/consulta_model.dart';
import '../models/dashboard_model.dart';
import '../models/paciente_model.dart';

/// Serviço central de comunicação com a API DentalCore (.NET 8).
class ApiService {
  late final Dio _dio;

  // Ajustado para a porta 5273 conforme launchSettings.json do backend
  static String get _baseUrl {
    if (!kIsWeb && Platform.isAndroid) {
      return 'http://10.0.2.2:5273/api';
    }
    return 'http://localhost:5273/api';
  }

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl:        _baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers:        {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(LogInterceptor(
      requestBody:  true,
      responseBody: true,
      logPrint:     (obj) => debugPrint('[API] $obj'),
    ));
  }

  // ── PACIENTES ─────────────────────────────────────────────────────────────
  Future<ApiResponse<List<PacienteModel>>> getPacientes() async {
    try {
      final response = await _dio.get('/paciente');
      return ApiResponse<List<PacienteModel>>.fromJson(
        response.data,
        (dados) => (dados as List).map((item) => PacienteModel.fromJson(item)).toList(),
      );
    } on DioException catch (e) {
      return _tratarErro<List<PacienteModel>>(e);
    }
  }

  Future<ApiResponse<PacienteModel>> criarPaciente(PacienteModel paciente) async {
    try {
      final response = await _dio.post('/paciente', data: paciente.toJson());
      return ApiResponse<PacienteModel>.fromJson(
        response.data,
        (dados) => PacienteModel.fromJson(dados),
      );
    } on DioException catch (e) {
      return _tratarErro<PacienteModel>(e);
    }
  }

  // ── CONSULTAS ─────────────────────────────────────────────────────────────
  Future<ApiResponse<List<ConsultaModel>>> getConsultasDoDia(DateTime? data) async {
    try {
      final queryParams = data != null
          ? {'data': _formatarData(data)}
          : <String, dynamic>{};

      final response = await _dio.get('/consulta/dia', queryParameters: queryParams);

      return ApiResponse<List<ConsultaModel>>.fromJson(
        response.data,
        (dados) => (dados as List).map((item) => ConsultaModel.fromJson(item)).toList(),
      );
    } on DioException catch (e) {
      return _tratarErro<List<ConsultaModel>>(e);
    }
  }

  Future<ApiResponse<DashboardModel>> getDashboard(DateTime? data) async {
    try {
      final queryParams = data != null
          ? {'data': _formatarData(data)}
          : <String, dynamic>{};

      final response = await _dio.get('/consulta/dashboard', queryParameters: queryParams);

      return ApiResponse<DashboardModel>.fromJson(
        response.data,
        (dados) => DashboardModel.fromJson(dados),
      );
    } on DioException catch (e) {
      return _tratarErro<DashboardModel>(e);
    }
  }

  Future<ApiResponse<ConsultaModel>> atualizarStatus(int id, int novoStatus) async {
    try {
      final response = await _dio.patch('/consulta/$id/status', data: {'novoStatus': novoStatus});

      return ApiResponse<ConsultaModel>.fromJson(
        response.data,
        (dados) => ConsultaModel.fromJson(dados),
      );
    } on DioException catch (e) {
      return _tratarErro<ConsultaModel>(e);
    }
  }

  String _formatarData(DateTime data) =>
      '${data.year.toString().padLeft(4, '0')}-'
      '${data.month.toString().padLeft(2, '0')}-'
      '${data.day.toString().padLeft(2, '0')}';

  ApiResponse<T> _tratarErro<T>(DioException e) {
    if (e.response?.data != null && e.response!.data is Map) {
      final mensagem = e.response!.data['mensagem'] as String?;
      return ApiResponse<T>.erro(mensagem ?? 'Erro desconhecido retornado pelo servidor.');
    }
    return ApiResponse<T>.erro("Erro de comunicação com o servidor.");
  }
}
