import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  late List<String> listaUsuarios;

  @override
  void initState() {
    super.initState();
    ()async {
      await copyRankingFile();
      await leerRanking();
    }();
  }

  Future<void> copyRankingFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final rankingFile = File('${directory.path}/ranking.txt');

    if (!await rankingFile.exists()) {
      await rankingFile.writeAsString('');
    }
  }

  Future<void> leerRanking() async {
    final ruta = await getApplicationDocumentsDirectory();
    File file = File('${ruta.path}/ranking.txt');

    if (await file.exists()) {
      String contenido = await file.readAsString();
      listaUsuarios = contenido.split('/');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'RANKING',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
              ),
              Expanded(
                child: Container(
                  height: 200, // Altura del contenedor
                  child: ListView.builder(
                    itemCount: listaUsuarios.length,
                    itemBuilder: (context, index) {
                      List<String> informacion =
                      listaUsuarios[index].split(';');
                      return Container(
                          child: Text(
                            'Nombre: ${informacion[0]}..................Puntuacion: ${informacion[1]}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 2.0,
                            ),
                          )); // Aquí se muestra cada elemento
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width * 0.1,
                  0,
                  MediaQuery.of(context).size.width * 0.1,
                  MediaQuery.of(context).size.height * 0.04,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Volver',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.02,
                    ),
                    textStyle: TextStyle(fontSize: 20),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.8,
                      MediaQuery.of(context).size.height * 0.08,
                    ),
                    backgroundColor: Colors.purple,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}