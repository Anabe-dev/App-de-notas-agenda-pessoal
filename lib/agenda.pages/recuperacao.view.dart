import 'package:flutter/material.dart';
import 'package:flutter_application_1/agenda.controller/agenda.controller.dart';

class RecuperacaoView extends StatefulWidget {
  final AgendaController controller;
  const RecuperacaoView({super.key, required this.controller});

  @override
  State<RecuperacaoView> createState() => _RecuperacaoViewState();
}

class _RecuperacaoViewState extends State<RecuperacaoView> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.brown),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Text('🌻', style: TextStyle(fontSize: 80)),
              const Text(
                'Recuperar Senha',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5D4037)),
              ),
              const SizedBox(height: 20),
              const Text(
                'Insira seu e-mail ou telefone para receber o link para recuperar sua senha.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.brown),
              ),
              const SizedBox(height: 30),
              
              TextField(
                controller: widget.controller.recuperacaoCtrl,
                decoration: InputDecoration(
                  labelText: 'E-mail ou Número',
                  prefixIcon: const Icon(Icons.send_outlined, color: Colors.amber),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              
              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: () async {
                  if (widget.controller.recuperacaoCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha o campo!'), backgroundColor: Colors.red),
                    );
                    return;
                  }

                  setState(() => _isLoading = true);
                  bool sucesso = await widget.controller.enviarCodigoRecuperacao();
                  
                  if (!mounted) return;
                  setState(() => _isLoading = false);

                  if (sucesso) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Link de recuperação enviado com sucesso!')),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context); // Volta para o login
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.amber[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : const Text('ENVIAR CÓDIGO'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}