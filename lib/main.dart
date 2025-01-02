import 'package:ascii_camera/camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  const String asciiString = ".,_;^+*LTt1jZkAdGgDRNW@";
  //const String asciiString = "░▒▓█▓▒░";
  final List<String> asciiChars = asciiString.split('');

  const Map<String, Map<String, double>> scaleParams = {
    'web': {'scaleX': 160, 'scaleY': 120},
    'ios': {'scaleX': 160, 'scaleY': 120},
    'android': {'scaleX': 750, 'scaleY': 550},
  };

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraApp(
        camera: cameras.first,
        asciiChars: asciiChars,
        scaleParams: scaleParams,
        isColorMode: false,
      ),
    ),
  );
}
