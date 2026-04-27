import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/login_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final loginProvider = context.watch<LoginProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Row(
        children: [
          // Lado Esquerdo: Banner (Visível apenas em telas grandes)
          if (MediaQuery.of(context).size.width > 800)
            Expanded(
              flex: 1,
              child: Container(
                color: const Color(0xFF1A237E),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.health_and_safety_rounded, color: Color(0xFFD4AF37), size: 100),
                      const SizedBox(height: 24),
                      Text(
                        "DentalCore BI",
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Gestão inteligente para sua clínica",
                        style: GoogleFonts.manrope(color: Colors.white70, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Lado Direito: Formulário de Login
          Expanded(
            flex: 1,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text(
                      "Login",
                      style: GoogleFonts.manrope(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Bem-vindo de volta! Insira suas credenciais.",
                      style: GoogleFonts.manrope(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 48),
                    
                    // Email
                    Text("E-mail", style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "admin@dental.com",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Senha
                    Text("Senha", style: GoogleFonts.manrope(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: "••••••••",
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Esqueceu a senha?", style: TextStyle(color: Colors.grey[600])),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Botão Login
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: loginProvider.isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A237E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: loginProvider.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text("Entrar", style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, preencha todos os campos.")),
      );
      return;
    }

    final response = await context.read<LoginProvider>().login(email, password);

    if (mounted) {
      if (response.sucesso) {
        // O home do MaterialApp no main.dart já troca para MainWrapper
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.mensagem ?? "Erro ao realizar login.")),
        );
      }
    }
  }
}
