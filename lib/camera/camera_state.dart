import 'dart:typed_data';
import 'package:ascii_camera/ascii_painter.dart';
import 'package:ascii_camera/camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'camera_web.dart' if (dart.library.io) 'camera_mobile.dart';

class CameraAppState extends State<CameraApp> with WidgetsBindingObserver {
  bool _isCameraInitialized = false;
  Uint8List? _lastImageData;
  int _imageWidth = 0;
  int _imageHeight = 0;

  late CameraHelper _cameraHelper;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _cameraHelper = createCameraHelper();
    _cameraHelper.initialize(
      onInitialized: () {
        setState(() {
          _isCameraInitialized = true;
        });
      },
      onImageProcessed: (imageData, width, height) {
        setState(() {
          _lastImageData = imageData;
          _imageWidth = width;
          _imageHeight = height;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      cameraPreview: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isCameraInitialized) {
      return _buildCameraPreview();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildCameraPreview() {
    return Stack(
      children: [
        _cameraHelper.buildPreview(),
        if (_lastImageData != null)
          CustomPaint(
            painter: ASCIIPainter(
              _lastImageData!, 
              _imageWidth, 
              _imageHeight, 
              widget.asciiChars,
              widget.scaleParams,
            ),
            size: Size.infinite,
          ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraHelper.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _cameraHelper.handleAppLifecycleState(state);
  }
}
