import 'dart:typed_data';
import 'package:flutter/material.dart';

class ASCIIPainter extends CustomPainter {
  final Uint8List imageData;
  final int imageWidth;
  final int imageHeight;
  final List<String> asciiChars = [' ', '.', ':', '-', '=', '+', '*', '#', '%', '@'];

  ASCIIPainter(this.imageData, this.imageWidth, this.imageHeight);

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = _calculateCellSize(size);
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    for (int y = 0; y < 60; y++) {
      for (int x = 0; x < 80; x++) {
        final asciiChar = _getAsciiChar(x, y);
        _drawAsciiChar(canvas, x, y, cellSize, asciiChar, paint);
      }
    }
  }

  Size _calculateCellSize(Size size) {
    return Size(size.width / 80, size.height / 60);
  }

  String _getAsciiChar(int x, int y) {
    final pixelX = (x / 80 * imageWidth).floor();
    final pixelY = (y / 60 * imageHeight).floor();

    final pixel = _getPixel(pixelX, pixelY);
    final brightness = _calculateBrightness(pixel);
    final asciiIndex = (brightness * (asciiChars.length - 1)).round();
    return asciiChars[asciiIndex];
  }

  void _drawAsciiChar(Canvas canvas, int x, int y, Size cellSize, String asciiChar, Paint paint) {
    final rect = Rect.fromLTWH(x * cellSize.width, y * cellSize.height, cellSize.width, cellSize.height);
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
    final index = (y * imageWidth + x) * 4;
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