import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/ContainerJuego.dart';
import 'package:flutter_wordle/ContainerLetra.dart';

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

  int letraActual = 0;
  int intentoActual = 0;

  late List<List<ContainerJuego>> tableroJuego = [];
  Map<String, ContainerLetra> mapaTeclado = {};

  late AnimationController controladorAnimacion;

  @override
  void initState() {
    nLetras = 5;
    nIntentos = 5;
    palabra = "AVION";

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(30, 30, 30, 1),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            altoPantalla = constraints.maxHeight;
            anchoPantalla = constraints.maxWidth;

            altoTerrenoJuego = altoPantalla * 0.55;
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

  Widget _TerrenoJuego() {
    EdgeInsetsGeometry? paddingContrainer;
    if (this.nIntentos >= this.nLetras) {
      paddingContrainer = EdgeInsets.symmetric(horizontal: 40.0 * this.proporcionIntentosLetras);
      altoCasilla = altoTerrenoJuego/nIntentos;
    }
    else if (this.nIntentos < this.nLetras) {
      paddingContrainer = EdgeInsets.only(bottom: 50.0 * this.proporcionIntentosLetras);
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
          if(this.intentoActual < this.nIntentos) {
            if (this.letraActual >= nLetras) {
              for (int i = 0; i < this.nLetras; i++) {
                setState(() {
                  if (tableroJuego[intentoActual][i].letra ==
                      palabra[i]) {
                    tableroJuego[intentoActual][i].tipo =
                        TipoCampoJuego.Acertado;
                    mapaTeclado[tableroJuego[intentoActual][i].letra]
                        ?.tipo = TipoCampoLetra.Acertado;
                  } else
                  if (palabra.contains(tableroJuego[intentoActual][i].letra)) {
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
                if (tableroJuego[intentoActual][i].letra != palabra[i])
                  gana = false;
              }

              if (gana) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Victoria'),
                      content: Text('¡Felicidades, has ganado!'),
                      actions: <Widget>[
                        TextButton(
                            child: Text('Cerrar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }
                        ),
                      ],
                    );
                  },
                );
              } else {
                setState(() {
                  intentoActual++;
                  letraActual = 0;
                });

                if (intentoActual >= nIntentos) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Derrota'),
                        content: Text('Losiento, has perdido'),
                        actions: <Widget>[
                          TextButton(
                              child: Text('Cerrar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }
                          ),
                        ],
                      );
                    },
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
            borderRadius: BorderRadius.circular(10), // Bordes redondeados del botón
          ),
        ),
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
            String clave1 = claves[indice1];

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
            String clave2 = claves[indice2];

            if(posible) {
              setState(() {
                mapaTeclado[claves[indice1]]?.tipo = TipoCampoLetra.Fallado;
                mapaTeclado[claves[indice2]]?.tipo = TipoCampoLetra.Fallado;
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