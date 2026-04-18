import 'package:flutter/material.dart';
import 'package:flutter_application_1/agenda.controller/agenda.controller.dart';
import 'package:flutter_application_1/agenda.pages/recuperacao.view.dart';
import 'cadastro_view.dart';
import 'home.view.dart'; 

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AgendaController _controller = AgendaController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Text('🌻', style: TextStyle(fontSize: 100)),
              const Text(
                'Sunflower Agenda',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold, 
                  color: Color(0xFF5D4037)
                )
              ),
              const SizedBox(height: 40),
              
              TextField(
                controller: _controller.usuarioCtrl,
                decoration: InputDecoration(
                  labelText: 'E-mail ou Número',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),
              
              TextField(
                controller: _controller.senhaCtrl,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              
              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: () async {
                  if (_controller.usuarioCtrl.text.isEmpty || _controller.senhaCtrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Preencha os campos para entrar!'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                    return;
                  }

                  setState(() => _controller.isLoading = true);
                  bool sucesso = await _controller.realizarLogin();
                  
                  if (!mounted) return;
                  setState(() => _controller.isLoading = false);

                  if (sucesso) {
                    // Navegação para Home View (Substituindo a tela de login)
                    Navigator.pushReplacement(
                      // ignore: use_build_context_synchronously
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeView(controller: _controller),
                      ),
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Dados incorretos!'),
                        backgroundColor: Colors.orange,
                      )
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.amber[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _controller.isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('ENTRAR'),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroView(controller: _controller)),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.black),
                child: const Text('CRIAR CONTA', style: TextStyle(fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 8),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RecuperacaoView(controller: _controller),
                    ),
                  );
                },
                child: const Text(
                  'Esqueci a senha',
                  style: TextStyle(color: Colors.black54, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}