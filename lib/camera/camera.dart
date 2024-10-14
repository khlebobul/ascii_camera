import 'package:ascii_camera/camera/camera_state.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraApp extends StatefulWidget {
  final CameraDescription camera;

  const CameraApp({super.key, required this.camera});

  @override
  CameraAppState createState() => CameraAppState();
}