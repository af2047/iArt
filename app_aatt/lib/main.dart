import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:dio/dio.dart';

import 'package:flutter/services.dart';

const server = "http://134.209.89.62:8000";

// MAIN-------------------------------------------------------------------------
Future<void> main() async {
  runApp(MyApp());
}

// CLASE APLICACIÓN-------------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Jason',
      ),
      home: const MyHomePage(title: 'IArt'),
    );
  }
}

// CLASE STATE------------------------------------------------------------------
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// CLASE PÁGINA DE INICIO-------------------------------------------------------
class _MyHomePageState extends State<MyHomePage> {
  var imageFile;
  Uint8List? imageData;

  // MÉTODO QUE INICIA EL ESTADO-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.
  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  // Ejemplo para cargar imagenes
  void loadAsset() async {
    // El data tiene que ser el resultado de la función del modelo
    Uint8List data =
        (await NetworkAssetBundle(Uri.parse('https://img.freepik.com')).load(

                // Poner aquí nuestra imagen
                "/free-photo/friendly-smart-basenji-dog-giving-his-paw-close-up-isolated-white_346278-1626.jpg?w=1060&t=st=1673053018~exp=1673053618~hmac=2788a7883c07867fbcf48745bc69189b6c55d94459b3e27a01d26ff9d5d9993e"))
            .buffer
            .asUint8List();
    // Sustituir esto por el resultado que nos da el servidor,
    // que ya está en formato de Uint8List
    setState(() => imageData = data);
  }

  // WIDGET CONSTRUCTOR (TODA LA PÁGINA DE INICIO)..............................
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // Barrita de arriba
          title: Text(widget.title, style: TextStyle(fontSize: 25)),
          leading:
              Image.asset('assets/images/logoAATT.png', width: 50, height: 50)),
      body: Center(
        // Contenido de la app
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logoAATT.png', width: 300, height: 300),
            const Text(
              'Bienvenid@\n',
              style: TextStyle(fontSize: 25),
            ),
            FloatingActionButton.large(
              // Botón de cámara
              onPressed: () {
                _showSelectionDialog(context);
              },
              backgroundColor: Colors.lightGreen,
              child: Icon(Icons.camera_alt_outlined),
            ),
            const Text(
              '\n',
              style: TextStyle(fontSize: 25),
            ),
          ],
        ),
      ),
    );
  }

  // MÉTODO QUE NOS PREGUNTA SI QUEREMOS IR A CÁMARA O GALERÍA
  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("¿De dónde quieres seleccionar la foto?"),
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

  // OPCIÓN DE GALERÍA
  void _openGallery(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    var picture = await _picker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      // mostrarla por pantalla
      imageFile = File(picture!.path);
      ;
    });
    Navigator.of(context).pop();
    _setScreen2();
  }

  // OPCIÓN DE ABRIR LA CÁMARA
  void _openCamera(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    var picture = await _picker.pickImage(source: ImageSource.camera);

    imageFile = File(picture!.path);

    Navigator.of(context).pop();
    _setScreen2();
  }

  // PASA A LA SIGUIENTE PANTALLA (solo si se selecciona la foto)
  Widget _setScreen2() {
    if (imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return Screen2(imageFile: imageFile, myHomePageState: this);
        }),
      );
      return Text("");
    } else {
      // Esto solo sale cuando inicio la app (porque no tengo nada en imageFile)
      return Text(" \n  \n Pulsa para escanear tu primer cuadro");
    }
  }
}

class Screen2 extends StatefulWidget {
  // Para utilizar imageFile
  var imageFile;
  // Para coger los metodos de la clase principal
  final _MyHomePageState myHomePageState;

