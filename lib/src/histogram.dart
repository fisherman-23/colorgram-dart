import 'dart:math';
import 'dart:typed_data';

/// Number of distinct buckets a pixel can fall into: 2 bits each of relative
/// luminance, hue and lightness.
const int bucketCount = 64;

/// Max pixels summed per pass so a [Uint32List] channel total can't overflow
/// (255 * 2^24 < 2^32).
const int _pixelsPerPass = 1 << 24;

/// Returns the 6-bit bucket id of a color, laid out as
/// `luminance << 4 | hue << 2 | lightness`, each being the top 2 bits of the
/// 8 bit value.
///
/// Gives exactly the same result as taking the top 2 bits of `hsl()` and of
/// `(r * 0.2126 + g * 0.7152 + b * 0.0722).toInt()` for every 8 bit RGB color,
/// but without allocating, dividing or (almost ever) using floating point.
@pragma('vm:prefer-inline')
int colorBucket(int r, int g, int b) {
  // Relative luminance scaled by 10000 to stay in integer math.
  final int lum = r * 2126 + g * 7152 + b * 722;
  int lumBucket = lum < 640000
      ? 0
      : lum < 1280000
          ? 1
          : lum < 1920000
              ? 2
              : 3;
  if (lum == 640000 || lum == 1280000 || lum == 1920000) {
    // Exactly on a boundary, where floating point rounding decides.
    lumBucket = (r * 0.2126 + g * 0.7152 + b * 0.0722).toInt() >> 6;
  }

  // Only which quarter of the 0-255 hue range the color lands in matters, so
  // the thresholds of hsl()'s `hue ~/ 6` (64, 128 and 192) are solved for
  // ahead of time and compared against without dividing.
  int most, least, hueBucket;
  if (r >= g && r >= b) {
    most = r;
    if (g >= b) {
      least = b;
      hueBucket = 0;
    } else {
      least = g;
      hueBucket = 3;
    }
  } else if (g >= b) {
    most = g;
    least = r < b ? r : b;
    hueBucket = (b - r) * 255 + 127 * (most - least) > 0 ? 1 : 0;
  } else {
    most = b;
    least = r < g ? r : g;
    final int diff = most - least;
    final int x = (r - g) * 255;
    hueBucket = x >= 132 * diff
        ? 3
        : x + 253 * diff > 0
            ? 2
            : 1;
  }

  final int lightnessBucket = (most + least) >> 7;
  return (lumBucket << 4) | (hueBucket << 2) | lightnessBucket;
}

/// Sums the red, green and blue values and pixel count of every bucket in an
/// RGBA byte list.
///
/// Returns [bucketCount] * 4 values: `[r, g, b, count]` for each bucket id.
List<int> bucketTotals(Uint8List rgba) {
  final totals = List<int>.filled(bucketCount * 4, 0);
  final acc = Uint32List(bucketCount * 4);
  final length = rgba.length;
  for (int start = 0; start < length; start += _pixelsPerPass * 4) {
    final end = min(start + _pixelsPerPass * 4, length);
    for (int i = start; i < end; i += 4) {
      final r = rgba[i], g = rgba[i + 1], b = rgba[i + 2];
      final k = colorBucket(r, g, b) << 2;
      acc[k] += r;
      acc[k + 1] += g;
      acc[k + 2] += b;
      acc[k + 3]++;
    }
    for (int k = 0; k < acc.length; k++) {
      totals[k] += acc[k];
      acc[k] = 0;
    }
  }
  return totals;
}
