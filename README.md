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

Compared to other color extraction packages in Dart, this package is lightweight, fast and simple to use, removing all the bloat and only providing you with only what you need.
<div style="display:flex; justify-content:center; align-items:center; height:100vh;">
    <img src="https://github.com/fisherman-23/colorgram-dart/assets/103990540/74ca1fa0-b6d2-4a7b-a3c9-3751e3a76e68" alt="Showcase Image" width="300">
</div>

Supports:

    JPG
    PNG / Animated APNG
    GIF / Animated GIF
    BMP
    WebP / Animated WebP

(based on supported file types by ImageProvider, other file types might be supported)

Benchmarks: (Desktop) without resizing
- 512x512 JPEG in ~ 30ms
- 5120x1440 JPEG in ~200ms

## Getting started
Please ensure your data is in an ImageProvider Object

- FileImage
- NetworkImage
- AssetImage
- etc


## Usage

This package only requires you to interact with one simple method, the extractColor(), which takes in an ImageProvider object and an integer representing the number of color outputs the user wants

```dart
ImageProvider provider = FileImage(File(r'test.png'));
List<CgColor> colorList =extractColor(provider, 10);
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

## Improving Performance via Resizing Images

This can yield significant performance improvements, especially from a high resolution image. 
However, do keep in mind that this will affect the percentage figures, and down sizing too much can drastically affect results, 
especially when two colors are very similar in percentage composition.


```dart
extractColor(ResizeImage(provider,height:50,width: 50),1);
```

NOTE: do also account for aspect ratio when resizing.

Passing a list of Images -> File/XFile type
```dart
List<List<CgColor>> finalData = imageList.map((e) => extractColor(FileImage(File(e.path)), 10)).toList();
```
Passing a list of Images -> Image Provider Objects
```dart
final imageList = [NetworkImage, FileImage, AssetImage]
List<List<CgColor>> finalData = imageList.map((e) => extractColor(e, 10)).toList();
```
## Additional information

Originally, this project supported usage in pure Dart projects, however this was sacrificed in exchange for significantly faster performance, a trade-off I deem worth it. Special thanks to And96 for the suggestions that helped to improve this package.

Do contribute to the project if you find a faster alternative

If you want to use it in your dart projects, please get the 1.0.1 version. 

Credits: darosh on Github for the original Colorgram library
