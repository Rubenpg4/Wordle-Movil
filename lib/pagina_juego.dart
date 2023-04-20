import 'package:flutter/material.dart';

enum tipoPista {
  bomba(),
  lupa();


}

class PaginaJuego extends StatefulWidget {
  const PaginaJuego({Key? key}) : super(key: key);

  @override
  State<PaginaJuego> createState() => _PaginaJuego();
}

class _PaginaJuego extends State<PaginaJuego> with SingleTickerProviderStateMixin {
  double altoPantalla = 0.0;
  double altoTerrenoJuego = 0.0;

  late int nIntentos;
  late int nLetras;

  late List<List<String>> tablero;

  int letraActual = 0;
  int intentoActual = 0;

  @override
  void initState() {
    nIntentos = 4;
    nLetras = 7;

    for (int i = 0; i < nIntentos; i++) {
      for (int j = 0; j < nLetras; j++) {
        tablero[i][j] = '';
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(30, 30, 30, 1),
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            altoPantalla = constraints.maxHeight;
            altoTerrenoJuego = altoPantalla * 0.57;

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
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: altoTerrenoJuego,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < this.nIntentos; i++) ...[
              Container(
                child: Row(
                  children: [
                    for (int j = 0; j < this.nLetras; j++) ...[
                      _CasillaJuego(),
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

  Widget _CasillaJuego() {
    return Expanded(
      child: Container (
        height: altoTerrenoJuego/nIntentos,
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
      ),
    );
  }

  Widget _Teclado() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 45,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 145),
              child: Row(
                children: [
                  _BotonPista(),
                  SizedBox(width: 10,),
                  _BotonPista(),
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
              padding: EdgeInsets.symmetric(horizontal: 8),
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
      ),
    );
  }

  Widget _ContainerLetra(String contenido) {
    return Expanded(
      child: InkWell(
        onTap: () {
          print("Tecla presionada: $contenido");
          //if (this.letraActual > this.nLetras)
        },
        child: Container(
          height: 50,
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
            child: Text(
              contenido,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ContainerBorrado(String contenido) {
    return Expanded(
      flex: 2,
      child: InkWell(
        onTap: () {
          // Implementa aquí la acción que debe realizar cada tecla al ser pulsada
          print("Tecla presionada: $contenido");
        },
        child: Container(
          height: 50,
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
            child: Text(
              contenido,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
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
          // Lógica al presionar el botón
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

  Widget _BotonPista() {
    return Expanded(
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
      ),
    );
  }
}