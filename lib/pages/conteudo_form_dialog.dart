

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gerenciador_tarefas_md/model/tarefa.dart';
import 'package:intl/intl.dart';

class ConteudoFormDialog extends StatefulWidget{
  final Tarefa? tarefaAtual;

  ConteudoFormDialog({Key? key, this.tarefaAtual}) : super (key: key);

  @override
  ConteudoFormDialogState createState() => ConteudoFormDialogState();
}

class ConteudoFormDialogState extends State<ConteudoFormDialog> {

  final formKey = GlobalKey<FormState>();
  final descricaoController = TextEditingController();
  final diferencialController = TextEditingController();
  final dtAtualController = TextEditingController();
  final _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState(){
    super.initState();
    if (widget.tarefaAtual != null){
      descricaoController.text = widget.tarefaAtual!.descricao;
      diferencialController.text = widget.tarefaAtual!.diferencial;
      dtAtualController.text = widget.tarefaAtual!.dtAtualFormatado;
    } else {
      DateTime dtAtual = DateTime.now();
      dtAtualController.text = DateFormat('dd/MM/yyyy').format(dtAtual);
    }
  }

  Widget build(BuildContext context){
    return Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe a descrição';
                }
                return null;
              },
            ),
            TextFormField(
              controller: diferencialController,
              decoration: InputDecoration(labelText: 'Diferencial'),
              validator: (String? valor){
                if (valor == null || valor.isEmpty){
                  return 'Informe o Diferencial';
                }
                return null;
              },
            ),
            TextFormField(
              controller: dtAtualController,
              decoration: InputDecoration(labelText: 'Data de Inserção',
                prefixIcon: IconButton(
                  onPressed: _mostrarCalendario,
                  icon: Icon(Icons.calendar_today),
                ),
                suffixIcon: IconButton(
                  onPressed: () => dtAtualController.clear(),
                  icon: Icon(Icons.close),
                ),
              ),
              readOnly: true,
            ),
          ],
        )
    );
  }

  void _mostrarCalendario(){
    final dataFormatada = dtAtualController.text;
    var data = DateTime.now();
    if(dataFormatada.isNotEmpty){
      data = _dateFormat.parse(dataFormatada);
    }
    showDatePicker(
      context: context,
      initialDate: data,
      firstDate: data.subtract(Duration(days:365 * 5 )),
      lastDate: data.add(Duration(days:365 * 5 )),
    ).then((DateTime? dataSelecionada){
      if(dataSelecionada != null){
        setState(() {
          dtAtualController.text = _dateFormat.format(dataSelecionada);
        });
      }
    });
  }

  bool dadosValidados() => formKey.currentState?.validate() == true;

  Tarefa get novaTarefa => Tarefa(
    id: widget.tarefaAtual?.id ?? 0,
    descricao: descricaoController.text,
    diferencial: diferencialController.text,
    dtAtual: dtAtualController.text.isEmpty ? null : _dateFormat.parse(dtAtualController.text),
  );
}