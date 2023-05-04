import 'dart:math';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/container_juego.dart';
import 'package:flutter_wordle/container_letra.dart';
import 'package:flutter_wordle/pagina_inicio.dart';
import 'package:confetti/confetti.dart';

enum tipoPista {
  bomba("assets/iconos/bomba.png"),
  lupa("assets/iconos/lupa.png");

  final rutaIcono;

  const tipoPista(this.rutaIcono);
}

class PaginaJuego extends StatefulWidget {
  final List<String> textosIdioma;
  const PaginaJuego({Key? key, required this.textosIdioma}) : super(key: key);

  @override
  State<PaginaJuego> createState() => _PaginaJuego();
}

class _PaginaJuego extends State<PaginaJuego> with SingleTickerProviderStateMixin {
  double altoPantalla = 0.0;
  double anchoPantalla = 0.0;

  double altoTerrenoJuego = 0.0;
  double altoTeclado = 0.0;
  double altoNatbar = 0.0;

  double proporcionIntentosLetras = 0.0;
  double altoCasilla = 0.0;

  double paddingUltimaColumaTeclado = 0.0;
  double paddingBotonesPistas = 0.0;

  late TipoIdioma tipoIdioma;
  late int nIntentos;
  late int nLetras;
  late String palabra;

  List<String> diccionario = [];
  List<String> textosIdioma = [];

  bool puedeEnviar = true;

  int letraActual = 0;
  int intentoActual = 0;

  late List<List<ContainerJuego>> tableroJuego = [];
  Map<String, ContainerLetra> mapaTeclado = {};

  double puntuacion = 1.0;
  late DateTime inicio, fin;
  late Duration duracion;
  int bombasUsadas = 0, lupasUsadas = 0;

  late AnimationController controladorAnimacion;
  late ConfettiController _confettiController;
  bool cargandoConfiguracion = true;

  Future<void> escribirRanking(String nombre) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/Ranking.txt');

    List<String> lineas = await file.readAsLines();

    double puntuacionMinima = (lineas.length >= 10) ? double.parse(lineas[9].split(';')[1]) : 0;

    if (lineas.length < 10 || puntuacion > puntuacionMinima) {
      lineas.add('$nombre;${double.parse(puntuacion.toStringAsFixed(2))}');

      lineas.sort((a, b) {
        double puntuacionA, puntuacionB;
        try {
          puntuacionA = double.parse(a.split(';')[1]);
        } catch (e) {
          puntuacionA = 0;
        }
        try {
          puntuacionB = double.parse(b.split(';')[1]);
        } catch (e) {
          puntuacionB = 0;
        }
        return puntuacionB.compareTo(puntuacionA);
      });

      if (lineas.length > 10) {
        lineas.removeLast();
      }
    }

