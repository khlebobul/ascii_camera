import 'dart:async';
import 'dart:typed_data';
import 'package:ascii_camera/ascii_painter.dart';
import 'package:ascii_camera/camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraAppState extends State<CameraApp> with WidgetsBindingObserver {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isCameraInitialized = false;
  Uint8List? _lastImageData;
  int _imageWidth = 0;
  int _imageHeight = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  void _initializeCamera() {
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isCameraInitialized = true;
      });
      _controller.startImageStream(_processImage);
    });
  }

  void _processImage(CameraImage image) {
    if (!_isCameraInitialized) return;

    setState(() {
      _lastImageData = image.planes[0].bytes;
      _imageWidth = image.width;
      _imageHeight = image.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            _isCameraInitialized) {
          return _buildCameraPreview();
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildCameraPreview() {
    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: CameraPreview(_controller),
        ),
        if (_lastImageData != null)
          CustomPaint(
            painter: ASCIIPainter(_lastImageData!, _imageWidth, _imageHeight),
            size: Size.infinite,
          ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }
}
