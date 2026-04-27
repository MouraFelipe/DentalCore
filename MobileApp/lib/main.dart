import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'services/api_service.dart';
import 'theme/app_theme.dart';

import 'providers/paciente_provider.dart';
import 'providers/consulta_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/login_provider.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/agenda_page.dart';
import 'pages/pacientes_page.dart';
import 'pages/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(const DentalCoreApp());
}

class DentalCoreApp extends StatelessWidget {
  const DentalCoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    
    return MultiProvider(
      providers: [
        Provider<ApiService>.value(value: apiService),
        ChangeNotifierProvider(create: (_) => LoginProvider(apiService)),
        ChangeNotifierProxyProvider<LoginProvider, PacienteProvider>(
          create: (_) => PacienteProvider(apiService),
          update: (_, login, prev) => prev ?? PacienteProvider(apiService),
        ),
        ChangeNotifierProxyProvider<LoginProvider, ConsultaProvider>(
          create: (_) => ConsultaProvider(apiService),
          update: (_, login, prev) => prev ?? ConsultaProvider(apiService),
        ),
        ChangeNotifierProxyProvider<LoginProvider, DashboardProvider>(
          create: (_) => DashboardProvider(apiService),
          update: (_, login, prev) => prev ?? DashboardProvider(apiService),
        ),
      ],
      child: MaterialApp(
        title: 'DentalCore',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light, // Corrigido para .light
        locale: const Locale('pt', 'BR'),
        home: Consumer<LoginProvider>(
          builder: (context, login, _) {
            // Se logado, vai para o Dashboard que agora tem sua própria navegação via Sidebar
            return login.isAuthenticated ? const DashboardPage() : const LoginPage();
          },
        ),
      ),
    );
  }
}

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const AgendaPage(),
    const DashboardPage(),
    const PacientesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Agenda'),
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Cockpit'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Pacientes'),
        ],
      ),
    );
  }
}
