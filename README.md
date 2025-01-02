# ascii_camera

<div align="center">

  [![Codacy Badge](https://app.codacy.com/project/badge/Grade/bb9197972e3d47a3a2ff5c207ede94ac)](https://app.codacy.com/gh/khlebobul/ascii_camera/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

  <p>Flutter application, to create ASCII effect</p>

  <img width="700" alt="SCR-20241017-odol" src="https://github.com/user-attachments/assets/09a1fbe0-4725-44e9-b712-4bfc56dff14f">

</div>

### About this project

I am passionate about generative art and enjoy creating unusual projects with p5.js. I'm also passionate about Flutter, and I had the idea to combine both directions. Especially since I haven't found similar projects that include an ASCII camera, which made the task even more interesting to realise.

### Demo

<div align="center">
  <img src="https://github.com/user-attachments/assets/51e08b36-f61e-4075-bdf3-18c658b79856" alt="demo" width="400">
</div>

### Table of Contents

- [About this project](#about-this-project)
- [Demo](#demo)
- [Usage](#usage)
- [Customisation](#customisation)
- [Contributions](#contributions)

### Usage

To implement this project I used the [camera](https://pub.dev/packages/camera) package and ASCII characters. The project works as follows ⬇️

<div align="center">
  <img width="700" alt="1_nB7Cx6VyqYLZlbAr9B79NQ" src="https://github.com/user-attachments/assets/258ff6bf-231c-45f4-af7a-bbb25ebd0d60">
</div>

* **ASCII Drawing:** the `ASCIIPainter` class is responsible for converting an image into ASCII art.
* **Cell Partitioning:** the image is divided into a grid of n x m cells.
* **Converting pixels to characters:** for each cell: 
    * The corresponding pixel of the original image is detected. 
    * The brightness of the pixel is calculated. 
    * Based on the brightness, an ASCII character is selected from the given set (`asciiChars`).
* **Drawing of characters:** for each cell, the corresponding ASCII character is drawn.
* **Image Refresh:** the process is repeated for each new frame from the camera, creating a live ASCII video effect.

#### Read more about this project ➡️ [Medium link](https://medium.com/@khlebobul/ascii-camera-effect-with-flutter-5433029f4387)

<div align="center">
  <img width="700" alt="example" src="https://github.com/user-attachments/assets/5413ea2e-e2e0-4510-9980-770930b73a89">
</div>

[Here's an example of a peacock zoomed in at two levels to show the ASCII characters](https://medium.com/r/?url=https%3A%2F%2Fianparberry.com%2Fart%2Fascii%2Fcolor%2F)

**The brightness of a pixel is calculated using the formula:** `0.299_R + 0.587_G + 0.114B`

```dart
 double _calculateBrightness(Color pixel) {  
    return (0.299 * pixel.red + 0.587 * pixel.green + 0.114 * pixel.blue) / 255;  
  }
```

It should be said here that the size of your grid may vary by platform and device, so I’ve taken these settings out for customisation.

### Customisation

It's up to you to customize it: choose the characters you want to use and the size of the grid. On my android emulator I managed to achieve the desired effect with the following settings. You may have to play around with the settings for your device yourself. For web and iOS everything works fine (but you can of course increase the grid size for detail).

```dart
void main() {
  const String asciiString = ".,_;^+*LTt1jZkAdGgDRNW@";
  final List<String> asciiChars = asciiString.split('');

  const Map<String, Map<String, double>> scaleParams = {
    'web': {'scaleX': 160, 'scaleY': 120},
    'ios': {'scaleX': 160, 'scaleY': 120},
    'android': {'scaleX': 750, 'scaleY': 550},
  };

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraApp(
        asciiChars: asciiChars,
        scaleParams: scaleParams,
        isColorMode: true, // color ASCII mode
      ),
    ),
  );
}
```

By the way, you can also try other symbols like ⬇️

`const String asciiString = "░▒▓█▓▒░";`

### Contributions

If you'd like to improve the project, I'd be only too happy `ʘ‿ʘ`
