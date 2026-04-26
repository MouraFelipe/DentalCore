import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/paciente_provider.dart';
import '../models/paciente_model.dart';
import '../theme/app_theme.dart';

class PacientesPage extends StatefulWidget {
  const PacientesPage({super.key});

  @override
  State<PacientesPage> createState() => _PacientesPageState();
}

class _PacientesPageState extends State<PacientesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PacienteProvider>().fetchPacientes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PacienteProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pacientes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => provider.fetchPacientes(),
          )
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.pacientes.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.pacientes.length,
                  itemBuilder: (context, index) {
                    final paciente = provider.pacientes[index];
                    return _buildPacienteCard(paciente);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoNovoPaciente(context),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: AppTheme.secondaryGold.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text('Nenhum paciente cadastrado.', style: TextStyle(color: AppTheme.textLight, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildPacienteCard(PacienteModel paciente) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: AppTheme.primaryNavy.withOpacity(0.1),
          child: Text(paciente.nome[0].toUpperCase(), style: const TextStyle(color: AppTheme.primaryNavy, fontWeight: FontWeight.bold)),
        ),
        title: Text(paciente.nome, style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: AppTheme.textDark)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.badge_outlined, size: 14, color: AppTheme.textLight),
                const SizedBox(width: 4),
                Text(paciente.cpf, style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(Icons.phone_outlined, size: 14, color: AppTheme.textLight),
                const SizedBox(width: 4),
                Text(paciente.telefone, style: TextStyle(fontSize: 12, color: AppTheme.textLight)),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppTheme.backgroundBeige),
        onTap: () {
          // Detalhes do paciente
        },
      ),
    );
  }

  void _mostrarDialogoNovoPaciente(BuildContext context) {
    final nomeController = TextEditingController();
    final cpfController = TextEditingController();
    final telefoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Novo Paciente'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: 'Nome Completo', prefixIcon: Icon(Icons.person_outline)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: cpfController,
                decoration: const InputDecoration(labelText: 'CPF', prefixIcon: Icon(Icons.badge_outlined)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: telefoneController,
                decoration: const InputDecoration(labelText: 'Telefone', prefixIcon: Icon(Icons.phone_outlined)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24)),
            onPressed: () async {
              if (nomeController.text.isNotEmpty && cpfController.text.isNotEmpty) {
                final novo = PacienteModel(
                  id: 0,
                  nome: nomeController.text,
                  cpf: cpfController.text,
                  telefone: telefoneController.text,
                );
                final sucesso = await context.read<PacienteProvider>().adicionarPaciente(novo);
                if (sucesso && mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paciente cadastrado com sucesso!')));
                }
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
