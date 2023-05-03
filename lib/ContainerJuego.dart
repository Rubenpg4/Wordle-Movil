import 'package:flutter/material.dart';



enum TipoBorde {
  Activo(Colors.black, 4.0),
  Inactivo(Colors.black, 1.0);

  final Color colorBorde;
  final double anchoBorde;

  const TipoBorde(this.colorBorde, this.anchoBorde);
}

enum TipoCampoJuego {
  Defecto(Colors.white, Colors.black),
  Acertado(Colors.green, Colors.black),
  Fallado(Colors.black, Colors.white),
  Desubicado(Colors.yellow, Colors.black);

  final Color colorFondo;
  final Color colorLetra;

  const TipoCampoJuego(this.colorFondo, this.colorLetra);
}
class ContainerJuego extends StatelessWidget {
  TipoBorde tipoBorde = TipoBorde.Inactivo;
  double _altoCasilla = 0.0;
  TipoCampoJuego tipo;
  String letra;

  ContainerJuego({Key? key, this.tipo = TipoCampoJuego.Defecto, this.letra = ''});

  set altoCasilla(double nuevoAltoCasilla) => _altoCasilla = nuevoAltoCasilla;

  @override
  Widget build(BuildContext context) {
      return Expanded(
        child: LayoutBuilder (
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              height: this._altoCasilla,
              decoration: BoxDecoration(
                border: Border.all(color: tipoBorde.colorBorde, width: tipoBorde.anchoBorde),
                color: this.tipo.colorFondo,
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
                  this.letra,
                  style: TextStyle(
                    fontSize: this._altoCasilla * 0.35,
                    fontWeight: FontWeight.bold,
                    color: this.tipo.colorLetra,
                  ),
                ),
              ),
            );
          },
        ),
      );
  }
}
