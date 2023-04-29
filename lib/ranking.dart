import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';


class Ranking extends StatelessWidget {
  const Ranking({Key? key}) : super(key: key);

  Future<void> copyRankingFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final configFile = File('${directory.path}/ranking.txt');

    if (!await configFile.exists()) {
      await configFile.writeAsString('');
    }
  }

  Future<List<String>> leerRanking() async {
    final ruta = await getApplicationDocumentsDirectory();
    File file = File('${ruta.path}/ranking.txt');
    List<String> usuarios = [];

    if (await file.exists()) {
      String contenido = await file.readAsString();
      usuarios = contenido.split('');
    }
    return usuarios;
  }
  List<String> listaUsuarios;

  void obtenerRanking() async {
    List<String> listaUsuarios = await leerRanking();
  }

  @override
  Widget build(BuildContext context) {
    obtenerRanking();
    return MaterialApp(
      home: Scaffold(
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

                    for(int i=0;i<lista)
                  )
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
      ),
    );
  }



}