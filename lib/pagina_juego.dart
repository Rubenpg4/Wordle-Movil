import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/ContainerJuego.dart';
import 'package:flutter_wordle/ContainerLetra.dart';
import 'package:flutter_wordle/pagina_inicio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:flutter/services.dart';

enum tipoPista {
  bomba("assets/iconos/bomba.png"),
  lupa("assets/iconos/lupa.png");

  final rutaIcono;

  const tipoPista(this.rutaIcono);
}

class PaginaJuego extends StatefulWidget {
  const PaginaJuego({Key? key}) : super(key: key);




  @override
  State<PaginaJuego> createState() => _PaginaJuego();
}

class _PaginaJuego extends State<PaginaJuego> with SingleTickerProviderStateMixin {
  double altoPantalla = 0.0;
  double anchoPantalla = 0.0;

  double altoTerrenoJuego = 0.0;
  double altoTeclado = 0.0;

  double proporcionIntentosLetras = 0.0;
  double altoCasilla = 0.0;

  double paddingUltimaColumaTeclado = 0.0;
  double paddingBotonesPistas = 0.0;

  late int nIntentos;
  late int nLetras;
  late String palabra;
  late String idioma;

  final TextEditingController _textController = TextEditingController();

  int contarPalabras(List<String> lista,int longitud){
    int cont=0;
    for(int i=0;i<lista.length;i++){
      if(longitud==lista[i].length){
        cont++;
      }
    }
    return cont;
  }


  void seleccionarIdioma(){
    if (idioma == 'espana') {
      if (nLetras == 4) {
        busquedaAleatoria('espanol',4);
      } else {
        if (nLetras == 5) {
          busquedaAleatoria('espanol',5);
        } else { //6 letras
          busquedaAleatoria('espanol',6);
        }
      }
    } else {
      if (idioma == 'francia') {
        if (nLetras == 4) {
          busquedaAleatoria('francia',4);
        } else {
          if (nLetras == 5) {
            busquedaAleatoria('francia',5);
          } else { //6 letras
            busquedaAleatoria('francia',6);
          }
        }
      } else { //italia
        if (nLetras == 4) {
          busquedaAleatoria('italia',4);
        } else {
          if (nLetras == 5) {
            busquedaAleatoria('italia',5);
          } else { //6 letras
            busquedaAleatoria('italia',6);
          }
        }
      }
    }
  }

  void busquedaAleatoria(String nombre,int numLetras) async {
    String palabraJuego='';
    String data = await rootBundle.loadString('assets/textos/${nombre}.txt');
    List<String> palabras = data.split(';');
    int contador=contarPalabras(palabras,numLetras);
    int contadorAleatorio = Random().nextInt(contador);
    int cont=0;
    for(int i=0;i<palabras.length;i++){
      if(palabras[i].length==numLetras){
        cont++;
      }
      if(cont==contadorAleatorio){
        palabraJuego=palabras[i];
        break;
      }
    }
    palabra=palabraJuego;
  }


  Future<void> leerConfig() async {
    final ruta = await getApplicationDocumentsDirectory();
    final file = File('${ruta.path}/config.txt');
    if (file.existsSync()) {
      final contenido = await file.readAsString();
      final opciones = contenido.split(';');
      for (int i = 0; i < 3; i++) {
        if (i == 0) {
          idioma = opciones[i];
        }
        if (i == 1) {
          if (opciones[i] == "4") {
            nLetras = 4;
          } else if (opciones[i] == "5") {
            nLetras = 5;
          } else {
            nLetras = 6;
          }
        }
        if (i == 2) {
          if (opciones[i] == "4") {
            nIntentos = 4;
          } else if (opciones[i] == "5") {
            nIntentos = 5;
          } else if (opciones[i] == "6") {
            nIntentos = 6;
          } else if (opciones[i] == "7") {
            nIntentos = 7;
          } else {
            nIntentos = 8;
          }
        }
      }
      setState(() {});
    }
  }


  bool cargandoConfiguracion=true;
  int letraActual = 0;
  int intentoActual = 0;

  late List<List<ContainerJuego>> tableroJuego = [];
  Map<String, ContainerLetra> mapaTeclado = {};

  late AnimationController controladorAnimacion;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      await leerConfig();

      leerConfig().whenComplete(() {
        setState(() {
          cargandoConfiguracion = false;
        });
      });

      seleccionarIdioma();

