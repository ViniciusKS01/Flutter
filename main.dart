import 'package:flutter/material.dart';

void main() {
  runApp(MeuApp());
}

class Filme {
  String nome;
  int nota;

  Filme({this.nome = "", this.nota = 0});
}

List<Filme> filmes = [
  new Filme(nome: "Império do Sol"),
  new Filme(nome: "Xuxa"),
  new Filme(nome: "Rocky III")
];

class MeuApp extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => ListViewFilmes(),
          '/novo-filme': (context) => FormNovoFilme()
        });
  }
}

class ListViewFilmes extends StatefulWidget {
  State<StatefulWidget> createState() {
    return new _ListViewFilmesState();
  }
}

class _ListViewFilmesState extends State<ListViewFilmes> {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus Filmes")),
      body: _buildListView(),
      floatingActionButton: _buildBotaoAdd(),
    );
  }

  Widget _buildBotaoAdd() {
    return FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(this.context, '/novo-filme');
          setState(() {});
        });
  }

  Widget _buildListView() {
    return ListView.separated(
      itemCount: filmes.length,
      separatorBuilder: _separatorBuilder,
      itemBuilder: _itemBuilder,
    );
  }

  Widget _separatorBuilder(context, index) {
    return Divider();
  }

  Widget _itemBuilder(context, index) {
    Filme filme = filmes[index];
    return ListTile(title: Text(filme.nome), trailing: _buildStars(filme));
  }

  Widget _buildStars(filme) {
    List<Widget> stars = [];

    for (int i = 1; i <= 3; i++) {
      stars.add(_buildStar(filme, i));
    }

    return Row(children: stars, mainAxisSize: MainAxisSize.min);
  }

  Widget _buildStar(filme, index) {
    return IconButton(
        icon: filme.nota >= index ? Icon(Icons.star) : Icon(Icons.star_border),
        color: filme.nota >= index ? Colors.yellow : Colors.grey,
        onPressed: () {
          setState(() {
            if (filme.nota == index) {
              filme.nota = index - 1;
            } else {
              filme.nota = index;
            }
          });
        });
  }
}

class FormNovoFilme extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _FormNovoFilmeState();
  }
}

class _FormNovoFilmeState extends State<FormNovoFilme> {
  TextEditingController nomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Widget build(context) {
    return Scaffold(
        appBar: AppBar(title: Text("Novo Filme")),
        body: Padding(padding: EdgeInsets.all(10.0), child: _buildForm()),
        floatingActionButton: _buildBotaoSalvar());
  }

  Widget _buildBotaoSalvar() {
    return FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            var filme = Filme(nome: nomeController.text.toString());
            filmes.add(filme);
            _mostrarSnackBar();
            Navigator.pop(this.context);
          }
        });
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(children: [
          TextFormField(
              controller: nomeController,
              decoration: InputDecoration(labelText: "Nome do Filme"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Digite o nome do Filme";
                }
                return null;
              })
        ]));
  }

  void _mostrarSnackBar() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Filme adicionado")));
  }
}
