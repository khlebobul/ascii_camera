import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
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

class WebCameraHelper implements CameraHelper {
  html.VideoElement? _videoElement;
  Timer? _timer;

  @override
  void initialize({
    required VoidCallback onInitialized,
    required void Function(Uint8List, int, int) onImageProcessed,
  }) {
    _videoElement = html.VideoElement()
      ..autoplay = true
      ..style.objectFit = 'cover';

    html.window.navigator.mediaDevices
        ?.getUserMedia({'video': true}).then((stream) {
      _videoElement!.srcObject = stream;
      _videoElement!.onLoadedMetadata.listen((_) {
        onInitialized();
        _startWebImageProcessing(onImageProcessed);
      });
    }).catchError((error) {
    });
  }

  void _startWebImageProcessing(
      void Function(Uint8List, int, int) onImageProcessed) {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      _processWebFrame(onImageProcessed);
    });
  }

  void _processWebFrame(void Function(Uint8List, int, int) onImageProcessed) {
    final canvas = html.CanvasElement(
        width: _videoElement!.videoWidth, height: _videoElement!.videoHeight);
    canvas.context2D.drawImage(_videoElement!, 0, 0);
    final imageData =
        canvas.context2D.getImageData(0, 0, canvas.width!, canvas.height!);
    onImageProcessed(
        Uint8List.fromList(imageData.data), canvas.width!, canvas.height!);
  }

  @override
  Widget buildPreview() {
    return const SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: HtmlElementView(viewType: 'videoElement'),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _videoElement?.srcObject?.getTracks().forEach((track) => track.stop());
  }

  @override
  void handleAppLifecycleState(AppLifecycleState state) {
  }
}

CameraHelper createCameraHelper() => WebCameraHelper();
