import 'package:flutter/material.dart';
import 'package:flutter_wordle/ranking.dart';
import 'package:flutter_wordle/pagina_juego.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';

enum TipoIdioma {
  espanol("espanol", "assets/diccionarios/espanol.json", "assets/iconos/espana.png", "", "assets/idiomas/espanol.txt", null),
  aleman("aleman", "assets/diccionarios/aleman.txt", "assets/iconos/alemania.png", ";", "assets/idiomas/aleman.txt", "assets/excepciones/aleman.txt"),
  italiano("italiano", "assets/diccionarios/italiano.txt", "assets/iconos/italia.png", ";", "assets/idiomas/italiano.txt", null);

  final String idioma;
  final String rutaIdioma;
  final String rutaBandera;
  final String split;
  final String texto;
  final String? excepciones;

  const TipoIdioma(this.idioma, this.rutaIdioma, this.rutaBandera, this.split, this.texto, this.excepciones);

  static TipoIdioma buscarIdioma(String Myidioma) {
    List<TipoIdioma> miLista = TipoIdioma.values;
    TipoIdioma idioma=TipoIdioma.espanol;
    for(int i = 0; i < miLista.length; i++) {
      if(miLista[i].idioma == Myidioma)
        idioma=miLista[i];
    }
    return idioma;
  }
}

class PaginaIncio extends StatefulWidget {

  const PaginaIncio({Key? key}) : super(key: key);

  @override
  State<PaginaIncio> createState() => _PaginaIncio();
}

class _PaginaIncio extends State<PaginaIncio>{

  TipoIdioma tipoIdioma = TipoIdioma.espanol;
  int numeroCaracteres=0;
  int numeroIntentos=0;
  double va=0;
  int length=0;
  List<String> textosIdioma=[];
  bool cargandoConfiguracion = true;


