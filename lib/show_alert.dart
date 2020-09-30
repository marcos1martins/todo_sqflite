import 'package:flutter/material.dart';

import 'todo_provider.dart';

Future<bool> showAlertDialog(
    BuildContext context, int id, TodoProvider provider) {
  Widget cancelButton = FlatButton(
    onPressed: () {
      Navigator.of(context).pop(false);
    },
    child: Text("Cancelar"),
  );
  Widget deleteButton = FlatButton(
    onPressed: () {
      provider.delete(id);
      Navigator.of(context).pop(true);
    },
    child: Text("Excluir"),
  );

  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Deseja excluir a tarefa?"),
          content: Text("A ação não poderá ser desfeita."),
          actions: [cancelButton, deleteButton],
        );
      });
}