      for (int i = 0; i < nIntentos; i++) {
        List<ContainerJuego> list = [];
        for (int j = 0; j < nLetras; j++) {
          ContainerJuego miContainer = ContainerJuego();
          list.add(miContainer);
        }
        tableroJuego.add(list);
      }

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
      setState(() {}); // Llama a setState() aquí para actualizar la pantalla después de que se hayan leído los datos.
    });
  }


    @override
    Widget build(BuildContext context) {

      if (cargandoConfiguracion) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Container(
            color: Color.fromRGBO(30, 30, 30, 1),
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  altoPantalla = constraints.maxHeight;
                  anchoPantalla = constraints.maxWidth;

                  altoTerrenoJuego = altoPantalla * 0.55;
                  altoTeclado = altoPantalla * 0.45;

                  if (nIntentos > nLetras)
                    proporcionIntentosLetras = nIntentos / nLetras;
                  else if (nIntentos < nLetras)
                    proporcionIntentosLetras = nLetras / nIntentos;

                  paddingUltimaColumaTeclado = anchoPantalla * 0.05;
                  paddingBotonesPistas = anchoPantalla * 0.375;

                  return Stack(
                    children: <Widget>[
                      Positioned(
                        top: 10,
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
        );
      }


    }

    Widget _TerrenoJuego() {
      EdgeInsetsGeometry? paddingContrainer;
      if (this.nIntentos >= this.nLetras) {
        paddingContrainer = EdgeInsets.symmetric(
            horizontal: 40.0 * this.proporcionIntentosLetras);
        altoCasilla = altoTerrenoJuego / nIntentos;
      }
      else if (this.nIntentos < this.nLetras) {
        paddingContrainer =
            EdgeInsets.only(bottom: 50.0 * this.proporcionIntentosLetras);
        altoCasilla = altoTerrenoJuego / nLetras;
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
        child: LayoutBuilder(
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
            if (this.intentoActual < this.nIntentos &&
                this.letraActual < this.nLetras) {
              setState(() {
                tableroJuego[intentoActual][letraActual++].letra = "$contenido";
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
            if (this.intentoActual < this.nIntentos &&
                this.letraActual <= this.nLetras && this.letraActual > 0) {
              setState(() {
                tableroJuego[intentoActual][--letraActual].letra = '';
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
        width: 150,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            if (this.intentoActual < this.nIntentos) {
              if (this.letraActual >= nLetras) {
                for (int i = 0; i < this.nLetras; i++) {
                  setState(() {
                    if (tableroJuego[intentoActual][i].letra ==
                        palabra.toString()[i]) {
                      tableroJuego[intentoActual][i].tipo =
                          TipoCampoJuego.Acertado;
                      mapaTeclado[tableroJuego[intentoActual][i].letra]
                          ?.tipo = TipoCampoLetra.Acertado;
                    } else if (palabra.toString().contains(
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

                bool gana = true;
                for (int i = 0; i < this.nLetras; i++) {
                  if (tableroJuego[intentoActual][i].letra !=
                      palabra.toString()[i])
                    gana = false;
                }

                if (gana) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: Text(
                        'VICTORIA',
                        style:TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.09,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          color: Colors.yellowAccent,
                          letterSpacing: 2.0,
                          wordSpacing: 4.0,
                          shadows: [
                            Shadow(
                              color: Colors.grey,
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                            ),
                          ],
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(vertical: 16.0),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                              padding: EdgeInsets.symmetric(horizontal:10),
                              child:Text("aosdifiadshviodnvo0iadhvihjaoviner9ivh9ewrihvo9adhiv9iewhrv9ewr9vihewr9vjier9vijhewr9vihewr9vhi")
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _textController,
                              decoration: InputDecoration(
                                labelText: 'Introduce tu nombre',
                              ),
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PaginaIncio())
                          ),
                          child: Text('Volver'),
                        )
                      ],
                      backgroundColor: Colors.green,
                    ),
                  );


                } else {
                  setState(() {
                    intentoActual++;
                    letraActual = 0;
                  });

                  if (intentoActual >= nIntentos) {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(
                            'DERROTA',
                            style:TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.09, // Tamaño de fuente
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
                        content: Text('TIEMPO, ACIERTOS..'),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => PaginaIncio())
                              ),
                              child: Text('Volver')

                          )
                        ],
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            }
          },
          child: Text("ENVIAR"),
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            onPrimary: Colors.white,
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  10), // Bordes redondeados del botón
            ),
          ),
        ),
      );
    }

    Widget _BotonPista(tipoPista tipo) {
      return Expanded(
        child: InkWell(
          onTap: () {
            if (tipo == tipoPista.bomba) {
              List<String> claves = this.mapaTeclado.keys.toList();
              List<String> clavesExcluidas = [];
              Random random = Random();

              for (int i = 0; i < claves.length; i++) {
                for (int j = 0; j < this.nLetras; j++) {
                  if (claves[i] == this.palabra.toString()[j] ||
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
                if (cont > maxIteraciones) {
                  posible = false;
                  break;
                }
                cont++;
              }
              String clave1 = claves[indice1];

              cont = 0;
              int indice2 = random.nextInt(claves.length);
              while (clavesExcluidas.contains(claves[indice2]) ||
                  indice2 == indice1) {
                indice2 = random.nextInt(claves.length);
                if (cont > maxIteraciones) {
                  posible = false;
                  break;
                }
                cont++;
              }
              String clave2 = claves[indice2];

              if (posible) {
                setState(() {
                  mapaTeclado[claves[indice1]]?.tipo = TipoCampoLetra.Fallado;
                  mapaTeclado[claves[indice2]]?.tipo = TipoCampoLetra.Fallado;
                });
              }
            } else if (tipo == tipoPista.lupa) {
              List<String> clavesExcluidas = [];
              Random random = Random();

              for (int i = 0; i < nLetras; i++) {
                if (mapaTeclado[palabra.toString()[i]]?.tipo ==
                    TipoCampoLetra.Acertado ||
                    mapaTeclado[palabra.toString()[i]]?.tipo ==
                        TipoCampoLetra.Desubicado) {
                  clavesExcluidas.add(palabra.toString()[i]);
                }
              }

              int maxIteraciones = this.nLetras;
              int cont = 0;
              bool posible = true;

              int indiceRandom = random.nextInt(palabra
                  .toString()
                  .length);
              while (clavesExcluidas.contains(
                  palabra.toString()[indiceRandom])) {
                indiceRandom = random.nextInt(palabra
                    .toString()
                    .length);
                if (cont > maxIteraciones) {
                  posible = false;
                  break;
                }
                cont++;
              }

              if (posible) {
                setState(() {
                  mapaTeclado[palabra.toString()[indiceRandom]]?.tipo =
                      TipoCampoLetra.Desubicado;
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