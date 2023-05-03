import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

import 'package:path_provider/path_provider.dart';


class Ranking extends StatefulWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}



class _RankingState extends State<Ranking> {
  List<String> jugadores = [];

  Future<void> leerRanking() async {
    final ruta = await getApplicationDocumentsDirectory();
    File file = File('${ruta.path}/Ranking.txt');

    if (await file.exists()) {
      print("jejej");
      String contenido = await file.readAsString();
      jugadores = contenido.split('\n');
      print(jugadores);
    }
  }

  @override
  void initState() {
    super.initState();
    leerRanking();
  }

  @override
  Widget build(BuildContext context) {
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
                        fontSize: MediaQuery
                            .of(context)
                            .size
                            .width * 0.1,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: jugadores.length,
                    itemBuilder: (context, index) {
                      return Text(jugadores[index]);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery
                        .of(context)
                        .size
                        .width * 0.1,
                    0,
                    MediaQuery
                        .of(context)
                        .size
                        .width * 0.1,
                    MediaQuery
                        .of(context)
                        .size
                        .height * 0.04,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Volver',
                      style: TextStyle(
                        fontSize: MediaQuery
                            .of(context)
                            .size
                            .width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery
                            .of(context)
                            .size
                            .height * 0.02,
                      ),
                      textStyle: TextStyle(fontSize: 20),
                      minimumSize: Size(
                        MediaQuery
                            .of(context)
                            .size
                            .width * 0.8,
                        MediaQuery
                            .of(context)
                            .size
                            .height * 0.08,
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