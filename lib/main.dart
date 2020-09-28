import 'package:flutter/material.dart';
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
  List<Todo> allTodo = [];

  @override
  void initState() {
    provider.getAll().then((value) => allTodo = value);
    super.initState();
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
        itemCount: allTodo.length ?? 0,
        itemBuilder: (context, index) {
          return CheckboxListTile(
            title: Text(allTodo[index].title),
            value: allTodo[index].done,
            onChanged: (done) {
              allTodo[index].done = done;
              setState(() {
                provider.update(allTodo[index]);
              });
            },
          );
        },
      ),
    );
  }
}
