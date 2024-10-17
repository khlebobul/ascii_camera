import 'dart:typed_data';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ASCIIPainter extends CustomPainter {
  final Uint8List imageData;
  final int imageWidth;
  final int imageHeight;
  final List<String> asciiChars;
  final Map<String, Map<String, double>> scaleParams;

  ASCIIPainter(this.imageData, this.imageWidth, this.imageHeight,
      this.asciiChars, this.scaleParams);

  @override
  void paint(Canvas canvas, Size size) {
    if (imageWidth == 0 || imageHeight == 0) {
      return;
    }

    final cellSize = _calculateCellSize(size);
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (int y = 0; y < 120; y++) {
      for (int x = 0; x < 160; x++) {
        final asciiChar = _getAsciiChar(x, y);
        _drawAsciiChar(canvas, x, y, cellSize, asciiChar, paint);
      }
    }
  }

  Size _calculateCellSize(Size size) {
    return Size(size.width / 160, size.height / 120);
  }

  String _getAsciiChar(int x, int y) {
    double scaleX, scaleY;

    if (kIsWeb) {
      scaleX = scaleParams['web']?['scaleX'] ?? 160;
      scaleY = scaleParams['web']?['scaleY'] ?? 120;
    } else if (Platform.isIOS) {
      scaleX = scaleParams['ios']?['scaleX'] ?? 160;
      scaleY = scaleParams['ios']?['scaleY'] ?? 120;
    } else if (Platform.isAndroid) {
      scaleX = scaleParams['android']?['scaleX'] ?? 750;
      scaleY = scaleParams['android']?['scaleY'] ?? 550;
    } else {
      scaleX = 160;
      scaleY = 120;
    }

    final pixelX = (x / scaleX * imageWidth).floor();
    final pixelY = (y / scaleY * imageHeight).floor();

    final pixel = _getPixel(pixelX, pixelY);
    final brightness = _calculateBrightness(pixel);
    final asciiIndex = (brightness * (asciiChars.length - 1)).round();
    return asciiChars[asciiIndex];
  }

  void _drawAsciiChar(Canvas canvas, int x, int y, Size cellSize,
      String asciiChar, Paint paint) {
    final rect = Rect.fromLTWH(x * cellSize.width, y * cellSize.height,
        cellSize.width, cellSize.height);
    canvas.drawRect(rect, paint);

    TextPainter(
      text: TextSpan(
        text: asciiChar,
        style: TextStyle(color: Colors.white, fontSize: cellSize.height),
      ),
      textDirection: TextDirection.ltr,
    )
      ..layout(minWidth: 0, maxWidth: cellSize.width)
      ..paint(canvas, Offset(x * cellSize.width, y * cellSize.height));
  }

  double _calculateBrightness(Color pixel) {
    return (0.299 * pixel.red + 0.587 * pixel.green + 0.114 * pixel.blue) / 255;
  }

  Color _getPixel(int x, int y) {
    int index = (y * imageWidth + x) * 4;
    if (index + 2 >= imageData.length) {
      return Colors.black;
    }
    return Color.fromARGB(
      255,
      imageData[index],
      imageData[index + 1],
      imageData[index + 2],
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
