import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/consulta_model.dart';
import '../models/dashboard_model.dart';

class ApiService {
  final Dio _dio;

  // Use a URL correta dependendo do ambiente. Ex: 10.0.2.2 para Android Emulator.
  // Como estamos testando localmente, ajuste a baseUrl do Backend.
  ApiService() : _dio = Dio(BaseOptions(
    baseUrl: 'https://localhost:7147/api', // Ajuste a porta se necessário
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  /// Lista consultas de um dia específico
  Future<ApiResponse<List<ConsultaModel>>> getDia(DateTime data) async {
    try {
      final response = await _dio.get(
        '/consultas/dia',
        queryParameters: {'data': data.toIso8601String()},
      );

      return ApiResponse<List<ConsultaModel>>.fromJson(
        response.data,
        (jsonList) => (jsonList as List).map((i) => ConsultaModel.fromJson(i)).toList(),
      );
    } catch (e) {
      return _handleError<List<ConsultaModel>>(e);
    }
  }

  /// Pega as métricas do Dashboard (Cockpit)
  Future<ApiResponse<DashboardModel>> getDashboard(DateTime data) async {
    try {
      final response = await _dio.get(
        '/consultas/dashboard',
        queryParameters: {'data': data.toIso8601String()},
      );

      return ApiResponse<DashboardModel>.fromJson(
        response.data,
        (json) => DashboardModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return _handleError<DashboardModel>(e);
    }
  }

  /// Atualiza o status da consulta via PATCH
  Future<ApiResponse<ConsultaModel>> atualizarStatus(int id, int novoStatus) async {
    try {
      final response = await _dio.patch(
        '/consultas/$id/status',
        data: {'novoStatus': novoStatus},
      );

      return ApiResponse<ConsultaModel>.fromJson(
        response.data,
        (json) => ConsultaModel.fromJson(json as Map<String, dynamic>),
      );
    } catch (e) {
      return _handleError<ConsultaModel>(e);
    }
  }

  /// Tratamento padronizado de erros do Dio para ApiResponse
  ApiResponse<T> _handleError<T>(dynamic error) {
    String mensagem = 'Erro inesperado da rede. Tente novamente.';
    
    if (error is DioException) {
      if (error.response?.data != null && error.response?.data is Map) {
        final erroApi = ApiResponse<T>.fromJson(error.response!.data, (json) => null as T);
        if (erroApi.mensagem?.isNotEmpty == true) {
          mensagem = erroApi.mensagem!;
        }
      } else {
        mensagem = error.message ?? mensagem;
      }
    }
    
    return ApiResponse<T>(
      sucesso: false,
      mensagem: mensagem,
    );
  }
}
