import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';

import 'package:flutter_wordle/pagina_inicio.dart';
import 'package:path_provider/path_provider.dart';


class Ranking extends StatefulWidget {
  final List<String> textosIdioma;
  const Ranking({Key? key, required this.textosIdioma}) : super(key: key);

  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  List<String> textosIdioma = [];
  List<String> jugadores = [];
  double altoPantalla = 0.0;
  double anchoPantalla = 0.0;
  bool cargandoConfiguracion = true;
  late TipoIdioma tipoIdioma;

  Future<void> leerRanking() async {
    final ruta = await getApplicationDocumentsDirectory();
    File file = File('${ruta.path}/Ranking.txt');

    if (await file.exists()) {
      String contenido = await file.readAsString();
      jugadores = contenido.split('\n');
    }

  }

  Future<void> leerIdioma() async {
    String data = await rootBundle.loadString(tipoIdioma.texto);
    textosIdioma = data.split(",");
  }

  Future<void> leerConfig() async {
    final ruta = await getApplicationDocumentsDirectory();
    File file = File('${ruta.path}/config.txt');

    if (await file.exists()) {
      String contenido = await file.readAsString();
      List<String> opciones = contenido.split(';');

      setState(() {
        for (int i = 0; i < 3; i++) {
          if (opciones[i].trim().isNotEmpty)
            if (i == 0) tipoIdioma = TipoIdioma.buscarIdioma(opciones[i]);
        }
      });
    }
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await leerRanking();

      leerRanking().whenComplete(() {
        setState(() {
          cargandoConfiguracion = false;
        });
      });

      textosIdioma = widget.textosIdioma;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
        color: Color.fromRGBO(30, 30, 30, 1),
          child: cargandoConfiguracion ? Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
        : Container(
          color: Color.fromRGBO(30, 30, 30, 1),
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                altoPantalla = constraints.maxHeight;
                anchoPantalla = constraints.maxWidth;
                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: 50,
                      left: 0,
                      right: 0,
                      child: Text(
                        'RANKING',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.125,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            wordSpacing: 4.0,
                            color: Colors.yellowAccent
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 35,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60.0),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaginaIncio()),
                            );
                          },
                          child: Text(
                            '${textosIdioma[8]}',
                            style: TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.075,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                wordSpacing: 4.0,
                                color: Colors.black
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 130,
                      left: 0,
                      right: 0,
                      child: Container(
                        child: _tabla(),
                      )
                    ),
                  ],
                );
              }
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabla() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: altoPantalla * 0.5,
        width: anchoPantalla * 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            for (int i = 0; i < this.jugadores.length; i++) ...[
              _usuario(i),
            ],
          ],
        ),
      ),
    );
  }

  Widget _usuario(int usu) {
    if(!jugadores[usu].isEmpty) {
      List<String> variablesUsu = jugadores[usu].split(';');
      return Align(
        alignment: Alignment.center,
        child: Container(
          child: Text(
            '${usu + 1}. ${variablesUsu[0]}: ${variablesUsu[1]}',
            style: TextStyle(
              fontSize: 22,
              color: Colors.white,
            ),
          ),
          padding: EdgeInsets.all(5),
        ),
      );
    } else
      return Container();
  }
}