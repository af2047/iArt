/// Archivo de prueba para comprobar que los métodos HTTP funcionan
/// Ejecutar como standalone, sin Flutter

import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'dart:io';

const server = "http://134.209.89.62:8000";

void probarHttp() async {
  // Hace una petición de prueba a Google
  try {
    var response = await Dio().get('http://www.google.com');
    assert(response.statusCode == 200);
  } catch (e) {
    print(e);
  }
}

void probarServidor() async {
  // Hace una petición de prueba a nuestro servidor
  // Si esto falla y la de arriba ha funcionado, probablemente es problema del backend
  try {
    var response = await Dio().get(server);
    assert(response.statusCode == 200);
    assert(response.data["message"] == "Hola mundo");
  } catch (e) {
    print(e);
  }
}

Future<Uint8List> probarSubidaImagen(File image) async {
  String fileName = image.path.split('/').last;
  FormData formData = FormData.fromMap({
    "content_image": await MultipartFile.fromFile(image.path, filename:fileName),
  });
  var response = await Dio().post("$server/blend_image_with_abstract/", data: formData,
      options: Options(responseType: ResponseType.bytes));
  assert(response.statusCode == 200);
  //print(response.data);
  return response.data;
}

Future<Uint8List> probarSubidaDosImagenes(File contentImage, File styleImage) async {
  String contentFileName = contentImage.path.split('/').last;
  String styleFileName = styleImage.path.split('/').last;
  FormData formData = FormData.fromMap({
    "content_image": await MultipartFile.fromFile(contentImage.path, filename:contentFileName),
    "style_image": await MultipartFile.fromFile(styleImage.path, filename:styleFileName),
  });
  var response = await Dio().post("$server/blend_images/", data: formData,
      options: Options(responseType: ResponseType.bytes));
  assert(response.statusCode == 200);
  //print(response.data);
  return response.data;
}

void main() {
  probarHttp();
  probarServidor();
  probarSubidaImagen(File('lib/mico.png'));
  probarSubidaDosImagenes(File('lib/mico.png'), File('lib/monalisa.png'));
}