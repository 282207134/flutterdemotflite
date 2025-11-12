# TFLite Flutter 插件示例

本目录包含使用 TFLite Flutter 插件的示例实现。

## 快速示例

### 图像分类

```dart
import 'package:tflite/tflite.dart';

// 加载模型
await Tflite.loadModel(
  model: "assets/mobilenet_v1_1.0_224.tflite",
  labels: "assets/labels.txt",
);

// 运行推理
var results = await Tflite.runModelOnImage(
  path: imagePath,
  numResults: 5,
  threshold: 0.5,
);

// 处理结果
for (var result in results) {
  print('${result['label']}: ${result['confidence']}');
}

// 清理
await Tflite.close();
```

### 目标检测 (SSD MobileNet)

```dart
// 加载模型
await Tflite.loadModel(
  model: "assets/ssd_mobilenet.tflite",
  labels: "assets/labels.txt",
);

// 检测目标
var detections = await Tflite.detectObjectOnImage(
  path: imagePath,
  model: "SSDMobileNet",
  threshold: 0.4,
  numResultsPerClass: 5,
);

// 处理检测结果
for (var detection in detections) {
  print('检测到: ${detection['detectedClass']}');
  print('置信度: ${detection['confidenceInClass']}');
  print('边界框: ${detection['rect']}');
}

await Tflite.close();
```

### 目标检测 (YOLO)

```dart
// 加载模型
await Tflite.loadModel(
  model: "assets/yolov2_tiny.tflite",
  labels: "assets/labels.txt",
);

// 检测目标
var detections = await Tflite.detectObjectOnImage(
  path: imagePath,
  model: "YOLO",
  threshold: 0.3,
  imageMean: 0.0,
  imageStd: 255.0,
);

await Tflite.close();
```

### 实时相机检测

```dart
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';

// 初始化相机
final cameras = await availableCameras();
final camera = cameras.first;
final controller = CameraController(camera, ResolutionPreset.medium);
await controller.initialize();

// 加载模型
await Tflite.loadModel(
  model: "assets/model.tflite",
  labels: "assets/labels.txt",
);

// 开始图像流
controller.startImageStream((CameraImage img) async {
  var results = await Tflite.runModelOnFrame(
    bytesList: img.planes.map((plane) => plane.bytes).toList(),
    imageHeight: img.height,
    imageWidth: img.width,
    numResults: 5,
  );
  
  // 处理结果
  print(results);
});

// 完成时清理
await controller.stopImageStream();
await Tflite.close();
```

### 姿态估计 (PoseNet)

```dart
// 加载模型
await Tflite.loadModel(
  model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
);

// 运行姿态估计
var poses = await Tflite.runPoseNetOnImage(
  path: imagePath,
  numResults: 2,
  threshold: 0.7,
  nmsRadius: 10,
);

// 处理姿态
for (var pose in poses) {
  print('姿态得分: ${pose['score']}');
  var keypoints = pose['keypoints'];
  for (var kp in keypoints.values) {
    print('${kp['part']}: (${kp['x']}, ${kp['y']}) - ${kp['score']}');
  }
}

await Tflite.close();
```

### 图像分割 (Deeplab)

```dart
// 加载模型
await Tflite.loadModel(
  model: "assets/deeplabv3_257_mv_gpu.tflite",
);

// 运行分割
var result = await Tflite.runSegmentationOnImage(
  path: imagePath,
  outputType: "png",
);

// result 是包含 PNG 图像字节的 Uint8List
// 保存或显示分割图像
File('segmented.png').writeAsBytesSync(result);

await Tflite.close();
```

### 图像到图像转换 (Pix2Pix)

```dart
// 加载模型
await Tflite.loadModel(
  model: "assets/pix2pix_model.tflite",
);

// 运行转换
var result = await Tflite.runPix2PixOnImage(
  path: imagePath,
  imageMean: 0.0,
  imageStd: 255.0,
);

// result 是包含输出图像的 Uint8List
File('output.png').writeAsBytesSync(result);

await Tflite.close();
```

## 完整示例应用

有关包括 UI 实现的完整工作示例，请参阅：

- **图像分类应用**：从相册或相机分类图像
- **目标检测应用**：带边界框的实时目标检测
- **姿态估计应用**：实时可视化身体关键点
- **分割应用**：分割图像并叠加结果

## 预训练模型

从以下位置下载预训练模型：
- [TensorFlow Lite 模型](https://www.tensorflow.org/lite/models)
- [TensorFlow Hub](https://tfhub.dev/s?deployment-format=lite)

## 提示

1. **模型放置**：将 `.tflite` 模型和 `labels.txt` 放在 `assets/` 文件夹中
2. **GPU 加速**：在支持的设备上使用 `useGpuDelegate: true` 获得更好的性能
3. **线程**：根据设备能力调整 `numThreads`
4. **异步处理**：保持 `asynch: true`（默认）以避免阻塞 UI
5. **阈值调整**：调整 `threshold` 以平衡精度和召回率
6. **内存管理**：完成后始终调用 `Tflite.close()`

## 故障排除

### Android
- 确保在 `android/app/build.gradle` 中配置了 `aaptOptions`
- 检查 minSdkVersion 至少为 19

### iOS
- 如果构建失败，将 "Compile Sources As" 设置为 "Objective-C++"
- 对于旧版 TensorFlow，取消注释 CONTRIB_PATH

## 资源

- [TensorFlow Lite 指南](https://www.tensorflow.org/lite/guide)
- [Flutter 插件文档](https://flutter.dev/docs/development/packages-and-plugins)
- [模型优化](https://www.tensorflow.org/lite/performance/best_practices)
