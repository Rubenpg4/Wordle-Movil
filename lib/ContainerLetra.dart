import 'package:flutter/material.dart';

enum TipoCampoLetra {
  Defecto(Colors.white, Colors.black),
  Acertado(Colors.green, Colors.black),
  Fallado(Colors.black, Colors.white),
  Desubicado(Colors.yellow, Colors.black);

  final Color colorFondo;
  final Color colorLetra;

  const TipoCampoLetra(this.colorFondo, this.colorLetra);
}

class ContainerLetra extends StatelessWidget {
  TipoCampoLetra tipo;
  String letra;

  ContainerLetra({Key? key, this.tipo = TipoCampoLetra.Defecto, this.letra = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: tipo.colorFondo,
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: tipo.colorLetra,
          ),
        ),
      ),
    );
  }
}