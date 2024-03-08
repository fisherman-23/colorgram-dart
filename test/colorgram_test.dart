import 'package:colorgram/colorgram.dart';
import 'package:test/test.dart';
import 'dart:io';


var image1 = File(r'test\assets\264x264.jpg'); //264x264 jpeg
var image2 = File(r'test\assets\512x512.jpg'); //512x512 jpeg
var image3 = File(r'test\assets\5120x1440.jpg'); //5120x1440 jpeg

var image4 = File(r'test\assets\264x264.png'); //264x264 png
var image5 = File(r'test\assets\512x512.png'); //512x512 png
var image6 = File(r'test\assets\5120x1440.png'); //5120x1440 png


void main() {

  test('Check 264x264 JPEG', () {
    final actual = [[237, 155, 116, 0.8150307322479884], [48, 40, 29, 0.0793568539390537], [140, 83, 61, 0.053936174806753896], [197, 95, 77, 0.021505376344086023], [245, 217, 193, 0.018655266226195105], [38, 49, 38, 0.005023678945171367], [247, 170, 142, 0.0023175137827294843], [96, 51, 40, 0.0014826330411250737], [77, 64, 44, 0.0014106605634005556], [53, 39, 43, 0.001281110103496423]];
    final results = extractColor(image1,10);
    var list = [];
    for (var i in results) {
      list.add([i.r,i.g,i.b,i.percentage]);
    }
    expect(actual, list);
  });
  test('Check 264x264 PNG', () {
    final actual = [[174, 17, 0, 0.24458186273079952], [241, 147, 0, 0.23163083744129745], [214, 70, 15, 0.19369658431292477], [149, 148, 148, 0.17285535104862468], [70, 23, 14, 0.06062771636087857], [251, 251, 251, 0.05935886591021789], [248, 214, 0, 0.01798267362832891], [40, 92, 203, 0.007890207974798004], [17, 22, 176, 0.007773532071288977], [8, 193, 241, 0.0036023685208412333]];
    final results = extractColor(image4,10);
    var list = [];
    for (var i in results) {
      list.add([i.r,i.g,i.b,i.percentage]);
    }
    expect(actual, list);
  });

  test('Check 5120x1440 JPEG', () {
    final actual = [
            [251, 152, 181, 0.21067834370878552],
            [230, 121, 173, 0.15694234348317723],
            [208, 85, 156, 0.14416011660627304],
            [139, 67, 143, 0.13740675585160758],
            [254, 160, 146, 0.08350197886811922],
            [130, 100, 202, 0.0758277182971327],
            [16, 54, 86, 0.05476340547692747],
            [253, 197, 177, 0.053020094741165306],
            [83, 69, 146, 0.04361426193666105],
            [253, 152, 120, 0.040084981030150915]
          ];
    final results = extractColor(image3,10);
    var list = [];
    for (var i in results) {
      list.add([i.r,i.g,i.b,i.percentage]);
    }
    expect(actual, list);
  });

    test('Check 5120x1440 PNG', () {
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
    final results = extractColor(image6,10);
    var list = [];
    for (var i in results) {
      list.add([i.r,i.g,i.b,i.percentage]);
    }
    expect(actual, list);
  });
}
