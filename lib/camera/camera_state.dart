import 'dart:async';
// ignore: unnecessary_import
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:ascii_camera/ascii_painter.dart';
import 'package:ascii_camera/camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraAppState extends State<CameraApp> with WidgetsBindingObserver {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  Uint8List? _lastImageData;
  int _imageWidth = 0;
  int _imageHeight = 0;
  late html.VideoElement _videoElement;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (kIsWeb) {
      _initializeWebCamera();
    } else {
      _initializeCamera();
    }
  }

  void _initializeCamera() {
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
  }

  void _initializeWebCamera() {
    _videoElement = html.VideoElement()
      ..autoplay = true
      ..style.objectFit = 'cover';

    html.window.navigator.mediaDevices
        ?.getUserMedia({'video': true}).then((stream) {
      _videoElement.srcObject = stream;
      _videoElement.onLoadedMetadata.listen((_) {
        setState(() {
          _isCameraInitialized = true;
          _imageWidth = _videoElement.videoWidth;
          _imageHeight = _videoElement.videoHeight;
        });
        _startWebImageProcessing();
      });
    }).catchError((error) {});
  }

  void _startWebImageProcessing() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isCameraInitialized) {
        timer.cancel();
        return;
      }
      _processWebFrame();
    });
  }

  void _processWebFrame() {
    final canvas = html.CanvasElement(
        width: _videoElement.videoWidth, height: _videoElement.videoHeight);
    canvas.context2D.drawImage(_videoElement, 0, 0);
    final imageData =
        canvas.context2D.getImageData(0, 0, canvas.width!, canvas.height!);
    setState(() {
      _lastImageData = Uint8List.fromList(imageData.data);
      _imageWidth = canvas.width!;
      _imageHeight = canvas.height!;
    });
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
        if (kIsWeb)
          const SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: HtmlElementView(viewType: 'videoElement'),
          )
        else
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CameraPreview(_controller),
          ),
        if (_lastImageData != null)
          CustomPaint(
            painter: ASCIIPainter(
                _lastImageData!, _imageWidth, _imageHeight, widget.asciiChars),
            size: Size.infinite,
          ),
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (!kIsWeb) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (kIsWeb) return;
    if (!_controller.value.isInitialized) return;

    if (state == AppLifecycleState.inactive) {
      _controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }
}
