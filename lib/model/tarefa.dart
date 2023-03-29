import 'package:intl/intl.dart';

class Tarefa{
  static const CAMPO_ID = 'id';
  static const CAMPO_DESCRICAO = 'descricao';
  static const CAMPO_DIFERENCIAL = 'diferencial';
  static const CAMPO_DTATUAL = 'dtAtual';

  int id;
  String descricao;
  String diferencial;
  DateTime? dtAtual;

  Tarefa({required this.id, required this.descricao, required this.diferencial, this.dtAtual});

  String get dtAtualFormatado{
    if (dtAtual == null){
      return ' ';
    }
    return DateFormat('dd/MM/yyyy').format(dtAtual!);
  }
}