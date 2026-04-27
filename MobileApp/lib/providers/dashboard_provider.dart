import 'package:flutter/material.dart';
import '../services/api_service.dart';

// ─────────────────────────────────────────────────────────────
// MODELOS DE DOMÍNIO (Integrados com a UI Premium)
// ─────────────────────────────────────────────────────────────

enum FilaStatus { naCadeira, aguardando, finalizado }

class DashboardMetrics {
  final int faltas;
  final int realizadas;
  final int proximos;
  final String ultimoAtendimento; 
  final double ocupacao;          

  const DashboardMetrics({
    required this.faltas,
    required this.realizadas,
    required this.proximos,
    required this.ultimoAtendimento,
    required this.ocupacao,
  });

  factory DashboardMetrics.empty() => const DashboardMetrics(
    faltas: 0, realizadas: 0, proximos: 0,
    ultimoAtendimento: '--:--', ocupacao: 0,
  );
}

class FilaPaciente {
  final String    iniciais;
  final int       cor;       
  final String    nome;
  final String    procedimento;
  final FilaStatus status;

  const FilaPaciente({
    required this.iniciais,
    required this.cor,
    required this.nome,
    required this.procedimento,
    required this.status,
  });
}

class MetaMensal {
  final String label;
  final double valor;   
  final int    cor;     

  const MetaMensal({
    required this.label,
    required this.valor,
    required this.cor,
  });
}

// ─────────────────────────────────────────────────────────────
// PROVIDER
// ─────────────────────────────────────────────────────────────

class DashboardProvider extends ChangeNotifier {
  final ApiService _apiService;

  bool             _isLoading = false;
  String?          _errorMessage;
  DashboardMetrics _metrics    = DashboardMetrics.empty();
  List<FilaPaciente> _fila     = [];
  List<MetaMensal>   _metas    = [];
  DateTime         _dataSelecionada = DateTime.now();

  DashboardProvider(this._apiService) {
    carregarMetricasDoDia(DateTime.now());
  }

  // Getters
  bool               get isLoading       => _isLoading;
  String?            get errorMessage    => _errorMessage;
  DashboardMetrics   get metrics          => _metrics;
  List<FilaPaciente> get fila             => List.unmodifiable(_fila);
  List<MetaMensal>   get metas            => List.unmodifiable(_metas);
  DateTime           get dataSelecionada  => _dataSelecionada;

  Future<void> carregarMetricasDoDia(DateTime? data) async {
    _isLoading = true;
    _errorMessage = null;
    _dataSelecionada = data ?? DateTime.now();
    notifyListeners();

    try {
      // 1. Buscar métricas REAIS do backend
      final response = await _apiService.getDashboard(_dataSelecionada);
      
      if (response.sucesso && response.dados != null) {
        final d = response.dados!;
        _metrics = DashboardMetrics(
          faltas: d.faltas,
          realizadas: d.realizadas,
          proximos: d.agendadas, // Mapeado de agendadas
          ultimoAtendimento: 'até 19:30', // Mock por enquanto
          ocupacao: d.taxaRealizacao,     // Usando taxaRealizacao do backend
        );
      } else {
        _errorMessage = response.mensagem;
      }

      // 2. Mock dos dados de BI (Fila e Metas) que ainda não existem no backend
      _carregarDadosBIMock();

    } catch (e) {
      _errorMessage = 'Erro ao conectar com o cockpit.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _carregarDadosBIMock() {
    _fila = const [
      FilaPaciente(
        iniciais: 'MA', cor: 0xFF5C6BC0,
        nome: 'Marcos Andrade', procedimento: 'Limpeza Profilática',
        status: FilaStatus.naCadeira,
      ),
      FilaPaciente(
        iniciais: 'JL', cor: 0xFF8E24AA,
        nome: 'Julia Lemos', procedimento: 'Avaliação Ortodôntica',
        status: FilaStatus.aguardando,
      ),
      FilaPaciente(
        iniciais: 'RS', cor: 0xFF00897B,
        nome: 'Ricardo Silva', procedimento: 'Extração Siso',
        status: FilaStatus.finalizado,
      ),
    ];

    _metas = const [
      MetaMensal(label: 'Faturamento Projetado', valor: 0.82, cor: 0xFF1565C0),
      MetaMensal(label: 'Retenção de Pacientes',  valor: 0.60, cor: 0xFF1B8A4E),
      MetaMensal(label: 'Satisfação (NPS)',        valor: 0.94, cor: 0xFFE8A020),
    ];
  }
}
