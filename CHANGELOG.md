## 1.0.0

- Initial version.

## 1.0.1

- Added links to example

## 2.0.0

- Major performance improvements
- Makes it easier for resizing operations to be done on image
- Dropped pure dart support
- Flutter Web is now supported
- Changed how the main extractColor function works: Takes ImageProvider as the input instead of File

## 2.1.0

- Up to ~2.5x faster color sampling in release builds, with identical results
- Added `extractColorFromImage()` and `extractColorFromRgba()` for already decoded images and raw pixels
- Added `CgColor.toColor()` and `CgColor.toString()`
- Fixed `extractColor()` hanging forever when an image fails to load, it now completes with an error
- Fixed animated images throwing `Bad state: Future already completed` on every frame after extracting
- Fixed the image and a listener being kept alive after every call
- Requires Dart 3
