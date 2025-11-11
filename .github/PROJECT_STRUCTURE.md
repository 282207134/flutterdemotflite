# Project Structure

```
flutter_tflite/
├── android/                          # Android platform implementation
│   ├── src/main/
│   │   ├── AndroidManifest.xml      # Android manifest
│   │   └── java/sq/flutter/tflite/
│   │       └── TflitePlugin.java    # Main Android plugin (56K)
│   ├── build.gradle                  # Android build configuration
│   ├── settings.gradle               # Android settings
│   └── gradle.properties             # Gradle properties
│
├── ios/                              # iOS platform implementation
│   ├── Classes/
│   │   ├── TflitePlugin.h           # iOS plugin header
│   │   ├── TflitePlugin.mm          # Main iOS plugin (54K)
│   │   ├── ios_image_load.h         # Image loading utilities
│   │   └── ios_image_load.mm        # Image loading implementation
│   ├── Assets/                       # iOS assets folder
│   └── tflite.podspec               # CocoaPods specification
│
├── lib/
│   └── tflite.dart                  # Main Dart API (417 lines)
│
├── test/
│   └── tflite_test.dart             # Unit tests (570 lines)
│
├── example/
│   └── README.md                     # Usage examples and tutorials
│
├── .gitignore                        # Git ignore rules
├── CHANGELOG.md                      # Version history (75 lines)
├── CONTRIBUTING.md                   # Contribution guidelines (113 lines)
├── LICENSE                           # MIT License
├── README.md                         # Main documentation (323 lines)
└── pubspec.yaml                      # Package configuration
```

## Key Files

### Dart Layer (`lib/tflite.dart`)
- Main Flutter plugin API
- Method channel communication
- Supports all TFLite operations:
  - Image classification
  - Object detection (SSD, YOLO)
  - Pix2Pix
  - Deeplab segmentation
  - PoseNet pose estimation

### Android Layer (`android/src/main/java/sq/flutter/tflite/TflitePlugin.java`)
- Android platform implementation
- TensorFlow Lite interpreter integration
- Image processing utilities
- GPU delegate support
- Async operation handling

### iOS Layer (`ios/Classes/TflitePlugin.mm`)
- iOS platform implementation
- TensorFlow Lite C API integration
- Image processing for iOS
- Metal GPU delegate support
- Thread management

## Documentation

- **README.md**: Clear, concise main documentation with quick start guide
- **CHANGELOG.md**: Detailed version history
- **CONTRIBUTING.md**: Guidelines for contributors
- **example/README.md**: Comprehensive usage examples

## Configuration Files

- **pubspec.yaml**: Flutter package configuration
- **android/build.gradle**: Android build setup
- **ios/tflite.podspec**: iOS CocoaPods setup

## Total Lines of Code

- Dart: ~987 lines
- Java (Android): ~1,587 lines
- Objective-C++ (iOS): ~1,484 lines
- Documentation: ~511 lines
- Tests: ~570 lines

**Total: ~4,639 lines**
