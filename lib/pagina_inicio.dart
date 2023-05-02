import 'package:flutter/material.dart';
import 'package:flutter_wordle/ranking.dart';
import 'package:flutter_wordle/pagina_juego.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';


class PaginaIncio extends StatefulWidget {

  const PaginaIncio({Key? key}) : super(key: key);

  @override
  State<PaginaIncio> createState() => _PaginaIncio();
}

class _PaginaIncio extends State<PaginaIncio>{

  String _idiomaSeleccionado = 'espana'; // Inicialmente se muestra el idioma Español
  int numeroCaracteres=0;
  int numeroIntentos=0;
  double va=0;
  int length=0;
  int texto=0;
  List<String> texto1=["NUMERO DE CARACTERES","NOMBRE DE CARACTÈRES","NUMERO DI CARATTERI"];
  List<String> texto2=["NUMERO DE INTENTOS","NOMBRE DE TENTATIVES","NUMERO DI TENTATIVI"];
  List<String> texto3=["EMPEZAR","COMMENCER","INIZIO"];

  Future<void> escribirConfig(String linea) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/config.txt');
    await file.writeAsString(linea);
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
            if (i == 0) {
              _idiomaSeleccionado = opciones[i];
              switch(_idiomaSeleccionado){
                case "espana":
                  texto=0;
                  break;
                case "italia":
                  texto=2;
                  break;
                case "francia":
                  texto=1;
                  break;
              }
            }
            if (i == 1) {
              if (opciones[i] == "4") {
                numeroCaracteres = 4;
              } else {
                if (opciones[i] == "5") {
                  numeroCaracteres = 5;
                } else {
                  numeroCaracteres = 6;
                }
              }
            }
            if (i == 2) {
              if (opciones[i] == "4") {
                numeroIntentos = 4;
              } else {
                if (opciones[i] == "5") {
                  numeroIntentos = 5;
                } else {
                  if (opciones[i] == "6") {
                    numeroIntentos = 6;
                  } else {
                    if (opciones[i] == "7") {
                      numeroIntentos = 7;
                    } else {
                      numeroIntentos = 8;
                    }
                  }
                }
              }
            }
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ()async {
      await copyConfigFile();
      await leerConfig();
    }();
  }




  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: Scaffold(
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
            child: PopupMenuButton<String>(
              onSelected: (value) {
                setState(() {
                  _idiomaSeleccionado = value;
                  switch(_idiomaSeleccionado){
                    case "espana":
                      texto=0;
                      break;
                    case "italia":
                      texto=2;
                      break;
                    case "francia":
                      texto=1;
                      break;
                  }
                });
              },
              itemBuilder: (BuildContext context) {
                double iconSize = MediaQuery.of(context).size.width * 0.13;
                List<PopupMenuItem<String>> _idiomas = [
                  PopupMenuItem(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                      children: [
                        Image.asset('assets/iconos/espana.png', width: iconSize),
                      ],
                    ),
                    value: 'espana',
                  ),
                  PopupMenuItem(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                      children: [
                        Image.asset('assets/iconos/italia.png', width: iconSize),
                      ],
                    ),
                    value: 'italia',
                  ),
                  PopupMenuItem(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                      children: [
                        Image.asset('assets/iconos/francia.png', width: iconSize),
                      ],
                    ),
                    value: 'francia',
                  ),
                ];
                return _idiomas.toList();
              },
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double iconSize = MediaQuery.of(context).size.width * 0.13;
                  String iconoIdioma='assets/iconos/espana.png';
                  if(_idiomaSeleccionado == 'italia'){
                    iconoIdioma = 'assets/iconos/italia.png';
                  }
                  else if(_idiomaSeleccionado == 'francia'){
                    iconoIdioma = 'assets/iconos/francia.png';
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        iconoIdioma,
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
                      texto1[texto],
                      style:
                      TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.07, // Tamaño de fuente
                        fontWeight: FontWeight.bold, // Grosor de fuente
                        fontStyle: FontStyle.italic, // Estilo de fuente
                        color: Colors.yellowAccent, // Color del texto
                        letterSpacing: 2.0, // Espaciado entre letras
                        wordSpacing: 4.0, // Espaciado entre palabras
                        shadows: [ // Sombra del texto
                          Shadow(
                            color: Colors.grey,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                          ),
                        ],
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
                            // Acción al presionar el botón 3
                            setState(() {
                              numeroCaracteres=4;
                            });
                          },
                          child: Text(
                              '4',
                              style:
                              TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.1, // Tamaño de fuente
                                fontWeight: FontWeight.bold, // Grosor de fuente
                                fontStyle: FontStyle.italic, // Estilo de fuente
                                color: Colors.yellowAccent, // Color del texto
                                letterSpacing: 2.0, // Espaciado entre letras
                                wordSpacing: 4.0, // Espaciado entre palabras
                                shadows: [ // Sombra del texto
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                  ),
                                ],
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
                            // Acción al presionar el botón 3
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
                                color: Colors.yellowAccent, // Color del texto
                                letterSpacing: 2.0, // Espaciado entre letras
                                wordSpacing: 4.0, // Espaciado entre palabras
                                shadows: [ // Sombra del texto
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                  ),
                                ],
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
                                color: Colors.yellowAccent, // Color del texto
                                letterSpacing: 2.0, // Espaciado entre letras
                                wordSpacing: 4.0, // Espaciado entre palabras
                                shadows: [ // Sombra del texto
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                  ),
                                ],
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
                      texto2[texto],
                      style:
                      TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.07, // Tamaño de fuente
                        fontWeight: FontWeight.bold, // Grosor de fuente
                        fontStyle: FontStyle.italic, // Estilo de fuente
                        color: Colors.yellowAccent, // Color del texto
                        letterSpacing: 2.0, // Espaciado entre letras
                        wordSpacing: 4.0, // Espaciado entre palabras
                        shadows: [ // Sombra del texto
                          Shadow(
                            color: Colors.grey,
                            offset: Offset(2.0, 2.0),
                            blurRadius: 3.0,
                          ),
                        ],
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
                                color: Colors.yellowAccent, // Color del texto
                                letterSpacing: 2.0, // Espaciado entre letras
                                wordSpacing: 4.0, // Espaciado entre palabras
                                shadows: [ // Sombra del texto
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                  ),
                                ],
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
                                color: Colors.yellowAccent, // Color del texto
                                letterSpacing: 2.0, // Espaciado entre letras
                                wordSpacing: 4.0, // Espaciado entre palabras
                                shadows: [ // Sombra del texto
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                  ),
                                ],
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
                                color: Colors.yellowAccent, // Color del texto
                                letterSpacing: 2.0, // Espaciado entre letras
                                wordSpacing: 4.0, // Espaciado entre palabras
                                shadows: [ // Sombra del texto
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                  ),
                                ],
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
                                color: Colors.yellowAccent, // Color del texto
                                letterSpacing: 2.0, // Espaciado entre letras
                                wordSpacing: 4.0, // Espaciado entre palabras
                                shadows: [ // Sombra del texto
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                  ),
                                ],
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
                                color: Colors.yellowAccent, // Color del texto
                                letterSpacing: 2.0, // Espaciado entre letras
                                wordSpacing: 4.0, // Espaciado entre palabras
                                shadows: [ // Sombra del texto
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                  ),
                                ],
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

                            String linea='${_idiomaSeleccionado};${numeroCaracteres};${numeroIntentos};';
                            escribirConfig(linea);

                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PaginaJuego())
                            );

                          },
                          child: Text(
                              texto3[texto],
                              style:TextStyle(
                                fontSize: MediaQuery.of(context).size.width * 0.0615, // Tamaño de fuente
                                fontWeight: FontWeight.bold, // Grosor de fuente
                                fontStyle: FontStyle.italic, // Estilo de fuente
                                color: Colors.white70, // Color del texto
                                letterSpacing: 2.0, // Espaciado entre letras
                                wordSpacing: 4.0, // Espaciado entre palabras
                                shadows: [ // Sombra del texto
                                  Shadow(
                                    color: Colors.grey,
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                  ),
                                ],
                              )),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.purple; // Color cuando está presionado
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
      ),
    );
  }
}