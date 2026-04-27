import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/consulta_provider.dart';
import '../models/consulta_model.dart';
import '../theme/app_colors.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConsultaProvider>().carregarConsultas(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    final consultaProvider = context.watch<ConsultaProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Agenda Clínica",
          style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () => _selectDate(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => consultaProvider.carregarConsultas(_selectedDate),
          ),
        ],
      ),
      body: Column(
        children: [
          // Seletor de Data Rápido
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            color: AppColors.surface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatLongDate(_selectedDate),
                  style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                if (consultaProvider.isLoading)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy))
              ],
            ),
          ),
          
          Expanded(
            child: consultaProvider.isLoading && consultaProvider.consultas.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => consultaProvider.carregarConsultas(_selectedDate),
                    child: _buildConsultasList(consultaProvider),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultasList(ConsultaProvider provider) {
    if (provider.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: Colors.red),
            const SizedBox(height: 16),
            Text(provider.errorMessage!, textAlign: TextAlign.center),
            TextButton(
              onPressed: () => provider.carregarConsultas(_selectedDate),
              child: const Text("Tentar novamente"),
            ),
          ],
        ),
      );
    }

    if (provider.consultas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Nenhuma consulta para este dia",
              style: GoogleFonts.manrope(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.consultas.length,
      itemBuilder: (context, index) {
        final consulta = provider.consultas[index];
        return _ConsultaCard(consulta: consulta);
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
      if (mounted) {
        context.read<ConsultaProvider>().carregarConsultas(picked);
      }
    }
  }

  String _formatLongDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return "Hoje";
    }
    // Simplificado para pt_BR manual para evitar dep. intl se possível, 
    // mas já estamos usando intl no projeto.
    return "${date.day}/${date.month}/${date.year}"; 
  }
}

class _ConsultaCard extends StatelessWidget {
  final ConsultaModel consulta;

  const _ConsultaCard({required this.consulta});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getStatusColor(consulta.statusConsulta);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                // Hora
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.navy.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    consulta.horaFormatada,
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Paciente e Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        consulta.nomePaciente,
                        style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      _StatusBadge(label: consulta.statusConsultaLabel, color: statusColor),
                    ],
                  ),
                ),
              ],
            ),
            
            if (consulta.podeAtualizarStatus) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Botão Faltou
                  if (consulta.statusConsulta == 1) // Agendada
                    _ActionButton(
                      label: "Faltou",
                      color: Colors.red[800]!,
                      icon: Icons.close,
                      onPressed: () => _updateStatus(context, 3), // Faltou
                    ),
                  
                  const SizedBox(width: 8),

                  // Botão Realizou
                  if (consulta.statusConsulta == 1) // Agendada
                    _ActionButton(
                      label: "Realizou",
                      color: Colors.green[800]!,
                      icon: Icons.check,
                      onPressed: () => _updateStatus(context, 2), // Realizada
                    ),

                  // Botão Corrigir
                  if (consulta.statusConsulta == 3) // Faltou
                    _ActionButton(
                      label: "Corrigir",
                      color: Colors.orange[800]!,
                      icon: Icons.refresh,
                      onPressed: () => _updateStatus(context, 1), // Volta para Agendada
                    ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, int novoStatus) async {
    final success = await context.read<ConsultaProvider>().atualizarStatusConsulta(consulta.id, novoStatus);
    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Status atualizado com sucesso!"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      final msg = context.read<ConsultaProvider>().errorMessage ?? "Erro ao atualizar status.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: Colors.red),
      );
    }
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 1: return AppColors.info;    // Agendada
      case 2: return AppColors.success; // Realizada
      case 3: return AppColors.danger;  // Faltou
      case 4: return AppColors.textDisabled; // Cancelada
      default: return AppColors.textPrimary;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: GoogleFonts.manrope(color: color, fontWeight: FontWeight.bold),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
