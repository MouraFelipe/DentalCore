import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/pages/dashboard/widgets/bi_widgets.dart';
import 'package:app/providers/dashboard_provider.dart';
import 'package:provider/provider.dart';

class MockDashboardProvider extends ChangeNotifier implements DashboardProvider {
  @override
  List<FilaPaciente> get fila => [
    FilaPaciente(
      nome: 'Maximillian Alexander von Hohenzollern-Sigmaringen Terceiro da Silva Santos',
      procedimento: 'Avaliação Clínica Geral de Stress de Layout',
      status: FilaStatus.naCadeira,
      cor: 0xFFF59E0B, // Gold
      iniciais: 'MA',
    ),
  ];

  @override
  DashboardMetrics get metrics => DashboardMetrics(faltas: 0, realizadas: 0, proximos: 0, ultimoAtendimento: '09:00', ocupacao: 0);

  @override
  List<MetaMensal> get metas => [];

  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => null;

  @override
  DateTime get dataSelecionada => DateTime.now();

  @override
  Future<void> carregarMetricasDoDia(DateTime? data) async {}
}

void main() {
  testWidgets('FilaAtendimentoCard handles extremely long names without overflow', (WidgetTester tester) async {
    final mockProvider = MockDashboardProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<DashboardProvider>.value(
        value: mockProvider,
        child: const MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              child: FilaAtendimentoCard(),
            ),
          ),
        ),
      ),
    );

    // Verifica se o texto está presente (mesmo que truncado visualmente)
    expect(find.textContaining('Maximillian'), findsOneWidget);
    
    // Verifica se não houve exceções de overflow
    expect(tester.takeException(), isNull);
  });
}
