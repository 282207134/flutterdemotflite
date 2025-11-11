# TFLite Flutter Plugin Examples

This directory contains example implementations for using the TFLite Flutter plugin.

## Quick Examples

### Image Classification

```dart
import 'package:tflite/tflite.dart';

// Load model
await Tflite.loadModel(
  model: "assets/mobilenet_v1_1.0_224.tflite",
  labels: "assets/labels.txt",
);

// Run inference
var results = await Tflite.runModelOnImage(
  path: imagePath,
  numResults: 5,
  threshold: 0.5,
);

// Process results
for (var result in results) {
  print('${result['label']}: ${result['confidence']}');
}

// Clean up
await Tflite.close();
```

### Object Detection (SSD MobileNet)

```dart
// Load model
await Tflite.loadModel(
  model: "assets/ssd_mobilenet.tflite",
  labels: "assets/labels.txt",
);

// Detect objects
var detections = await Tflite.detectObjectOnImage(
  path: imagePath,
  model: "SSDMobileNet",
  threshold: 0.4,
  numResultsPerClass: 5,
);

// Process detections
for (var detection in detections) {
  print('Detected: ${detection['detectedClass']}');
  print('Confidence: ${detection['confidenceInClass']}');
  print('Bounding box: ${detection['rect']}');
}

await Tflite.close();
```

### Object Detection (YOLO)

```dart
// Load model
await Tflite.loadModel(
  model: "assets/yolov2_tiny.tflite",
  labels: "assets/labels.txt",
);

// Detect objects
var detections = await Tflite.detectObjectOnImage(
  path: imagePath,
  model: "YOLO",
  threshold: 0.3,
  imageMean: 0.0,
  imageStd: 255.0,
);

await Tflite.close();
```

### Real-time Camera Detection

```dart
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

// Initialize camera
final cameras = await availableCameras();
final camera = cameras.first;
final controller = CameraController(camera, ResolutionPreset.medium);
await controller.initialize();

// Load model
await Tflite.loadModel(
  model: "assets/model.tflite",
  labels: "assets/labels.txt",
);

// Start image stream
controller.startImageStream((CameraImage img) async {
  var results = await Tflite.runModelOnFrame(
    bytesList: img.planes.map((plane) => plane.bytes).toList(),
    imageHeight: img.height,
    imageWidth: img.width,
    numResults: 5,
  );
  
  // Process results
  print(results);
});

// Clean up when done
await controller.stopImageStream();
await Tflite.close();
```

### Pose Estimation (PoseNet)

```dart
// Load model
await Tflite.loadModel(
  model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
);

// Run pose estimation
var poses = await Tflite.runPoseNetOnImage(
  path: imagePath,
  numResults: 2,
  threshold: 0.7,
  nmsRadius: 10,
);

// Process poses
for (var pose in poses) {
  print('Pose score: ${pose['score']}');
  var keypoints = pose['keypoints'];
  for (var kp in keypoints.values) {
    print('${kp['part']}: (${kp['x']}, ${kp['y']}) - ${kp['score']}');
  }
}

await Tflite.close();
```

### Image Segmentation (Deeplab)

```dart
// Load model
await Tflite.loadModel(
  model: "assets/deeplabv3_257_mv_gpu.tflite",
);

// Run segmentation
var result = await Tflite.runSegmentationOnImage(
  path: imagePath,
  outputType: "png",
);

// result is a Uint8List containing PNG image bytes
// Save or display the segmented image
File('segmented.png').writeAsBytesSync(result);

await Tflite.close();
```

### Image-to-Image Translation (Pix2Pix)

```dart
// Load model
await Tflite.loadModel(
  model: "assets/pix2pix_model.tflite",
);

// Run translation
var result = await Tflite.runPix2PixOnImage(
  path: imagePath,
  imageMean: 0.0,
  imageStd: 255.0,
);

// result is a Uint8List containing the output image
File('output.png').writeAsBytesSync(result);

await Tflite.close();
```

## Complete Example Apps

For full working examples including UI implementations, refer to:

- **Image Classification App**: Classify images from gallery or camera
- **Object Detection App**: Real-time object detection with bounding boxes
- **Pose Estimation App**: Visualize body keypoints in real-time
- **Segmentation App**: Segment images and overlay results

## Pre-trained Models

Download pre-trained models from:
- [TensorFlow Lite Models](https://www.tensorflow.org/lite/models)
- [TensorFlow Hub](https://tfhub.dev/s?deployment-format=lite)

## Tips

1. **Model Placement**: Place `.tflite` models and `labels.txt` in `assets/` folder
2. **GPU Acceleration**: Use `useGpuDelegate: true` for better performance on supported devices
3. **Threading**: Adjust `numThreads` based on device capabilities
4. **Async Processing**: Keep `asynch: true` (default) to avoid blocking UI
5. **Threshold Tuning**: Adjust `threshold` to balance precision and recall
6. **Memory Management**: Always call `Tflite.close()` when done

## Troubleshooting

### Android
- Ensure `aaptOptions` is configured in `android/app/build.gradle`
- Check minSdkVersion is at least 19

### iOS
- Set "Compile Sources As" to "Objective-C++" if build fails
- Uncomment CONTRIB_PATH for older TensorFlow versions

## Resources

- [TensorFlow Lite Guide](https://www.tensorflow.org/lite/guide)
- [Flutter Plugin Documentation](https://flutter.dev/docs/development/packages-and-plugins)
- [Model Optimization](https://www.tensorflow.org/lite/performance/best_practices)
