import 'package:anotacoes/helper/AnotacaoHelper.dart';
import 'package:anotacoes/model/Anotacao.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

  _exibirTelaCadastro(){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Adicionar anotação"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tituloController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Título",
                    hintText: "Digite o título..."
                  ),
                ),
                TextField(
                  controller: _descricaoController,
                  decoration: InputDecoration(
                      labelText: "Descrição",
                      hintText: "Digite a descrição..."
                  ),
                ),
              ],
            ),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar")
              ),
              FlatButton(
                  onPressed: () {
                    //Salvar
                    _salvarAnotacao();
                    Navigator.pop(context);
                  },
                  child: Text("Salvar")
              ),
            ],
          );
        }
    );
  }

  _recuperarAnotacoes() async{
  List anotacoesRecuperadas = await _db.recuperarAnotacoes();
  List<Anotacao> listaTemporaria = [];
  for(var item in anotacoesRecuperadas){
    Anotacao anotacao = Anotacao.fromMap(item);
    listaTemporaria.add(anotacao);
  }
  setState(() {
    _anotacoes = listaTemporaria;
  });
  listaTemporaria = null;
  //print("Lista anotações: "+anotacoesRecuperadas.toString());
  }

  _salvarAnotacao() async{
    String titulo = _tituloController.text;
    String descricao = _descricaoController.text;

    //print("Data atual: ${DateTime.now().toString()}");
    Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
    int resultado = await _db.salvarAnotacao(anotacao);
    print("Salvar anotação : ${resultado.toString()}");

    _tituloController.clear();
    _descricaoController.clear();
    _recuperarAnotacoes();
  }

  _formatarData(String data){
    initializeDateFormatting("pt_BR");
    //Year -> y month-> M Day ->d
    //Hour -> H minute -> m second -> s
     var formatador = DateFormat("dd/MM/y H:m:s");
    //var formatador = DateFormat.yMMMd("pt_BR");
    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = formatador.format(dataConvertida);
    return dataFormatada;
  }

  @override
  void initState() {
    super.initState();
    _recuperarAnotacoes();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Anotações"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: _anotacoes.length,
              itemBuilder: (context, index){
                  final anotacao = _anotacoes[index];
                  return Card(
                    child: ListTile(
                      title: Text(anotacao.titulo),
                      subtitle: Text("${_formatarData(anotacao.data)} - ${anotacao.descricao}"),
                    ),
                  );
              }
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
