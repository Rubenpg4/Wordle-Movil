import 'package:flutter/material.dart';
import 'package:flutter_wordle/pagina_inicio.dart';
import 'package:flutter_wordle/pagina_juego.dart';

class WordleApp extends StatelessWidget {
  const WordleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: const SafeArea(
          child: PaginaJuego(),
        ),
      ),
    );
  }
}