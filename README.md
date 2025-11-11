# TFLite Flutter Plugin

A Flutter plugin for TensorFlow Lite API with support for image classification, object detection (SSD and YOLO), Pix2Pix, Deeplab, and PoseNet on both iOS and Android.

## Features

- 🖼️ **Image Classification** - Classify images using pre-trained models
- 🎯 **Object Detection** - Detect objects with SSD MobileNet and YOLO
- 🎨 **Pix2Pix** - Image-to-image translation
- 🧩 **Deeplab** - Semantic segmentation
- 🤸 **PoseNet** - Pose estimation
- ⚡ **GPU Delegate** - Hardware acceleration support
- 📹 **Real-time Detection** - Process video frames

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  tflite: ^1.1.2
```

### Android Setup

In `android/app/build.gradle`, add:

```gradle
android {
    aaptOptions {
        noCompress 'tflite'
        noCompress 'lite'
    }
}
```

### iOS Setup

If you encounter build errors:

**'vector' file not found:**
- Open `ios/Runner.xcworkspace` in Xcode
- Click Runner > Targets > Runner > Build Settings
- Search "Compile Sources As"
- Change value to "Objective-C++"

**'tensorflow/lite/kernels/register.h' file not found:**
- For early TensorFlow versions, uncomment `//#define CONTRIB_PATH` in `ios/Classes/TflitePlugin.mm`

## Quick Start

### 1. Add Model Assets

Create an `assets` folder and add your model files. Update `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/labels.txt
    - assets/model.tflite
```

### 2. Import the Plugin

```dart
import 'package:tflite/tflite.dart';
```

### 3. Load Model

```dart
await Tflite.loadModel(
  model: "assets/model.tflite",
  labels: "assets/labels.txt",
  numThreads: 1,
  useGpuDelegate: false,
);
```

### 4. Run Inference

```dart
var results = await Tflite.runModelOnImage(
  path: imagePath,
  numResults: 5,
  threshold: 0.5,
);
```

### 5. Clean Up

```dart
await Tflite.close();
```

## Usage

### Image Classification

**Output Format:**
```dart
{
  "index": 0,
  "label": "cat",
  "confidence": 0.87
}
```

**On Image File:**
```dart
var results = await Tflite.runModelOnImage(
  path: imagePath,
  imageMean: 0.0,
  imageStd: 255.0,
  numResults: 5,
  threshold: 0.1,
  asynch: true,
);
```

**On Binary Data:**
```dart
var results = await Tflite.runModelOnBinary(
  binary: imageBytes,
  numResults: 5,
  threshold: 0.1,
  asynch: true,
);
```

**On Video Frame:**
```dart
var results = await Tflite.runModelOnFrame(
  bytesList: img.planes.map((plane) => plane.bytes).toList(),
  imageHeight: img.height,
  imageWidth: img.width,
  numResults: 5,
  threshold: 0.1,
);
```

### Object Detection

**Output Format:**
```dart
{
  "detectedClass": "dog",
  "confidenceInClass": 0.92,
  "rect": {
    "x": 0.15,
    "y": 0.33,
    "w": 0.45,
    "h": 0.52
  }
}
```

**SSD MobileNet:**
```dart
var results = await Tflite.detectObjectOnImage(
  path: imagePath,
  model: "SSDMobileNet",
  imageMean: 127.5,
  imageStd: 127.5,
  threshold: 0.4,
  numResultsPerClass: 5,
);
```

**YOLO:**
```dart
var results = await Tflite.detectObjectOnImage(
  path: imagePath,
  model: "YOLO",
  imageMean: 0.0,
  imageStd: 255.0,
  threshold: 0.3,
  numResultsPerClass: 5,
);
```

### Pix2Pix

```dart
var result = await Tflite.runPix2PixOnImage(
  path: imagePath,
  imageMean: 0.0,
  imageStd: 255.0,
  asynch: true,
);
```

### Deeplab Segmentation

```dart
var result = await Tflite.runSegmentationOnImage(
  path: imagePath,
  imageMean: 0.0,
  imageStd: 255.0,
  outputType: "png",
  asynch: true,
);
```

### PoseNet

**Output Format:**
```dart
[
  {
    "score": 0.85,
    "keypoints": {
      0: {"x": 0.5, "y": 0.3, "part": "nose", "score": 0.99},
      1: {"x": 0.45, "y": 0.28, "part": "leftEye", "score": 0.97},
      // ... more keypoints
    }
  }
]
```

**Usage:**
```dart
var results = await Tflite.runPoseNetOnImage(
  path: imagePath,
  numResults: 2,
  threshold: 0.7,
  nmsRadius: 10,
);
```

## API Reference

### Core Methods

| Method | Description |
|--------|-------------|
| `loadModel()` | Load TFLite model and labels |
| `close()` | Release resources |

### Image Classification

| Method | Description |
|--------|-------------|
| `runModelOnImage()` | Run on image file |
| `runModelOnBinary()` | Run on byte array |
| `runModelOnFrame()` | Run on video frame |

### Object Detection

| Method | Description |
|--------|-------------|
| `detectObjectOnImage()` | Detect objects in image file |
| `detectObjectOnBinary()` | Detect objects in byte array |
| `detectObjectOnFrame()` | Detect objects in video frame |

### Image Processing

| Method | Description |
|--------|-------------|
| `runPix2PixOnImage()` | Image-to-image translation |
| `runSegmentationOnImage()` | Semantic segmentation |
| `runPoseNetOnImage()` | Pose estimation |

## Parameters

### Common Parameters

- `model` - Path to .tflite model file
- `labels` - Path to labels file
- `numThreads` - Number of threads (default: 1)
- `useGpuDelegate` - Enable GPU acceleration (default: false)
- `imageMean` - Image normalization mean
- `imageStd` - Image normalization std
- `numResults` - Maximum number of results
- `threshold` - Confidence threshold
- `asynch` - Run asynchronously (default: true)

### YOLO-Specific Parameters

- `anchors` - Anchor boxes array
- `blockSize` - Block size (default: 32)
- `numBoxesPerBlock` - Boxes per block (default: 5)

### PoseNet Parameters

- `nmsRadius` - Non-maximum suppression radius (default: 20)

## GPU Delegate

For better performance with GPU delegate on Android, follow [TensorFlow's release mode setup](https://www.tensorflow.org/lite/performance/gpu#step_5_release_mode).

## Models

Compatible with TensorFlow Lite models:
- [Image Classification Models](https://www.tensorflow.org/lite/models/image_classification/overview)
- [Object Detection Models](https://www.tensorflow.org/lite/models/object_detection/overview)
- [Segmentation Models](https://www.tensorflow.org/lite/models/segmentation/overview)
- [Pose Estimation Models](https://www.tensorflow.org/lite/models/pose_estimation/overview)

## Example

Check the [example](example/) directory for complete implementations of:
- Static image prediction
- Real-time camera detection
- All supported model types

## Breaking Changes

### Since 1.1.0
- iOS TensorFlow Lite library upgraded from TensorFlowLite 1.x to TensorFlowLiteObjC 2.x

### Since 1.0.0
- Updated to TensorFlow Lite API v1.12.0
- Removed `inputSize` and `numChannels` parameters (auto-detected from model)
- Moved `numThreads` to `Tflite.loadModel()`

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
