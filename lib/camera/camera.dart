import 'package:ascii_camera/camera/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraApp extends StatefulWidget {
  final CameraDescription camera;

  const CameraApp({super.key, required this.camera});

  @override
  CameraAppState createState() => CameraAppState();
}

class CameraView extends StatelessWidget {
  final Widget cameraPreview;

  const CameraView({super.key, required this.cameraPreview});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
