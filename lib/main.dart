import 'package:ascii_camera/camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  const String asciiString = ".,_;^+*LTt1jZkAdGgDRNW@";
  //const String asciiString = "░▒▓█▓▒░";
  final List<String> asciiChars = asciiString.split('');

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraApp(camera: cameras.first, asciiChars: asciiChars),
    ),
  );
}
