import 'package:flutter/material.dart';

class AgendaController {
  //LOGIN
  final TextEditingController usuarioCtrl = TextEditingController();
  final TextEditingController senhaCtrl = TextEditingController();

  //CADASTRO
  final TextEditingController nomeCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController telefoneCtrl = TextEditingController();
  final TextEditingController senhaCadastroCtrl = TextEditingController();
  final TextEditingController confirmarSenhaCtrl = TextEditingController();

  //RECUPERAÇÃO
  final TextEditingController recuperacaoCtrl = TextEditingController();

  //AGENDA E NOTAS
  final TextEditingController eventoNomeCtrl = TextEditingController();
  final TextEditingController eventoHorarioCtrl = TextEditingController();
  final TextEditingController notaTituloCtrl = TextEditingController();
  final TextEditingController notaConteudoCtrl = TextEditingController();

  //ESTADOS DE INTERFACE
  bool isLoading = false;
  int abaAtual = 0;
  Color corSelecionada = Colors.amber; 
  DateTime diaSelecionado = DateTime.now();

  //ARMAZENAMENTO
  List<Map<String, dynamic>> eventos = [];
  List<Map<String, dynamic>> anotacoes = [];

  // ignore: strict_top_level_inference
  get notas => null;

  Future<bool> realizarLogin() async {
    await Future.delayed(const Duration(seconds: 2));
    if (usuarioCtrl.text == "admin@gmail.com" && senhaCtrl.text == "123") {
      return true;
    }
    return false;
  }

  Future<bool> realizarCadastro() async {
    if (nomeCtrl.text.isNotEmpty && senhaCadastroCtrl.text == confirmarSenhaCtrl.text) {
      await Future.delayed(const Duration(seconds: 2));
      return true;
    }
    return false;
  }

  Future<bool> enviarCodigoRecuperacao() async {
    await Future.delayed(const Duration(seconds: 1));
    return recuperacaoCtrl.text.isNotEmpty;
  }

  void realizarLogoff(BuildContext context) {
    usuarioCtrl.clear();
    senhaCtrl.clear();
    abaAtual = 0;
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }
  void mudarAba(int index) {
    abaAtual = index;
  }

  void salvarEvento() {
    if (eventoNomeCtrl.text.isNotEmpty) {
      eventos.add({
        'nome': eventoNomeCtrl.text,
        'horario': eventoHorarioCtrl.text,
        'cor': corSelecionada,
        'dia': diaSelecionado,
      });
      eventoNomeCtrl.clear();
      eventoHorarioCtrl.clear();
      corSelecionada = Colors.amber;
    }
  }

  void excluirEvento(Map<String, dynamic> evento) {
    eventos.remove(evento);
  }

  List<Map<String, dynamic>> eventosDoDia(DateTime dia) {
    return eventos.where((e) => 
      e['dia'].day == dia.day && 
      e['dia'].month == dia.month && 
      e['dia'].year == dia.year
    ).toList();
  }

  void salvarNota() {
    if (notaTituloCtrl.text.isNotEmpty || notaConteudoCtrl.text.isNotEmpty) {
      anotacoes.add({
        'titulo': notaTituloCtrl.text,
        'conteudo': notaConteudoCtrl.text,
      });
      notaTituloCtrl.clear();
      notaConteudoCtrl.clear();
    }
  }

  void excluirNota(int index) {
    anotacoes.removeAt(index);
  }

  void dispose() {
    usuarioCtrl.dispose();
    senhaCtrl.dispose();
    nomeCtrl.dispose();
  }
}
