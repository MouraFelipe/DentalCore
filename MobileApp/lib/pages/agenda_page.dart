import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/consulta_provider.dart';
import '../models/consulta_model.dart';
import '../theme/app_theme.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConsultaProvider>().fetchConsultas(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConsultaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Agenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: provider.diaSelecionado,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (date != null) provider.fetchConsultas(date);
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildDateHeader(provider.diaSelecionado),
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.erro != null
                    ? _buildErrorState(provider.erro!)
                    : provider.consultas.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            itemCount: provider.consultas.length,
                            itemBuilder: (context, index) => _buildConsultaItem(provider.consultas[index]),
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final isToday = date.day == DateTime.now().day && date.month == DateTime.now().month;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: AppTheme.primaryNavy,
      child: Text(
        isToday ? 'Hoje, ${DateFormat("d 'de' MMMM", 'pt_BR').format(date)}' : DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(date),
        style: GoogleFonts.manrope(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildErrorState(String msg) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(msg, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.textDark)),
            TextButton(onPressed: () => context.read<ConsultaProvider>().fetchConsultas(DateTime.now()), child: const Text('Tentar Novamente')),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_available, size: 80, color: AppTheme.secondaryGold.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text('Nenhum atendimento para este dia.', style: TextStyle(color: AppTheme.textLight, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildConsultaItem(ConsultaModel consulta) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Column(
              children: [
                Text(consulta.horaFormatada, style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryNavy)),
                const SizedBox(height: 4),
                Container(
                  width: 3,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _getStatusColor(consulta.statusConsulta),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(consulta.nomePaciente, style: GoogleFonts.manrope(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildStatusBadge(consulta.statusConsultaLabel, _getStatusColor(consulta.statusConsulta)),
                      const SizedBox(width: 8),
                      if (consulta.observacao != null)
                        Expanded(
                          child: Text(
                            consulta.observacao!,
                            style: TextStyle(fontSize: 12, color: AppTheme.textLight),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (consulta.podeAtualizarStatus)
              PopupMenuButton<int>(
                icon: const Icon(Icons.more_horiz),
                onSelected: (status) => context.read<ConsultaProvider>().atualizarStatus(consulta.id, status),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 2, child: Text('Confirmar Presença')),
                  const PopupMenuItem(value: 3, child: Text('Marcar Falta')),
                  const PopupMenuItem(value: 4, child: Text('Cancelar Consulta')),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1: return AppTheme.primaryNavy; // Agendada
      case 2: return Colors.green;        // Realizada
      case 3: return Colors.orange;       // Faltou
      case 4: return Colors.red;          // Cancelada
      default: return Colors.grey;
    }
  }
}