  Screen2({this.imageFile, required this.myHomePageState});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  // La foto que se saca al cuadro del museo
  var imageFileMuseo;
  var imageFile;
  var myHomePageState;
  var imageModelo2fotos;
  var nombreModeloCorriente;
  var imageModeloBiblioteca;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Barrita morada de arriba
        title: Text('iArt'),
      ),
      body: Center(
          // Contenido de la app
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
        const Text(
          'Tu foto: \n',
          style: TextStyle(fontSize: 20),
        ),

        Image.file(widget.imageFile, width: 200, height: 200),

        const Text('\n\nCambiemos el estilo de tu foto\n',
            style: TextStyle(fontSize: 18)),

        // BOTÓN CÁMARA (ESCANEAR CUADRO)
        ElevatedButton(
          style: TextButton.styleFrom(
            textStyle: const TextStyle(fontSize: 24, fontFamily: 'Jason'),
            backgroundColor: Colors.lightGreen,
          ),
          onPressed: () {
            _openCameraMuseo(context);
          },
          child: const Text('ESCANEA UN CUADRO'),
        ),

        const Text('\nSi no, elige una corriente artística:\n',
            style: TextStyle(fontSize: 18)),

        // BOTONES SELECCIÓN DE CORRIENTES
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            OutlinedButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18, fontFamily: 'Jason'),
              ),
              onPressed: () {
                String corriente = "realism";
                _openScreen4(context, corriente);
              },
              child: Text("Realismo"),
            ),
            OutlinedButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18, fontFamily: 'Jason'),
              ),
              onPressed: () {
                String corriente = "expressionism";
                _openScreen4(context, corriente);
              },
              child: Text("Expresionismo"),
            ),
            OutlinedButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18, fontFamily: 'Jason'),
              ),
              onPressed: () {
                String corriente = "abstract";
                _openScreen4(context, corriente);
              },
              child: Text("Abstracto"),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            OutlinedButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18, fontFamily: 'Jason'),
              ),
              onPressed: () {
                String corriente = "color_field";
                _openScreen4(context, corriente);
              },
              child: Text("Color Field"),
            ),
            OutlinedButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18, fontFamily: 'Jason'),
              ),
              onPressed: () {
                String corriente = "romanticism";
                _openScreen4(context, corriente);
              },
              child: Text("Romanticismo"),
            ),
            OutlinedButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18, fontFamily: 'Jason'),
              ),
              onPressed: () {
                String corriente = "cubism";
                _openScreen4(context, corriente);
              },
              child: Text("Cubismo"),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            OutlinedButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18, fontFamily: 'Jason'),
              ),
              onPressed: () {
                String corriente = "impressionism";
                _openScreen4(context, corriente);
              },
              child: Text("Impresionismo"),
            ),
            OutlinedButton(
              style: TextButton.styleFrom(
                textStyle: const TextStyle(fontSize: 18, fontFamily: 'Jason'),
              ),
              onPressed: () {
                String corriente = "renaissance";
                _openScreen4(context, corriente);
              },
              child: Text("Renacentismo"),
            ),
          ],
        ),
      ])),
    );
  }

  void _openCameraMuseo(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    var pictureMuseo = await _picker.pickImage(source: ImageSource.camera);
    imageFileMuseo = File(pictureMuseo!.path);

    nombreModeloCorriente = await obtenerCorriente(imageFileMuseo);

    imageModelo2fotos = await modelo2fotos(widget.imageFile, imageFileMuseo);

    Navigator.of(context).pop();
    _setScreen3();
  }

  void _openScreen4(BuildContext context, String corriente) async {
    imageModeloBiblioteca =
        await modelofotocorriente(widget.imageFile, corriente);

    Navigator.of(context).pop();
    _setScreen4();
  }

  // MODELOS--------------------------------------------------------------------
  // MODELO BLEND IMAGEN + IMAGEN
  Future<Uint8List> modelo2fotos(File contentImage, File styleImage) async {
    String contentFileName = contentImage.path.split('/').last;
    String styleFileName = styleImage.path.split('/').last;
    FormData formData = FormData.fromMap({
      "content_image": await MultipartFile.fromFile(contentImage.path,
          filename: contentFileName),
      "style_image": await MultipartFile.fromFile(styleImage.path,
          filename: styleFileName),
    });
    var response = await Dio().post("$server/blend_images/",
        data: formData, options: Options(responseType: ResponseType.bytes));
    assert(response.statusCode == 200);
    //print(response.data);
    return response.data;
  }

  // MODELO BLEND IMAGEN + CORRIENTE
  Future<Uint8List> modelofotocorriente(File image, String corriente) async {
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "content_image":
          await MultipartFile.fromFile(image.path, filename: fileName),
    });
    //pasar un parámetro para cualquier corriente (a la que me va a cambiar en vez de abstract)
    var response = await Dio().post("$server/blend_image_with_$corriente/",
        data: formData, options: Options(responseType: ResponseType.bytes));
    assert(response.statusCode == 200);
    //print(response.data);
    return response.data;
  }

  // MODELO SACAR CORRIENTE
  Future<String> obtenerCorriente(File image) async {
    String fileName = image.path.split('/').last;
    FormData formData = FormData.fromMap({
      "content_image":
          await MultipartFile.fromFile(image.path, filename: fileName),
    });
    var response = await Dio().post("$server/detect_style/", data: formData);
    assert(response.statusCode == 200);
    //print(response.data);
    return response.data["description"];
  }

