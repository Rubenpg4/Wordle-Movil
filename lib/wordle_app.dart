import 'package:flutter/material.dart';
import 'package:flutter_wordle/pagina_inicio.dart';

class WordleApp extends StatelessWidget {
  const WordleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: PaginaIncio(),
      ),
    );
  }
}