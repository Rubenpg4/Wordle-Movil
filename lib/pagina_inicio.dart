import 'package:flutter/material.dart';
import 'package:flutter_wordle/ranking.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
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
                });
              },
              itemBuilder: (BuildContext context) {
                double iconSize = MediaQuery.of(context).size.width * 0.13;
                List<PopupMenuItem<String>> _idiomas = [
                  PopupMenuItem(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                      children: [
                        Image.asset('assets/espana.png', width: iconSize),
                      ],
                    ),
                    value: 'espana',
                  ),
                  PopupMenuItem(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                      children: [
                        Image.asset('assets/italia.png', width: iconSize),
                      ],
                    ),
                    value: 'italiano',
                  ),
                  PopupMenuItem(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                      children: [
                        Image.asset('assets/francia.png', width: iconSize),
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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/${_idiomaSeleccionado}.png',
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

      body: Container(
        color: Color.fromRGBO(30, 30, 30,1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo.png',
              scale:MediaQuery.of(context).size.width * 0.0001,
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.001), // Agrega espacio vertical,
            Text(
                'NUMERO DE CARACTERES',
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
                'NUMERO DE INTENTOS',
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
              child:ElevatedButton(
                onPressed: () {
                  // Acción al presionar el botón
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
                            onPressed: () => Navigator.pop(context),
                            child: Text('Volver')

                        )
                      ],
                      backgroundColor: Colors.red,
                    ),
                  );

                  //VICTORIA
                  /*showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                  'VICTORIA',
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
                      )),
                  content: Text('TIEMPO, ACIERTOS...'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Volver'),
                    )
                  ],
                  backgroundColor: Colors.green,
                ),
              );*/

                },
                child: Text(
                    'START',
                    style:TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.09, // Tamaño de fuente
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
            ),

          ],
        ),

      ),
    );
  }
}