//-----------------------------------------------------------------------------

  Widget _setScreen3() {
    if (imageFileMuseo != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return Screen3(
              imageModelo2fotos: imageModelo2fotos,
              nombreModeloCorriente: nombreModeloCorriente);
        }),
      );
      return Text("");
    } else {
      return Text("");
    }
  }

  Widget _setScreen4() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Screen4(imageModeloBiblioteca: imageModeloBiblioteca);
    }));
    return Text("");
  }
}

class Screen3 extends StatefulWidget {
  // Para utilizar las imagenes que salieron de los modelos

  //var imageFile;
  //var imageFileMuseo;

  var imageModelo2fotos;
  var nombreModeloCorriente;

  Screen3({this.imageModelo2fotos, this.nombreModeloCorriente});

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Barrita morada de arriba
        title: Text('iArt'),
      ),
      body: Center(
          // Contenido de la app
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            Text('El cuadro que has escaneado', style: TextStyle(fontSize: 18)),
            Text('pertenece a la corriente:\n', style: TextStyle(fontSize: 18)),
            Text('${traduccion(widget.nombreModeloCorriente)}\n',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text(' \nESTA ES TU NUEVA OBRA DE ARTE \n',
                style: TextStyle(fontSize: 20)),
            Image.memory(widget.imageModelo2fotos, width: 300, height: 300),
            const Text(' \n \n')
          ])),
    );
  }

  String traduccion(String palabraIngles) {
    String palabraTraducida;

    if (palabraIngles == 'abstract') {
      palabraTraducida = 'ARTE ABSTRACTO';
    } else if (palabraIngles == 'cubism') {
      palabraTraducida = 'CUBISMO';
    } else if (palabraIngles == 'expressionism') {
      palabraTraducida = 'EXPRESIONISMO';
    } else if (palabraIngles == 'impressionism') {
      palabraTraducida = 'IMPRESIONISMO';
    } else if (palabraIngles == 'color_field') {
      palabraTraducida = 'COLOR FIELD';
    } else if (palabraIngles == 'renaissance') {
      palabraTraducida = 'RENACENTISMO';
    } else if (palabraIngles == 'realism') {
      palabraTraducida = 'REALISMO';
    } else {
      palabraTraducida = 'ROMANTICISMO';
    }

    return palabraTraducida;
  }
}

class Screen4 extends StatefulWidget {
  // Para utilizar imageFile

  var imageModeloBiblioteca;

  Screen4({this.imageModeloBiblioteca});

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Barrita morada de arriba
        title: Text('iArt'),
      ),
      body: Center(
          // Contenido de la app
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            const Text('\nESTA ES TU NUEVA OBRA DE ARTE \n\n',
                style: TextStyle(fontSize: 20)),
            Image.memory(widget.imageModeloBiblioteca, width: 350, height: 350),
            const Text('\n\n\n')
          ])),
    );
  }
}
