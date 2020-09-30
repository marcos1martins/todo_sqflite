import 'package:flutter/material.dart';
import 'package:sqflite_testes/show_alert.dart';
import 'package:sqflite_testes/todo_form.dart';
import 'package:sqflite_testes/todo_provider.dart';

import 'todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {'/form': (context) => TodoForm()},
      home: MyHomePage(title: 'TODO LIST'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final provider = TodoProvider();
  List<Todo> allTodo;

  @override
  void initState() {
    super.initState();
    getAllTodo();
  }

  void getAllTodo() async {
    allTodo = await provider.getAll();
    setState(() {});
  }

  @override
  void dispose() {
    provider.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: allTodo == null ? 0 : allTodo.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onLongPress: () {
              showAlertDialog(context, allTodo[index].id, provider)
                  .then((value) => value ? getAllTodo() : null);
            },
            child: CheckboxListTile(
              title: Text(allTodo[index].title),
              value: allTodo[index].done,
              onChanged: (done) {
                allTodo[index].done = done;
                provider.update(allTodo[index]);
                getAllTodo();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool recarregar = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoForm(),
            ),
          );
          if (recarregar) {
            getAllTodo();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