  Future<void> escribirConfig(String linea) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/config.txt');
    await file.writeAsString(linea);
  }

  Future<void> copyRankingFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final configFile = File('${directory.path}/Ranking.txt');

    if (!await configFile.exists()) {
      await configFile.writeAsString('');
    }
  }

  Future<void> copyConfigFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final configFile = File('${directory.path}/config.txt');

    if (!await configFile.exists()) {
      await configFile.writeAsString('');
    }
  }

  Future<void> leerConfig() async {
    final ruta = await getApplicationDocumentsDirectory();
    File file = File('${ruta.path}/config.txt');

    if (await file.exists()) {
      String contenido = await file.readAsString();
      List<String> opciones = contenido.split(';');

      setState(() {
        for (int i = 0; i < 3; i++) {
          if (opciones[i].trim().isNotEmpty) {
            if(i == 0) tipoIdioma = TipoIdioma.buscarIdioma(opciones[i]);

            if(i == 1) numeroCaracteres = int.parse(opciones[i]);

            if(i == 2) numeroIntentos = int.parse(opciones[i]);
          }
        }
      });
    }
  }

  Future<void> leerIdioma() async {
    String data = await rootBundle.loadString(tipoIdioma.texto);
    textosIdioma = data.split(",");
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await copyRankingFile();
      await copyConfigFile();
      await leerConfig();
      await leerIdioma();

      leerIdioma().whenComplete(() {
        setState(() {
          cargandoConfiguracion = false;
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     home: Container(
      color: Color.fromRGBO(30, 30, 30, 1),
      child: cargandoConfiguracion ? Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ) :Scaffold(
        resizeToAvoidBottomInset: false,
          appBar: AppBar(
            toolbarHeight: MediaQuery.of(context).size.width * 0.1,
            backgroundColor: Color.fromRGBO(30, 30, 30, 1),
            leading: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                double iconSize = MediaQuery.of(context).size.width * 0.1;
                double paddingValue = 99;
                return Container(
                  child: GestureDetector(
                    onTap: () {

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Ranking(textosIdioma:textosIdioma)),
                      );

                    },
                    behavior: HitTestBehavior.translucent,
                    child: Icon(
                      Icons.emoji_events,
                      size: iconSize,
                    ),
                  ),
                );
              },
            ),

            actions: [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: PopupMenuButton<TipoIdioma>(
                  onSelected: (value) {
                    setState(() {
                      tipoIdioma = value;
                      ()async {
                        await leerIdioma();
                      }();
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    double iconSize = MediaQuery.of(context).size.width * 0.13;
                    List<PopupMenuItem<TipoIdioma>> _idiomas = [
                      PopupMenuItem(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(TipoIdioma.espanol.rutaBandera, width: iconSize),
                          ],
                        ),
                        value: TipoIdioma.espanol,
                      ),
                      PopupMenuItem(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(TipoIdioma.aleman.rutaBandera, width: iconSize),
                          ],
                        ),
                        value: TipoIdioma.aleman,
                      ),
                      PopupMenuItem(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(TipoIdioma.italiano.rutaBandera, width: iconSize),
                          ],
                        ),
                        value: TipoIdioma.italiano,
                      ),
                    ];
                    return _idiomas.toList();
                  },
                  child: LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      double iconSize = MediaQuery.of(context).size.width * 0.13;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            tipoIdioma.rutaBandera,
                            height: iconSize ,
                            width: iconSize ,
                          ),
                          Icon(Icons.arrow_drop_down, color: Colors.white, size: iconSize),
                        ],
                      );
                    },
                  ),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

              ),
            ],
          ),

          body: SafeArea(
              child: Container(
                  color: Color.fromRGBO(30, 30, 30,1),
                  child: Material(
                    type: MaterialType.transparency,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/iconos/logo.png',
                          scale:MediaQuery.of(context).size.width * 0.0001,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.001),
                        Text(
                            textosIdioma[0],
                            style:
                            TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.yellowAccent,
                              letterSpacing: 2.0,
                              wordSpacing: 4.0,
                            )
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.03),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.28,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: ElevatedButton(

                                onPressed: () {
                                  setState(() {
                                    numeroCaracteres=4;
                                  });
                                },
                                child: Text(
                                    '4',
                                    style:
                                    TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      wordSpacing: 4.0,
                                    )
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (numeroCaracteres==4)
                                          return Colors.green;
                                        return Colors.white;
                                      },
                                    )
                                ),
                              ),

                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.28,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    numeroCaracteres=5;
                                  });
                                },
                                child: Text(
                                    '5',
                                    style:
                                    TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      wordSpacing: 4.0,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (numeroCaracteres==5)
                                          return Colors.green;
                                        return Colors.white;
                                      },
                                    )
                                ),
                              ),

                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.28,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: ElevatedButton(
                                onPressed: () {

                                  setState(() {
                                    numeroCaracteres=6;
                                  });
                                },
                                child: Text(
                                    '6',
                                    style:
                                    TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      wordSpacing: 4.0,
                                    )
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (numeroCaracteres==6)
                                          return Colors.green;
                                        return Colors.white;
                                      },
                                    )
                                ),
                              ),

                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.02),
                        Text(
                            textosIdioma[1],
                            style:
                            TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.07,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.yellowAccent,
                              letterSpacing: 2.0,
                              wordSpacing: 4.0,
                            )
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.03),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: ElevatedButton(
                                onPressed: () {

                                  setState(() {
                                    numeroIntentos=4;
                                  });
                                },
                                child: Text(
                                    '4',
                                    style:
                                    TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      wordSpacing: 4.0,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (numeroIntentos==4)
                                          return Colors.green;
                                        return Colors.white;
                                      },
                                    )
                                ),
                              ),

                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    numeroIntentos=5;
                                  });
                                },
                                child: Text(
                                    '5',
                                    style:
                                    TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      wordSpacing: 4.0,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (numeroIntentos==5)
                                          return Colors.green;
                                        return Colors.white;
                                      },
                                    )
                                ),
                              ),

                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height:MediaQuery.of(context).size.width * 0.15,
                              child: ElevatedButton(
                                onPressed: () {

                                  setState(() {
                                    numeroIntentos=6;
                                  });
                                },
                                child: Text(
                                    '6',
                                    style:
                                    TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      wordSpacing: 4.0,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (numeroIntentos==6)
                                          return Colors.green;
                                        return Colors.white;
                                      },
                                    )
                                ),
                              ),

                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Acción al presionar el botón 3
                                  setState(() {
                                    numeroIntentos=7;
                                  });
                                },
                                child: Text(
                                    '7',
                                    style:
                                    TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      wordSpacing: 4.0,
                                    )),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (numeroIntentos==7)
                                          return Colors.green;
                                        return Colors.white;
                                      },
                                    )
                                ),
                              ),

                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              height: MediaQuery.of(context).size.width * 0.15,
                              child: ElevatedButton(
                                onPressed: () {

                                  setState(() {
                                    numeroIntentos=8;
                                  });
                                },
                                child: Text(
                                    '8',
                                    style:
                                    TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.1,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.black,
                                      letterSpacing: 2.0,
                                      wordSpacing: 4.0,
                                    )

                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                        if (numeroIntentos==8)
                                          return Colors.green;
                                        return Colors.white;
                                      },
                                    )
                                ),
                              ),

                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.width * 0.075),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: MediaQuery.of(context).size.width * 0.15,
                            child: Material(
                              type: MaterialType.transparency,
                              child: ElevatedButton(
                                onPressed: () {


                                  String linea='${tipoIdioma.idioma};${numeroCaracteres};${numeroIntentos};';
                                  escribirConfig(linea);

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => PaginaJuego(textosIdioma:textosIdioma))
                                  );
                                },
                                child: Text(
                                    textosIdioma[2],
                                    style:TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.061,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      letterSpacing: 2.0,
                                      wordSpacing: 4.0,
                                    )),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      return Colors.green;
                                    },
                                  ),
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ),
        ),
      //),
    );
  }
}