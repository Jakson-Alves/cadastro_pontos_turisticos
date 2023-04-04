

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/tarefa.dart';
import 'conteudo_form_dialog.dart';
import 'filtro_page.dart';

class ListaTurismoPage extends StatefulWidget{

  @override
  _ListaTurismoPageState createState() => _ListaTurismoPageState();

}

class _ListaTurismoPageState extends State<ListaTurismoPage>{

  static const ACAO_VISUALIZAR = 'visualizar';
  static const ACAO_EDITAR = 'editar';
  static const ACAO_EXCLUIR = 'excluir';

  final tarefas = <Tarefa>
  [
    Tarefa(
      id: 1,
      descricao: 'Cataratas do Iguaçu - Foz, PR',
      diferencial: 'Uma das 7 maravilhas do mundo',
      dtAtual: DateTime.now(),
    )
  ];

  var _ultimoId = 1;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: _criarAppBar(),
      body: _criarBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirForm,
        tooltip: 'Nova tarefa',
        child: const Icon(Icons.add),
      ),
    );
  }

  //APP BAR
  AppBar _criarAppBar(){
    return AppBar(
      title: const Text('Gerenciador de Pontos Turísticos'),
      actions: [
        IconButton(
            onPressed: _abrirPaginaFiltro,
            icon: const Icon(Icons.filter_list)),
      ],
    );
  }

  // BODY
  Widget _criarBody(){
    if( tarefas.isEmpty){
      return const Center(
        child: Text('Nenhum ponto turístico cadastrado',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
    }
    return ListView.separated(
      itemCount: tarefas.length,
      itemBuilder: (BuildContext context, int index){
        final tarefa = tarefas[index];
        return PopupMenuButton<String>(
            child: ListTile(
              title: Text('${tarefa.id} - ${tarefa.descricao}'),
              subtitle: Text(tarefa.diferencial == null ? 'Ponto Turístico sem diferencial definido':'Diferencial'),
            ),
            itemBuilder: (BuildContext context) => _criarItensMenu(),
            onSelected: (String valorSelecinado){
              if(valorSelecinado == ACAO_EDITAR){
                _abrirForm(tarefaAtual: tarefa, index: index);
              } else if (valorSelecinado == ACAO_VISUALIZAR){
                _visualizarForm(tarefaAtual: tarefa, index: index);
              } else {
                _excluir(index);
              }
            }
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(),
    );
  }
  void _excluir(int indice){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning, color: Colors.red,),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('Atenção'),
                )
              ],
            ),
            content: Text('Esse registro será deletado permanentemente'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      tarefas.removeAt(indice);
                    });
                  },
                  child: Text('OK')
              )
            ],
          );
        }
    );
  }
  List<PopupMenuEntry<String>> _criarItensMenu(){
    return[
      PopupMenuItem(
        value: ACAO_VISUALIZAR,
        child: Row(
          children: [
            Icon(Icons.remove_red_eye, color: Colors.green),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Visualizar'),
            )
          ],
        ),
      ),
      PopupMenuItem(
        value: ACAO_EDITAR,
        child: Row(
          children: [
            Icon(Icons.edit, color: Colors.black),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Editar'),
            )
          ],
        ),
      ),
      PopupMenuItem(
        value: ACAO_EXCLUIR,
        child: Row(
          children: [
            Icon(Icons.delete, color: Colors.red),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text('Excluir'),
            )
          ],
        ),
      )
    ];
  }

  void _abrirForm({Tarefa? tarefaAtual, int? index}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(tarefaAtual == null ? 'Nova Tarefa' : 'Alterar a tarefa ${tarefaAtual.id}'),
            content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (key.currentState != null && key.currentState!.dadosValidados()){
                    setState(() {
                      final novaTarefa = key.currentState!.novaTarefa;
                      if(index == null){
                        novaTarefa.id = ++_ultimoId;
                      }else{
                        tarefas[index] = novaTarefa;
                      }
                      tarefas.add(novaTarefa);
                    });
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Salvar'),
              ),
            ],
          );
        }
    );
  }

  void _visualizarForm({Tarefa? tarefaAtual, int? index}){
    final key = GlobalKey<ConteudoFormDialogState>();
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(tarefaAtual == null ? 'Nova Tarefa' : 'Alterar a tarefa ${tarefaAtual.id}'),
            content: ConteudoFormDialog(key: key, tarefaAtual: tarefaAtual),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Fechar'),
              ),
              // TextButton(
              //   onPressed: () {
              //     if (key.currentState != null && key.currentState!.dadosValidados()){
              //       setState(() {
              //         final novaTarefa = key.currentState!.novaTarefa;
              //         if(index == null){
              //           novaTarefa.id = ++_ultimoId;
              //         }else{
              //           tarefas[index] = novaTarefa;
              //         }
              //         tarefas.add(novaTarefa);
              //       });
              //       Navigator.of(context).pop();
              //     }
              //   },
              // ),
            ],
          );
        }
    );
  }

  void _abrirPaginaFiltro(){
    final navigator = Navigator.of(context);
    navigator.pushNamed(FiltroPage.routeName).then((alterouValores){
      if ( alterouValores == true){
        //filtro
      }
    }
    );
  }
}