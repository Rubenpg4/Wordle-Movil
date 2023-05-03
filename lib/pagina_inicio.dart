import 'package:flutter/material.dart';
import 'package:flutter_wordle/ranking.dart';
import 'package:flutter_wordle/pagina_juego.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';

enum TipoIdioma {
  espanol("espanol", "assets/textos/espanol.json", "assets/iconos/espana.png", null,["NUMERO DE CARACTERES","NUMERO DE INTENTOS","EMPEZAR"]),
  frances("frances", "assets/textos/frances.txt", "assets/iconos/francia.png", ";",["NOMBRE DE CARACTÈRES","NOMBRE DE TENTATIVES","COMMENCER"]),
  italiano("italiano", "assets/textos/italiano.txt", "assets/iconos/italia.png", "\n",["NUMERO DI CARATTERI","NUMERO DI TENTATIVI","INIZIO"]);

  final String idioma;
  final String rutaIdioma;
  final String rutaBandera;
  final String? split;
  final List<String> texto;

  const TipoIdioma(this.idioma, this.rutaIdioma, this.rutaBandera, this.split,this.texto);

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

  @override
  void initState() {
    ()async {
      await copyRankingFile();
      await copyConfigFile();
      await leerConfig();
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        home: Scaffold(
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
                      // Acción del botón
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Ranking()),
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
                    });
                  },
                  itemBuilder: (BuildContext context) {
                    double iconSize = MediaQuery.of(context).size.width * 0.13;
                    List<PopupMenuItem<TipoIdioma>> _idiomas = [
                      PopupMenuItem(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                          children: [
                            Image.asset(TipoIdioma.espanol.rutaBandera, width: iconSize),
                          ],
                        ),
                        value: TipoIdioma.espanol,
                      ),
                      PopupMenuItem(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                          children: [
                            Image.asset(TipoIdioma.frances.rutaBandera, width: iconSize),
                          ],
                        ),
                        value: TipoIdioma.frances,
                      ),
                      PopupMenuItem(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
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
                  elevation: 10, // Establecer la elevación del menú desplegable
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Establecer la forma del menú desplegable
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
                      SizedBox(height: MediaQuery.of(context).size.width * 0.001), // Agrega espacio vertical,
                      Text(
                          tipoIdioma.texto[0],
                          style:
                          TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.07, // Tamaño de fuente
                            fontWeight: FontWeight.bold, // Grosor de fuente
                            fontStyle: FontStyle.italic, // Estilo de fuente
                            color: Colors.yellowAccent, // Color del texto
                            letterSpacing: 2.0, // Espaciado entre letras
                            wordSpacing: 4.0, // Espaciado entre palabras// Sombra del texto
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.03), // Agrega espacio vertical

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28, // Ancho del botón
                            height: MediaQuery.of(context).size.width * 0.15, // Alto del botón
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
                                        return Colors.green; // Color cuando está presionado
                                      return Colors.white; // Color de fondo por defecto
                                    },
                                  )
                              ),
                            ),

                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28, // Ancho del botón
                            height: MediaQuery.of(context).size.width * 0.15, // Alto del botón
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
                                    fontSize: MediaQuery.of(context).size.width * 0.1, // Tamaño de fuente
                                    fontWeight: FontWeight.bold, // Grosor de fuente
                                    fontStyle: FontStyle.italic, // Estilo de fuente
                                    color: Colors.black, // Color del texto
                                    letterSpacing: 2.0, // Espaciado entre letras
                                    wordSpacing: 4.0, // Espaciado entre palabras
                                  )),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (numeroCaracteres==5)
                                        return Colors.green; // Color cuando está presionado
                                      return Colors.white; // Color de fondo por defecto
                                    },
                                  )
                              ),
                            ),

                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.28, // Ancho del botón
                            height: MediaQuery.of(context).size.width * 0.15, // Alto del botón
                            child: ElevatedButton(
                              onPressed: () {
                                // Acción al presionar el botón 3
                                setState(() {
                                  numeroCaracteres=6;
                                });
                              },
                              child: Text(
                                  '6',
                                  style:
                                  TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.1, // Tamaño de fuente
                                    fontWeight: FontWeight.bold, // Grosor de fuente
                                    fontStyle: FontStyle.italic, // Estilo de fuente
                                    color: Colors.black, // Color del texto
                                    letterSpacing: 2.0, // Espaciado entre letras
                                    wordSpacing: 4.0, // Espaciado entre palabras
                                  )
                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (numeroCaracteres==6)
                                        return Colors.green; // Color cuando está presionado
                                      return Colors.white; // Color de fondo por defecto
                                    },
                                  )
                              ),
                            ),

                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.001), // Agrega espacio vertical
                      Text(
                          tipoIdioma.texto[1],
                          style:
                          TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.07, // Tamaño de fuente
                            fontWeight: FontWeight.bold, // Grosor de fuente
                            fontStyle: FontStyle.italic, // Estilo de fuente
                            color: Colors.yellowAccent, // Color del texto
                            letterSpacing: 2.0, // Espaciado entre letras
                            wordSpacing: 4.0, // Espaciado entre palabras
                          )
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.03), // Agrega espacio vertical
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15, // Ancho del botón
                            height: MediaQuery.of(context).size.width * 0.15, // Alto del botón
                            child: ElevatedButton(
                              onPressed: () {
                                // Acción al presionar el botón 3
                                setState(() {
                                  numeroIntentos=4;
                                });
                              },
                              child: Text(
                                  '4',
                                  style:
                                  TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.1, // Tamaño de fuente
                                    fontWeight: FontWeight.bold, // Grosor de fuente
                                    fontStyle: FontStyle.italic, // Estilo de fuente
                                    color: Colors.black, // Color del texto
                                    letterSpacing: 2.0, // Espaciado entre letras
                                    wordSpacing: 4.0, // Espaciado entre palabras
                                  )),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (numeroIntentos==4)
                                        return Colors.green; // Color cuando está presionado
                                      return Colors.white; // Color de fondo por defecto
                                    },
                                  )
                              ),
                            ),

                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15, // Ancho del botón
                            height: MediaQuery.of(context).size.width * 0.15, // Alto del botón
                            child: ElevatedButton(
                              onPressed: () {
                                // Acción al presionar el botón 3
                                setState(() {
                                  numeroIntentos=5;
                                });
                              },
                              child: Text(
                                  '5',
                                  style:
                                  TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.1, // Tamaño de fuente
                                    fontWeight: FontWeight.bold, // Grosor de fuente
                                    fontStyle: FontStyle.italic, // Estilo de fuente
                                    color: Colors.black, // Color del texto
                                    letterSpacing: 2.0, // Espaciado entre letras
                                    wordSpacing: 4.0, // Espaciado entre palabras
                                  )),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (numeroIntentos==5)
                                        return Colors.green; // Color cuando está presionado
                                      return Colors.white; // Color de fondo por defecto
                                    },
                                  )
                              ),
                            ),

                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15, // Ancho del botón
                            height:MediaQuery.of(context).size.width * 0.15, // Alto del botón
                            child: ElevatedButton(
                              onPressed: () {
                                // Acción al presionar el botón 3
                                setState(() {
                                  numeroIntentos=6;
                                });
                              },
                              child: Text(
                                  '6',
                                  style:
                                  TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.1, // Tamaño de fuente
                                    fontWeight: FontWeight.bold, // Grosor de fuente
                                    fontStyle: FontStyle.italic, // Estilo de fuente
                                    color: Colors.black, // Color del texto
                                    letterSpacing: 2.0, // Espaciado entre letras
                                    wordSpacing: 4.0, // Espaciado entre palabras
                                  )),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (numeroIntentos==6)
                                        return Colors.green; // Color cuando está presionado
                                      return Colors.white; // Color de fondo por defecto
                                    },
                                  )
                              ),
                            ),

                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15, // Ancho del botón
                            height: MediaQuery.of(context).size.width * 0.15, // Alto del botón
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
                                    fontSize: MediaQuery.of(context).size.width * 0.1, // Tamaño de fuente
                                    fontWeight: FontWeight.bold, // Grosor de fuente
                                    fontStyle: FontStyle.italic, // Estilo de fuente
                                    color: Colors.black, // Color del texto
                                    letterSpacing: 2.0, // Espaciado entre letras
                                    wordSpacing: 4.0, // Espaciado entre palabras
                                  )),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (numeroIntentos==7)
                                        return Colors.green; // Color cuando está presionado
                                      return Colors.white; // Color de fondo por defecto
                                    },
                                  )
                              ),
                            ),

                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15, // Ancho del botón
                            height: MediaQuery.of(context).size.width * 0.15, // Alto del botón
                            child: ElevatedButton(
                              onPressed: () {
                                // Acción al presionar el botón 3
                                setState(() {
                                  numeroIntentos=8;
                                });
                              },
                              child: Text(
                                  '8',
                                  style:
                                  TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.1, // Tamaño de fuente
                                    fontWeight: FontWeight.bold, // Grosor de fuente
                                    fontStyle: FontStyle.italic, // Estilo de fuente
                                    color: Colors.black, // Color del texto
                                    letterSpacing: 2.0, // Espaciado entre letras
                                    wordSpacing: 4.0, // Espaciado entre palabras
                                  )

                              ),
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                        (Set<MaterialState> states) {
                                      if (numeroIntentos==8)
                                        return Colors.green; // Color cuando está presionado
                                      return Colors.white; // Color de fondo por defecto
                                    },
                                  )
                              ),
                            ),

                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.width * 0.075), // Agrega espacio vertical
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5, // Ancho del botón
                          height: MediaQuery.of(context).size.width * 0.15, // Alto del botón
                          child: Material(
                            type: MaterialType.transparency,
                            child: ElevatedButton(
                              onPressed: () {
                                // Acción al presionar el botón

                                String linea='${tipoIdioma.idioma};${numeroCaracteres};${numeroIntentos};';
                                escribirConfig(linea);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PaginaJuego())
                                );
                              },
                              child: Text(
                                  tipoIdioma.texto[2],
                                  style:TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.061, // Tamaño de fuente
                                    fontWeight: FontWeight.bold, // Grosor de fuente
                                    fontStyle: FontStyle.italic, // Estilo de fuente
                                    color: Colors.black, // Color del texto
                                    letterSpacing: 2.0, // Espaciado entre letras
                                    wordSpacing: 4.0, // Espaciado entre palabras
                                  )),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    return Colors.deepOrange; // Color de fondo por defecto
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
    );
  }
}