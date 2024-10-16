import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

abstract class CameraHelper {
  void initialize({
    required VoidCallback onInitialized,
    required void Function(Uint8List, int, int) onImageProcessed,
  });
  Widget buildPreview();
  void dispose();
  void handleAppLifecycleState(AppLifecycleState state);
}

class MobileCameraHelper implements CameraHelper {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initialize({
    required VoidCallback onInitialized,
    required void Function(Uint8List, int, int) onImageProcessed,
  }) async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize().then((_) {
      onInitialized();
      _controller.startImageStream((image) {
        onImageProcessed(image.planes[0].bytes, image.width, image.height);
      });
    });
  }

  @override
  Widget buildPreview() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraPreview(_controller);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  void handleAppLifecycleState(AppLifecycleState state) {
    if (!_controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initialize(
        onInitialized: () {},
        onImageProcessed: (_, __, ___) {},
      );
    }
  }
}

CameraHelper createCameraHelper() => MobileCameraHelper();
