<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->



## Features

This library allows you to extract colors from an image, which can be used to determine the colors of Flutter widgets or output into a CSV. This is a port of the Colorgram JS library by darosh on GitHub.

It uses the Relative Luminance, Hue, and Lightness values to sample to colors. 

Compared to other color extraction packages in Dart, this package is lightweight, fast and simple to use, removing all the bloat and only providing you with only what you need. Additionally, it also supports usage in pure Dart projects.

Supports:

    JPG
    PNG / Animated APNG
    GIF / Animated GIF
    BMP
    TIFF
    TGA
    PVR
    ICO
    WebP / Animated WebP
    PSD
    EXR

(bascially any file that the Image library supports read operations for)

Benchmarks: (Desktop)
- 512x512 JPEG in ~ 100ms
- 5120x1440 JPEG in ~1000ms

## Getting started
Please ensure your image is converted into a File object from the File class in dart:io

1. If you have a file path, simply wrap it in a File function
```dart
final file = File('PATH TO YOUR IMAGE');
```
2. If you have a XFile type (used in image_picker & more) 
```dart
final rawXFile;
final file = File(rawXFile.path);
```


## Usage

This package only requires you to interact with one simple method, the extractColor(), which takes in a File object and an integer representing the number of color outputs the user wants

```dart
final file = File('PATH TO YOUR IMAGE');
List<CgColor> colorList =extractColor(file, 10);
```

The results will be outputted in a list of CgColor objects, in order of most prominent
```dart
CgColor(int r, int g, int b, num percentage)
```

You can then use this in your widgets using Flutter's Color object
```dart
Color.fromARGB(255, CgColor.r, CgColor.g, CgColor.b)
```

NOTE: The function does not take into account Alpha values, all outputs are considered to be fully opaque. Thus, the Alpha/Opacity values for the Color widgets should have a value of 255/1 respectively for accurate color representation.



Passing a list of Images -> File/XFile type
```dart
List<List<CgColor>> finalData = imageList.map((e) => extractColor(File(e.path), 10)).toList();
```

## Additional information

Please note that a significant portion of the program's execution time is spent converting the Image File to UINT8 bytes. If feasible, directly passing the byte data will cut the runtime in half.

Do contribute to the project if you find a faster alternative

Credits: darosh on Github for the original Colorgram library