import 'package:colorgram/colorgram.dart';
import 'package:test/test.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:async';

// if error message 'Failed to build test:test:', run dart pub upgrade

var image1 = FileImage(File(r'test\assets\264x264.jpg')); //264x264 jpeg
var image2 = FileImage(File(r'test\assets\512x512.jpg')); //512x512 jpeg
var image3 = FileImage(File(r'test\assets\5120x1440.jpg')); //5120x1440 jpeg

var image4 = FileImage(File(r'test\assets\264x264.png')); //264x264 png
var image5 = FileImage(File(r'test\assets\512x512.png')); //512x512 png
var image6 = FileImage(File(r'test\assets\5120x1440.png')); //5120x1440 png

Future<ui.Image> getImageFromProvider(ImageProvider provider) {
  final Completer<ui.Image> completer = Completer();

  // Create a dummy image widget
  final Image image = Image(image: provider);

  // Create a listener to extract ui.Image when the image is resolved
  final ImageStreamListener listener =
      ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info.image);
  });

  // Load the image
  final ImageStream stream = image.image.resolve(ImageConfiguration.empty);
  stream.addListener(listener);

  return completer.future;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  test('Check 264x264 JPEG', () async {
    final actual = [
      [237, 155, 116, 0.8152809505337414],
      [48, 40, 29, 0.08179245147479275],
      [140, 83, 61, 0.05399192563538928],
      [197, 95, 77, 0.021550795224343777],
      [245, 219, 196, 0.01866298866428171],
      [40, 50, 40, 0.004338893438501214],
      [94, 52, 41, 0.0015085556657040645],
      [78, 63, 45, 0.0012930477134606266],
      [241, 174, 145, 0.0010488053675847305],
      [143, 69, 75, 0.0005315862822004799]
    ];
    final results = await extractColor(image1, 10);
    var list = [];
    for (var i in results) {
      list.add([i.r, i.g, i.b, i.percentage]);
    }
    expect(actual, list);
  });
  test('Check 264x264 PNG', () async {
    final actual = [
      [174, 17, 0, 0.24458186273079952],
      [241, 147, 0, 0.23163083744129745],
      [214, 70, 15, 0.19369658431292477],
      [149, 148, 148, 0.17285535104862468],
      [70, 23, 14, 0.06062771636087857],
      [251, 251, 251, 0.05935886591021789],
      [248, 214, 0, 0.01798267362832891],
      [40, 92, 203, 0.007890207974798004],
      [17, 22, 176, 0.007773532071288977],
      [8, 193, 241, 0.0036023685208412333]
    ];
    final results = await extractColor(image4, 10);
    var list = [];
    for (var i in results) {
      list.add([i.r, i.g, i.b, i.percentage]);
    }
    expect(actual, list);
  });

  test('Check 5120x1440 JPEG', () async {
    final actual = [
      [251, 152, 181, 0.2102737193931652],
      [230, 121, 173, 0.15688201519234696],
      [208, 85, 156, 0.1442057378356561],
      [139, 67, 143, 0.137570146554289],
      [254, 160, 146, 0.08385371431320449],
      [130, 100, 202, 0.07576558071768333],
      [15, 54, 86, 0.05489450204501349],
      [254, 197, 177, 0.053061964925362665],
      [83, 69, 146, 0.04352014359050133],
      [253, 152, 120, 0.03997247543277743]
    ];
    final results = await extractColor(image3, 10);
    var list = [];
    for (var i in results) {
      list.add([i.r, i.g, i.b, i.percentage]);
    }
    expect(actual, list);
  });

  test('Check 5120x1440 PNG', () async {
    final actual = [
      [63, 88, 128, 0.2522772924608371],
      [28, 40, 67, 0.21604508803475433],
      [56, 16, 33, 0.11959690221909126],
      [50, 55, 93, 0.08973483409606657],
      [186, 143, 165, 0.08443419193420502],
      [153, 17, 37, 0.08004234347486412],
      [134, 70, 106, 0.07276472234163663],
      [117, 154, 190, 0.030605507618509664],
      [249, 215, 208, 0.02785469422705852],
      [230, 170, 180, 0.026644423592976765]
    ];
    final results = await extractColor(image6, 10);
    var list = [];
    for (var i in results) {
      list.add([i.r, i.g, i.b, i.percentage]);
    }
    expect(actual, list);
  });
}
