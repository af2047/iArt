import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override


  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(title: 'IArt'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var imageFile;


  // CONSTRUCTOR

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('Tu perfil'),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Tu historial'),
            ),
            ListTile(
              leading: Icon(Icons.build_circle_outlined),
              title: Text('Configuración'),
            ),
          ],
        ),
      ),
      appBar: AppBar(

        title: Text(widget.title),
      ),


      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
                'Bienvenid@ a IArt!'
            ),
            const Text(
                ''
            ),

            _setImageView(),

            const Text(
                ''
            ),
            const Text(
                ''
            ),
            FloatingActionButton(
              onPressed: () {
                _showSelectionDialog(context);
              },
              backgroundColor: Colors.deepPurpleAccent,
              child: Icon(Icons.camera_alt_outlined),
            ),




          ],
        ),

      ),


    );
  }


  // MÉTODO QUE NOS PREGUNTA SI QUEREMOS IR A CÁMARA O
  // COGER LA FOTO DE LA GALERÍA
  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("De dónde quieres seleccionar la foto?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Galería"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Cámara"),
                      onTap: () {
                        _openCamera(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  // SI ESCOJO LA OPCIÓN DE GALERÍA
  void _openGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    var picture = await _picker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  // SI ESCOJO LA OPCIÓN DE ABRIR LA CÁMARA
  void _openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    var picture = await _picker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }


  // VERIFICA SI LA VAR ES DISTINTA DE NULL
  Widget _setImageView() {
    if (imageFile != null) {
      return Image.file(imageFile, width: 500, height: 500);
    } else {
      return Text("Pulsa para escanear tu primer cuadro");
    }
  }
}









