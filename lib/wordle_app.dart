import 'package:flutter/material.dart';
import 'package:flutter_wordle/pagina_inicio.dart';

class WordleApp extends StatelessWidget {
  const WordleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titulo = 'Wordle';

    return MaterialApp(
      title: titulo,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(titulo),
        ),
        body: const SafeArea(
          child: PaginaIncio(),
        ),
      ),
    );
  }
}