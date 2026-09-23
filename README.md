# Colorgram

[![pub package](https://img.shields.io/pub/v/colorgram.svg)](https://pub.dev/packages/colorgram)
[![pub points](https://img.shields.io/pub/points/colorgram)](https://pub.dev/packages/colorgram/score)
[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](LICENSE)

Extract the most prominent colors from any image in Flutter. A lightweight, fast Dart port of [Colorgram.js](https://github.com/darosh/colorgram-js).

<p align="center">
  <img src="https://github.com/fisherman-23/colorgram-dart/assets/103990540/74ca1fa0-b6d2-4a7b-a3c9-3751e3a76e68" alt="Colorgram showcase" width="300">
</p>

## Features

- **Simple**: one function call, from any `ImageProvider` to a list of colors
- **Fast**: a 512x512 JPEG in ~6ms, a 5120x1440 JPEG in ~110ms including decoding (Apple M4 Pro)
- **Lightweight**: no dependencies besides Flutter
- **Every platform**: Android, iOS, Web (including WebAssembly), Windows, macOS and Linux
- **Any format Flutter can decode**: JPG, PNG, GIF, BMP, WebP, and animated APNG/GIF/WebP (first frame)

Colors are grouped by their relative luminance, hue and lightness, then ranked by how much of the image they cover.

## Installation

```sh
flutter pub add colorgram
```

## Usage

Pass any `ImageProvider` (`FileImage`, `NetworkImage`, `AssetImage`, `MemoryImage`, ...) and the number of colors you want:

```dart
import 'package:colorgram/colorgram.dart';

final List<CgColor> colors = await extractColor(AssetImage('assets/photo.jpg'), 10);

for (final color in colors) {
  print('${color.r}, ${color.g}, ${color.b} covers ${color.percentage * 100}%');
}
```

Colors are sorted from most to least prominent. Each `CgColor` has:

| Field        | Type  | Description                                      |
| ------------ | ----- | ------------------------------------------------ |
| `r`, `g`, `b` | `int` | Color channels, 0 to 255                          |
| `percentage` | `num` | Share of the image this color covers, 0 to 1     |

You may get fewer colors than you asked for if the image doesn't have that many.

### Using the colors in widgets

```dart
Container(color: colors.first.toColor());
```

`toColor()` is the same as `Color.fromARGB(255, color.r, color.g, color.b)`.

### Multiple images

```dart
final List<List<CgColor>> palettes = await Future.wait(
  providers.map((provider) => extractColor(provider, 10)),
);
```

### Already have the image or its pixels?

Skip the `ImageProvider` if you have a decoded `ui.Image`, or its raw RGBA bytes (4 bytes per pixel, e.g. from `ui.Image.toByteData()`):

```dart
final fromImage = await extractColorFromImage(image, 10); // doesn't dispose the image
final fromPixels = extractColorFromRgba(rgbaBytes, 10);
```

## Performance tips

### Resize large images

Decoding is the slowest step for large images, and a few hundred pixels is plenty to find the main colors. Wrapping the provider in a `ResizeImage` makes Flutter decode it at a smaller size:

```dart
final colors = await extractColor(
  ResizeImage(provider, width: 256, height: 256, policy: ResizeImagePolicy.fit),
  10,
);
```

`ResizeImagePolicy.fit` keeps the aspect ratio. For a 5120x1440 JPEG this takes ~66ms instead of ~110ms, and the percentages stay within about 1 percentage point of the full size result. Shrinking much further can start to reorder colors that cover a similar share of the image.

### Keep huge images off the UI thread

`extractColorFromRgba` is synchronous, so you can run it in a background isolate (not available on Flutter Web):

```dart
final colors = await Isolate.run(() => extractColorFromRgba(rgbaBytes, 10));
```

## Notes

- Alpha is ignored. Pixels are read as premultiplied RGBA, so transparent areas count as black, and all results are fully opaque.
- Version 2.0 dropped pure Dart support in exchange for much faster decoding through Flutter. For pure Dart projects, use version 1.0.1.

## Example

For a full app built with Colorgram, see [colorgram-app](https://github.com/fisherman-23/colorgram-app).

## Credits

- [darosh](https://github.com/darosh) for the original Colorgram.js
- And96 for the suggestions that made 2.0 much faster

Contributions are welcome, especially if you find a faster approach!
