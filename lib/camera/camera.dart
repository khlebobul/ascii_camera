import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';
import 'camera_state.dart';

class CameraApp extends StatefulWidget {
  final CameraDescription camera;
  final List<String> asciiChars;
  final Map<String, Map<String, double>> scaleParams;

  const CameraApp({
    super.key, 
    required this.camera, 
    required this.asciiChars,
    required this.scaleParams,
  });

  @override
  CameraAppState createState() => CameraAppState();
}

class CameraView extends StatelessWidget {
  final Widget cameraPreview;

  const CameraView({super.key, required this.cameraPreview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: kIsWeb
          ? cameraPreview
          : Column(
              children: [
                Container(
                  height: 100,
                  color: Colors.black,
                ),
                Expanded(
                  child: cameraPreview,
                ),
                Container(
                  height: 100,
                  color: Colors.black,
                ),
              ],
            ),
    );
  }
}