    await file.writeAsString(lineas.join('\n'));
  }

  void busquedaAleatoria() async {
    String idioma = await rootBundle.loadString(tipoIdioma.rutaIdioma);
    bool hayExcepcion = false;
    String excepcion = "";
    if (tipoIdioma.excepciones != null){
      excepcion = await rootBundle.loadString(tipoIdioma.excepciones!);
      hayExcepcion = true;
    }

    if(tipoIdioma.split == ""){
      List<String> palabras = List<String>.from(json.decode(idioma));
      diccionario = palabras
          .where((palabra) => palabra.length == nLetras)
          .map((palabra) => palabra.toUpperCase())
          .toList();
    } else {
      if(hayExcepcion) {
        List<String> excepciones = excepcion.split(";");
        diccionario = idioma.split(tipoIdioma.split)
            .where((palabra) => palabra.length == nLetras)
            .map((palabra) => palabra.toUpperCase())
            .where((palabra) => !excepciones.any((caracter) => palabra.contains(caracter)))
            .toList();
      }
      else {
        diccionario = idioma.split(tipoIdioma.split)
            .where((palabra) => palabra.length == nLetras)
            .map((palabra) => palabra.toUpperCase())
            .toList();
      }
    }

    int numAleatorio = Random().nextInt(diccionario.length);
    palabra = diccionario[numAleatorio];
    print(palabra);
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
            if (i == 0) tipoIdioma = TipoIdioma.buscarIdioma(opciones[i]);

            if (i == 1) nLetras = int.parse(opciones[i]);

            if (i == 2) nIntentos = int.parse(opciones[i]);
          }
        }
      });
    }
  }

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await leerConfig();

      leerConfig().whenComplete(() {
        setState(() {
          cargandoConfiguracion = false;
        });
      });

      busquedaAleatoria();

      for (int i = 0; i < nIntentos; i++) {
        List<ContainerJuego> list = [];
        for (int j = 0; j < nLetras; j++) {
          ContainerJuego miContainer = ContainerJuego();
          list.add(miContainer);
        }
        tableroJuego.add(list);
      }
      tableroJuego[0][0].tipoBorde = TipoBorde.Activo;

      mapaTeclado = {
        'Q': ContainerLetra(letra: 'Q'),
        'W': ContainerLetra(letra: 'W'),
        'E': ContainerLetra(letra: 'E'),
        'R': ContainerLetra(letra: 'R'),
        'T': ContainerLetra(letra: 'T'),
        'Y': ContainerLetra(letra: 'Y'),
        'U': ContainerLetra(letra: 'U'),
        'I': ContainerLetra(letra: 'I'),
        'O': ContainerLetra(letra: 'O'),
        'P': ContainerLetra(letra: 'P'),
        'A': ContainerLetra(letra: 'A'),
        'S': ContainerLetra(letra: 'S'),
        'D': ContainerLetra(letra: 'D'),
        'F': ContainerLetra(letra: 'F'),
        'G': ContainerLetra(letra: 'G'),
        'H': ContainerLetra(letra: 'H'),
        'J': ContainerLetra(letra: 'J'),
        'K': ContainerLetra(letra: 'K'),
        'L': ContainerLetra(letra: 'L'),
        'Ñ': ContainerLetra(letra: 'Ñ'),
        'Z': ContainerLetra(letra: 'Z'),
        'X': ContainerLetra(letra: 'X'),
        'C': ContainerLetra(letra: 'C'),
        'V': ContainerLetra(letra: 'V'),
        'B': ContainerLetra(letra: 'B'),
        'N': ContainerLetra(letra: 'N'),
        'M': ContainerLetra(letra: 'M'),
      };

      inicio = DateTime.now();
      textosIdioma = widget.textosIdioma;
    });

    super.initState();
    _confettiController = ConfettiController(duration: Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Color.fromRGBO(30, 30, 30, 1),
          child: cargandoConfiguracion ? Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          )
              : Container (
          color: Color.fromRGBO(30, 30, 30, 1),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                altoPantalla = constraints.maxHeight;
                anchoPantalla = constraints.maxWidth;

                altoNatbar = altoPantalla * 0.075;
                altoTerrenoJuego = altoPantalla * 0.475;
                altoTeclado = altoPantalla * 0.45;

                if(nIntentos > nLetras)
                  proporcionIntentosLetras = nIntentos / nLetras;
                else if(nIntentos < nLetras)
                  proporcionIntentosLetras = nLetras / nIntentos;

                paddingUltimaColumaTeclado = anchoPantalla * 0.05;
                paddingBotonesPistas = anchoPantalla * 0.375;

                return Stack(
                  children: <Widget>[
                    Positioned(
                      top: 10,
                      left: 10,
                      child: _BotonAtras()
                    ),
                    Positioned(
                      top: 10,
                      left: anchoPantalla * 0.3,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Image.asset(
                            'assets/iconos/logo.png',
                            height: altoNatbar * 1.2,
                          ),
                        ),
                      )
                    ),
                    Positioned(
                      top: 15 + altoNatbar,
                      right: 10,
                      left: 10,
                      child: _TerrenoJuego(),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 5,
                      left: 5,
                      child: _Teclado(),
                    ),
                  ],
                );
              }
            )
          ),
        ),
      ),
    );
  }

  Widget _BotonAtras() {
    return Container(
      height: altoNatbar,
      width: altoNatbar,
      alignment: Alignment.center,
      child: ElevatedButton (
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaginaIncio()),
          );
        },
        child: Text("<"),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Colors.black,
          textStyle: TextStyle(
            fontSize: altoNatbar * 0.80,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );

  }

  Widget _TerrenoJuego() {
    EdgeInsetsGeometry? paddingContrainer;
    if (this.nIntentos >= this.nLetras) {
      paddingContrainer = EdgeInsets.symmetric(horizontal: 40.0 * this.proporcionIntentosLetras);
      altoCasilla = altoTerrenoJuego/nIntentos;
    }
    else if (this.nIntentos < this.nLetras) {
      paddingContrainer = EdgeInsets.only(bottom: 50.0 * this.proporcionIntentosLetras - 15);
      altoCasilla = altoTerrenoJuego/nLetras;
    }

    for (int i = 0; i < nIntentos; i++) {
      for (int j = 0; j < nLetras; j++) {
        tableroJuego[i][j].altoCasilla = this.altoCasilla;
      }
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: paddingContrainer,
        height: altoTerrenoJuego,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < this.nIntentos; i++) ...[
              Container(
                child: Row(
                  children: [
                    for (int j = 0; j < this.nLetras; j++) ...[
                      tableroJuego[i][j].build(context),
                    ],
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _Teclado() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: LayoutBuilder (
       builder: (BuildContext context, BoxConstraints constraints) {
         return Container(
           height: altoTeclado,
           child: Column(
             mainAxisSize: MainAxisSize.min,
             mainAxisAlignment: MainAxisAlignment.end,
             children: [
               Container(
                 padding: EdgeInsets.symmetric(
                     horizontal: paddingBotonesPistas),
                 child: Row(
                   children: [
                     _BotonPista(tipoPista.bomba),
                     SizedBox(width: 5,),
                     _BotonPista(tipoPista.lupa),
                   ],
                 ),
               ),
               SizedBox(height: 15,),
               _BotonEnviar(),
               SizedBox(height: 15,),
               Row(
                 children: [
                   _ContainerLetra("Q"),
                   _ContainerLetra("W"),
                   _ContainerLetra("E"),
                   _ContainerLetra("R"),
                   _ContainerLetra("T"),
                   _ContainerLetra("Y"),
                   _ContainerLetra("U"),
                   _ContainerLetra("I"),
                   _ContainerLetra("O"),
                   _ContainerLetra("P"),
                 ],
               ),
               Row(
                 children: [
                   _ContainerLetra("A"),
                   _ContainerLetra("S"),
                   _ContainerLetra("D"),
                   _ContainerLetra("F"),
                   _ContainerLetra("G"),
                   _ContainerLetra("H"),
                   _ContainerLetra("J"),
                   _ContainerLetra("K"),
                   _ContainerLetra("L"),
                   _ContainerLetra("Ñ"),
                 ],
               ),
               Container(
                 padding: EdgeInsets.symmetric(
                     horizontal: this.paddingUltimaColumaTeclado),
                 child: Row(
                   children: [
                     _ContainerLetra("Z"),
                     _ContainerLetra("X"),
                     _ContainerLetra("C"),
                     _ContainerLetra("V"),
                     _ContainerLetra("B"),
                     _ContainerLetra("N"),
                     _ContainerLetra("M"),
                     _ContainerBorrado("⌫"),
                   ],
                 ),
               ),
             ],
           ),
         );
       },
      ),
    );
  }

  Widget _ContainerLetra(String contenido) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if(this.intentoActual < this.nIntentos && this.letraActual < this.nLetras) {
            setState(() {
              tableroJuego[intentoActual][letraActual++].letra = "$contenido";
              if(letraActual < nLetras)
                tableroJuego[intentoActual][letraActual].tipoBorde = TipoBorde.Activo;

              tableroJuego[intentoActual][letraActual - 1].tipoBorde = TipoBorde.Inactivo;

            });
          }
        },
        child: this.mapaTeclado[contenido]?.build(context),
      ),
    );
  }

  Widget _ContainerBorrado(String contenido) {
    return Expanded(
      flex: 2,
      child: InkWell(
        onTap: () {
          if(this.intentoActual < this.nIntentos && this.letraActual <= this.nLetras && this.letraActual > 0) {
            setState(() {
              tableroJuego[intentoActual][--letraActual].letra = '';
              if(letraActual + 1 < nLetras)
                tableroJuego[intentoActual][letraActual + 1].tipoBorde = TipoBorde.Inactivo;
              tableroJuego[intentoActual][letraActual].tipoBorde = TipoBorde.Activo;
            });
          }
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(2, 5),
              ),
            ],
          ),
          child: Center(
            child: Text(
              contenido,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _BotonEnviar() {
    return Container(
      width: 200,
      height: 60,
      child: Stack(
       children: [
         Align(
           alignment: Alignment.center,
        child: SizedBox(
          width: 160,
          height: 60,
        child: ElevatedButton(
        onPressed: () async {
          if(this.intentoActual < this.nIntentos) {
            if (this.letraActual >= nLetras && puedeEnviar) {
              puedeEnviar = false;
              String palabraString = '';
              for (int i = 0; i < this.nLetras; i++)
                palabraString += tableroJuego[intentoActual][i].letra;
              if (diccionario.contains(palabraString)) {
                for (int i = 0; i < this.nLetras; i++) {
                  await Future.delayed(
                      const Duration(milliseconds: 250), () {});
                  setState(() {
                    if (tableroJuego[intentoActual][i].letra ==
                        palabra[i]) {
                      tableroJuego[intentoActual][i].tipo =
                          TipoCampoJuego.Acertado;
                      mapaTeclado[tableroJuego[intentoActual][i].letra]
                          ?.tipo = TipoCampoLetra.Acertado;
                    } else if (palabra.contains(
                        tableroJuego[intentoActual][i].letra)) {
                      tableroJuego[intentoActual][i].tipo =
                          TipoCampoJuego.Desubicado;
                      if (mapaTeclado[tableroJuego[intentoActual][i].letra]
                          ?.tipo != TipoCampoLetra.Acertado)
                        mapaTeclado[tableroJuego[intentoActual][i].letra]
                            ?.tipo = TipoCampoLetra.Desubicado;
                    } else {
                      tableroJuego[intentoActual][i].tipo =
                          TipoCampoJuego.Fallado;
                      if (mapaTeclado[tableroJuego[intentoActual][i].letra]
                          ?.tipo != TipoCampoLetra.Acertado &&
                          mapaTeclado[tableroJuego[intentoActual][i].letra]
                              ?.tipo != TipoCampoLetra.Desubicado)
                        mapaTeclado[tableroJuego[intentoActual][i].letra]
                            ?.tipo = TipoCampoLetra.Fallado;
                    }
                  });
                }
                puedeEnviar = true;

                bool gana = true;
                for (int i = 0; i < this.nLetras; i++) {
                  if (tableroJuego[intentoActual][i].letra != palabra[i])
                    gana = false;
                }

                if (gana) {
                  _confettiController.play();
                  fin = DateTime.now();
                  duracion = fin.difference(inicio);
                  if (bombasUsadas == 0 && lupasUsadas == 0) {
                    puntuacion =
                        (nLetras * 3) / (nIntentos * 2) * 1000 - duracion.inSeconds;
                  } else {
                    if (bombasUsadas == 0)
                      puntuacion = (nLetras * 3) / (nIntentos * 2) * 1000 -
                          (duracion.inSeconds * (lupasUsadas * 2.2));
                    else if (lupasUsadas == 0)
                      puntuacion = (nLetras * 3) / (nIntentos * 2) * 1000 -
                          (duracion.inSeconds * (bombasUsadas));
                  }
                  showDialog(
                    context: context,
                    builder: (_) =>
                        AlertDialog(
                          title: Text(
                            textAlign: TextAlign.center,
                            '${textosIdioma[3]}',
                            style: TextStyle(
                              fontSize: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.09,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.yellowAccent,
                              letterSpacing: 2.0,
                              wordSpacing: 4.0,
                            ),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                      '${textosIdioma[6]}: ${puntuacion}\n${textosIdioma[7]}: ${duracion}')
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                                child: TextField(
                                  controller: _textController,
                                  decoration: InputDecoration(
                                    labelText: '${textosIdioma[9]}',
                                    labelStyle: TextStyle(color: Colors.yellowAccent),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                escribirRanking(_textController.value.text).then((_) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PaginaIncio()),
                                  );
                                });
                              },
                              child: Text(
                                '${textosIdioma[8]}',
                                style: TextStyle(color: Colors.yellowAccent),
                              ),
                            ),
                          ],
                          backgroundColor: Colors.green,
                        ),
                  );
                } else {
                  fin = DateTime.now();
                  duracion = fin.difference(inicio);

                  if (bombasUsadas == 0 && lupasUsadas == 0) {
                    puntuacion =
                        nLetras / nIntentos * 1000 - duracion.inSeconds;
                  } else {
                    if (bombasUsadas == 0)
                      puntuacion = nLetras / nIntentos * 1000 -
                          (duracion.inSeconds * (lupasUsadas * 2.2));
                    else if (lupasUsadas == 0)
                      puntuacion = nLetras / nIntentos * 1000 -
                          (duracion.inSeconds * (bombasUsadas));
                  }

                  setState(() {
                    intentoActual++;
                    letraActual = 0;
                    if (intentoActual < nIntentos)
                      tableroJuego[intentoActual][0].tipoBorde =
                          TipoBorde.Activo;
                  });

                  if (intentoActual >= nIntentos) {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          AlertDialog(
                            title: Text(
                                '${textosIdioma[4]}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: MediaQuery
                                      .of(context)
                                      .size
                                      .width * 0.09,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.yellowAccent,
                                  letterSpacing: 2.0,
                                  wordSpacing: 4.0,
                                )
                            ),
                            content: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text('${textosIdioma[10]} ${palabra}'),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PaginaIncio()),
                                    );
                                  },
                                  child: Text(
                                      '${textosIdioma[8]}',
                                      style: TextStyle(
                                        color: Colors.yellowAccent
                                      ),
                                  )

                              )
                            ],
                            backgroundColor: Colors.red,
                          ),
                    );
                  }
                }
              }
            }
          }
        },
        child: Text("${textosIdioma[5]}"),
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          onPrimary: Colors.white,
          textStyle: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7.5), // Bordes redondeados del botón
          ),
        ),
        ),
        ),
      ),
       Align(
         alignment: Alignment.topCenter,
         child: ConfettiWidget(
           confettiController: _confettiController,
           blastDirectionality: BlastDirectionality.explosive,
           shouldLoop: false,
           emissionFrequency: 0.065,
           numberOfParticles: 40,
           maxBlastForce: 200,
           minBlastForce: 100,
           colors: [
             Colors.green,
             Colors.blue,
             Colors.pink,
             Colors.orange,
             Colors.purple
           ],
         ),
       ),
    ],
    ),
    );
  }

  Widget _BotonPista(tipoPista tipo) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if(tipo == tipoPista.bomba){
            List<String> claves = this.mapaTeclado.keys.toList();
            List<String> clavesExcluidas = [];
            Random random = Random();

            for(int i = 0; i < claves.length; i++){
                for (int j = 0; j < this.nLetras; j++) {
                  if (claves[i] == this.palabra[j] ||
                      mapaTeclado[claves[i]]?.tipo == TipoCampoLetra.Fallado) {
                    clavesExcluidas.add(claves[i]);
                  }
                }
            }

            const int maxIteraciones = 27;

            int cont = 0;
            bool posible = true;
            int indice1 = random.nextInt(claves.length);
            while (clavesExcluidas.contains(claves[indice1])) {
              indice1 = random.nextInt(claves.length);
              if(cont > maxIteraciones) {
                posible = false;
                break;
              }
              cont++;
            }

            cont = 0;
            int indice2 = random.nextInt(claves.length);
            while (clavesExcluidas.contains(claves[indice2]) || indice2 == indice1) {
              indice2 = random.nextInt(claves.length);
              if(cont > maxIteraciones) {
                posible = false;
                break;
              }
              cont++;
            }

            if(posible) {
              setState(() {
                mapaTeclado[claves[indice1]]?.tipo = TipoCampoLetra.Fallado;
                mapaTeclado[claves[indice2]]?.tipo = TipoCampoLetra.Fallado;
                bombasUsadas++;
              });
            }

          } else if(tipo == tipoPista.lupa) {
            List<String> clavesExcluidas = [];
            Random random = Random();

            for(int i = 0; i < nLetras; i++) {
              if (mapaTeclado[palabra[i]]?.tipo == TipoCampoLetra.Acertado ||
                  mapaTeclado[palabra[i]]?.tipo == TipoCampoLetra.Desubicado) {
                clavesExcluidas.add(palabra[i]);
              }
            }

            int maxIteraciones = this.nLetras;
            int cont = 0;
            bool posible = true;

            int indiceRandom = random.nextInt(palabra.length);
            while (clavesExcluidas.contains(palabra[indiceRandom])) {
              indiceRandom = random.nextInt(palabra.length);
              if(cont > maxIteraciones) {
                posible = false;
                break;
              }
              cont++;
            }

            if(posible) {
              setState(() {
                mapaTeclado[palabra[indiceRandom]]?.tipo = TipoCampoLetra.Desubicado;
                lupasUsadas++;
              });
            }
          }
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(2, 5),
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              tipo.rutaIcono,
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }



}