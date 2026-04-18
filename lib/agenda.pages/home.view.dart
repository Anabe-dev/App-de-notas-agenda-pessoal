import 'package:flutter/material.dart';
import '../agenda.controller/agenda.controller.dart';

class HomeView extends StatefulWidget {
  final AgendaController controller;
  const HomeView({super.key, required this.controller});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void _abrirFormulario() {
    if (widget.controller.abaAtual == 0) {
      _modalNovoEvento();
    } else if (widget.controller.abaAtual == 1) {
      _modalNovaNota();
    }
  }

  void _modalNovoEvento() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20, right: 20, top: 20
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Adicionar Evento', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextField(controller: widget.controller.eventoNomeCtrl, decoration: const InputDecoration(labelText: '', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(controller: widget.controller.eventoHorarioCtrl, decoration: const InputDecoration(labelText: 'Horário (ex: 14:00)', prefixIcon: Icon(Icons.access_time))),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Colors.red, Colors.blue, Colors.green, Colors.amber, Colors.purple].map((cor) => GestureDetector(
                  onTap: () => setModalState(() => widget.controller.corSelecionada = cor),
                  child: Container(
                    margin: const EdgeInsets.all(5),
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: cor, 
                      shape: BoxShape.circle, 
                      border: widget.controller.corSelecionada == cor ? Border.all(width: 3, color: Colors.black) : null
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () { setState(() => widget.controller.salvarEvento()); Navigator.pop(context); },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800], minimumSize: const Size(double.infinity, 50)),
                child: const Text('SALVAR NA AGENDA', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _modalNovaNota() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20, right: 20, top: 20
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Nova Anotação 📓', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            TextField(controller: widget.controller.notaTituloCtrl, decoration: const InputDecoration(hintText: 'Título', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: widget.controller.notaConteudoCtrl, maxLines: 4, decoration: const InputDecoration(hintText: 'Conteúdo...', border: OutlineInputBorder())),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () { setState(() => widget.controller.salvarNota()); Navigator.pop(context); },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber[800], minimumSize: const Size(double.infinity, 50)),
              child: const Text('SALVAR NOTA', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> abas = [
      _buildCalendario(),
      _buildAnotacoes(),
      _buildPerfil(),
      _buildSobre(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9C4),
      appBar: AppBar(
        title: const Text('Sunflower Agenda', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.amber[800],
        automaticallyImplyLeading: false,
      ),
      body: abas[widget.controller.abaAtual],
      floatingActionButton: (widget.controller.abaAtual == 0 || widget.controller.abaAtual == 1) 
          ? FloatingActionButton(
              onPressed: _abrirFormulario, 
              backgroundColor: Colors.amber[800], 
              child: const Icon(Icons.add, color: Colors.white)
            ) 
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: widget.controller.abaAtual,
        onTap: (index) => setState(() => widget.controller.mudarAba(index)),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.amber[900],
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: 'Notas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Conta'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Sobre'),
        ],
      ),
    );
  }

  // ABA 1: CALENDÁRIO (AGENDA)
  Widget _buildCalendario() {
    final listaEventos = widget.controller.eventosDoDia(widget.controller.diaSelecionado);
    return Column(
      children: [
        CalendarDatePicker(
          initialDate: widget.controller.diaSelecionado,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          onDateChanged: (d) => setState(() => widget.controller.diaSelecionado = d),
        ),
        const Divider(color: Color.fromARGB(255, 70, 68, 64)),
        Expanded(
          child: listaEventos.isEmpty 
            ? const Center(child: Text('Nenhum evento agendado.'))
            : ListView.builder(
                itemCount: listaEventos.length,
                itemBuilder: (context, i) {
                  final item = listaEventos[i];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    color: (item['cor'] as Color),
                    child: ListTile(
                      leading: Icon(Icons.circle, color: item['cor']),
                      title: Text(item['nome'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(item['horario'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => widget.controller.excluirEvento(item)),
                      ),
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }

  // ABA 2: ANOTAÇÕES (GRID)
  Widget _buildAnotacoes() {
    final listaNotas = widget.controller.anotacoes;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: listaNotas.isEmpty
          ? const Center(child: Text('Crie sua primeira nota! 📓'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 10, 
                mainAxisSpacing: 10
              ),
              itemCount: listaNotas.length,
              itemBuilder: (context, index) {
                final nota = listaNotas[index];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text(nota['titulo'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            GestureDetector(
                              onTap: () => setState(() => widget.controller.excluirNota(index)),
                              child: const Icon(Icons.close, size: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Divider(),
                        Expanded(child: Text(nota['conteudo'], style: const TextStyle(fontSize: 13), maxLines: 4, overflow: TextOverflow.ellipsis)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // ABA 3: CONTA
  Widget _buildPerfil() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const CircleAvatar(radius: 80, backgroundColor: Color.fromARGB(255, 49, 49, 47), child: Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                ListTile(leading: const Icon(Icons.badge), title: const Text('Nome'), subtitle: Text(widget.controller.nomeCtrl.text.isEmpty ? 'Usuário' : widget.controller.nomeCtrl.text)),
                ListTile(leading: const Icon(Icons.email), title: const Text('E-mail'), subtitle: Text(widget.controller.usuarioCtrl.text)),
              ],
            ),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            label: const Text('CONFIGURAÇÕES'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[800], 
              foregroundColor: Colors.white, 
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => widget.controller.realizarLogoff(context),
            icon: const Icon(Icons.logout),
            label: const Text('SAIR DA CONTA'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black, 
              foregroundColor: Colors.white, 
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ABA 4: SOBRE
  Widget _buildSobre() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🌻', style: TextStyle(fontSize: 60)),
          Text('Sunflower Agenda v1.0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text('Organize os seus dias com a luz do sol.', style: TextStyle(color: Colors.brown)),
        ],
      ),
    );
  }
}