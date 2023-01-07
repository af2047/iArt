import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: MemoryImageApp(),
    );
  }
}

class MemoryImageApp extends StatefulWidget {
  @override
  _MemoryImageExampleState createState() {
    return _MemoryImageExampleState();
  }
}

class _MemoryImageExampleState extends State {

  Uint8List? imageData;

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  void loadAsset() async {
    Uint8List data = (await NetworkAssetBundle(Uri.parse('https://img.freepik.com'))
        .load("/free-photo/friendly-smart-basenji-dog-giving-his-paw-close-up-isolated-white_346278-1626.jpg?w=1060&t=st=1673053018~exp=1673053618~hmac=2788a7883c07867fbcf48745bc69189b6c55d94459b3e27a01d26ff9d5d9993e")
    )
        .buffer
        .asUint8List();

    // Sustituir esto por el resultado que nos da el servidor,
    // que ya está en formato de Uint8List

    setState(() => imageData = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prueba de imágenes'),
      ),
      body: Center(child: _ImageWrapper()),
    );
  }

  Widget _ImageWrapper() {
    if (imageData == null) {
      return CircularProgressIndicator();
    }

    return Container(
      //width: 150,
      //height: 150,
      decoration: BoxDecoration(
        image: DecorationImage(
            fit: BoxFit.cover, image: MemoryImage(imageData!, scale: 0.5)),
      ),
    );
  }
}