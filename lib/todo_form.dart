import 'package:flutter/material.dart';

import 'todo.dart';
import 'todo_provider.dart';

class TodoForm extends StatefulWidget {
  @override
  _TodoFormState createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final provider = TodoProvider();
  GlobalKey<FormState> _key = new GlobalKey();

  bool _validate = false;
  String title = "";

  String _validatorTitle(String text) {
    if (text.length == 0) {
      return "Informe o título";
    }
    if (text.length < 3) {
      return "titulo deve ter pelo menos 3 caracteres";
    }
    return null;
  }

  void _sendForm() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      provider.insert(Todo(title)).then(
            (value) => Navigator.pop(context, true),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova tarefa"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          autovalidate: _validate,
          child: Column(
            children: [
              TextFormField(
                maxLength: 30,
                validator: _validatorTitle,
                onSaved: (String text) {
                  title = text;
                },
              ),
              FlatButton(
                child: Text("Criar"),
                onPressed: () {
                  _sendForm();
                },
              ),
              FlatButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
