import 'package:flutter/material.dart';
import 'package:flutter_application_1/agenda.controller/agenda.controller.dart';

class CadastroView extends StatefulWidget {
  final AgendaController controller;
  const CadastroView({super.key, required this.controller});

  @override
  State<CadastroView> createState() => _CadastroViewState();
}

class _CadastroViewState extends State<CadastroView> {
  bool _isLoadingLocal = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4), 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        elevation: 0, 
        iconTheme: const IconThemeData(color: Colors.brown)
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Column(
            children: [
              const Text('🌻', style: TextStyle(fontSize: 70)),
              const Text(
                'Criar Nova Conta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
              ),
              const SizedBox(height: 25),
              
              _buildField(widget.controller.nomeCtrl, 'Nome Completo', Icons.person_outline),
              const SizedBox(height: 12),
              _buildField(widget.controller.emailCtrl, 'E-mail', Icons.email_outlined),
              const SizedBox(height: 12),
              _buildField(widget.controller.telefoneCtrl, 'Telefone', Icons.phone_android_outlined),
              const SizedBox(height: 12),
              _buildField(widget.controller.senhaCadastroCtrl, 'Senha', Icons.lock_outline, obscure: true),
              const SizedBox(height: 12),
              _buildField(widget.controller.confirmarSenhaCtrl, 'Confirmar Senha', Icons.lock_reset_outlined, obscure: true),
              
              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: () async {
                  setState(() => _isLoadingLocal = true);
                  bool sucesso = await widget.controller.realizarCadastro();
                  
                  if (!mounted) return;
                  setState(() => _isLoadingLocal = false);

                  if (sucesso) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Conta criada!')));
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); 
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senhas não conferem!')));
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.black, 
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoadingLocal 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('REGISTRAR'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, IconData icon, {bool obscure = false}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.amber[900]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}