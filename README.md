# TFLite Flutter 插件

Flutter TensorFlow Lite 插件，支持图像分类、目标检测（SSD 和 YOLO）、Pix2Pix、Deeplab 和 PoseNet，同时兼容 iOS 和 Android 平台。

## 功能特性

- 🖼️ **图像分类** - 使用预训练模型对图像进行分类
- 🎯 **目标检测** - 使用 SSD MobileNet 和 YOLO 进行目标检测
- 🎨 **Pix2Pix** - 图像到图像的转换
- 🧩 **Deeplab** - 语义分割
- 🤸 **PoseNet** - 姿态估计
- ⚡ **GPU 加速** - 支持硬件加速
- 📹 **实时检测** - 处理视频帧

## 安装

在 `pubspec.yaml` 中添加：

```yaml
dependencies:
  tflite: ^1.1.2
```

### Android 配置

在 `android/app/build.gradle` 中添加：

```gradle
android {
    aaptOptions {
        noCompress 'tflite'
        noCompress 'lite'
    }
}
```

### iOS 配置

如果遇到构建错误：

**找不到 'vector' 文件：**
- 在 Xcode 中打开 `ios/Runner.xcworkspace`
- 点击 Runner > Targets > Runner > Build Settings
- 搜索 "Compile Sources As"
- 将值改为 "Objective-C++"

**找不到 'tensorflow/lite/kernels/register.h' 文件：**
- 对于早期版本的 TensorFlow，在 `ios/Classes/TflitePlugin.mm` 中取消注释 `//#define CONTRIB_PATH`

## 快速开始

### 1. 添加模型资源

创建 `assets` 文件夹并添加模型文件，在 `pubspec.yaml` 中更新：

```yaml
flutter:
  assets:
    - assets/labels.txt
    - assets/model.tflite
```

### 2. 导入插件

```dart
import 'package:tflite/tflite.dart';
```

### 3. 加载模型

```dart
await Tflite.loadModel(
  model: "assets/model.tflite",
  labels: "assets/labels.txt",
  numThreads: 1,
  useGpuDelegate: false,
);
```

### 4. 运行推理

```dart
var results = await Tflite.runModelOnImage(
  path: imagePath,
  numResults: 5,
  threshold: 0.5,
);
```

### 5. 清理资源

```dart
await Tflite.close();
```

## 使用方法

### 图像分类

**输出格式：**
```dart
{
  "index": 0,
  "label": "猫",
  "confidence": 0.87
}
```

**处理图像文件：**
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

**处理二进制数据：**
```dart
var results = await Tflite.runModelOnBinary(
  binary: imageBytes,
  numResults: 5,
  threshold: 0.1,
  asynch: true,
);
```

**处理视频帧：**
```dart
var results = await Tflite.runModelOnFrame(
  bytesList: img.planes.map((plane) => plane.bytes).toList(),
  imageHeight: img.height,
  imageWidth: img.width,
  numResults: 5,
  threshold: 0.1,
);
```

### 目标检测

**输出格式：**
```dart
{
  "detectedClass": "狗",
  "confidenceInClass": 0.92,
  "rect": {
    "x": 0.15,
    "y": 0.33,
    "w": 0.45,
    "h": 0.52
  }
}
```

**SSD MobileNet：**
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

**YOLO：**
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

### Deeplab 分割

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

**输出格式：**
```dart
[
  {
    "score": 0.85,
    "keypoints": {
      0: {"x": 0.5, "y": 0.3, "part": "nose", "score": 0.99},
      1: {"x": 0.45, "y": 0.28, "part": "leftEye", "score": 0.97},
      // ... 更多关键点
    }
  }
]
```

**使用方法：**
```dart
var results = await Tflite.runPoseNetOnImage(
  path: imagePath,
  numResults: 2,
  threshold: 0.7,
  nmsRadius: 10,
);
```

## API 参考

### 核心方法

| 方法 | 说明 |
|------|------|
| `loadModel()` | 加载 TFLite 模型和标签 |
| `close()` | 释放资源 |

### 图像分类

| 方法 | 说明 |
|------|------|
| `runModelOnImage()` | 处理图像文件 |
| `runModelOnBinary()` | 处理字节数组 |
| `runModelOnFrame()` | 处理视频帧 |

### 目标检测

| 方法 | 说明 |
|------|------|
| `detectObjectOnImage()` | 在图像文件中检测目标 |
| `detectObjectOnBinary()` | 在字节数组中检测目标 |
| `detectObjectOnFrame()` | 在视频帧中检测目标 |

### 图像处理

| 方法 | 说明 |
|------|------|
| `runPix2PixOnImage()` | 图像到图像转换 |
| `runSegmentationOnImage()` | 语义分割 |
| `runPoseNetOnImage()` | 姿态估计 |

## 参数说明

### 通用参数

- `model` - .tflite 模型文件路径
- `labels` - 标签文件路径
- `numThreads` - 线程数（默认：1）
- `useGpuDelegate` - 启用 GPU 加速（默认：false）
- `imageMean` - 图像归一化均值
- `imageStd` - 图像归一化标准差
- `numResults` - 最大结果数量
- `threshold` - 置信度阈值
- `asynch` - 异步运行（默认：true）

### YOLO 专用参数

- `anchors` - 锚框数组
- `blockSize` - 块大小（默认：32）
- `numBoxesPerBlock` - 每块的框数（默认：5）

### PoseNet 参数

- `nmsRadius` - 非极大值抑制半径（默认：20）

## GPU 加速

在 Android 上使用 GPU 加速以获得更好的性能，请参考 [TensorFlow 发布模式设置](https://www.tensorflow.org/lite/performance/gpu#step_5_release_mode)。

## 模型资源

兼容的 TensorFlow Lite 模型：
- [图像分类模型](https://www.tensorflow.org/lite/models/image_classification/overview)
- [目标检测模型](https://www.tensorflow.org/lite/models/object_detection/overview)
- [分割模型](https://www.tensorflow.org/lite/models/segmentation/overview)
- [姿态估计模型](https://www.tensorflow.org/lite/models/pose_estimation/overview)

## 示例

查看 [example](example/) 目录获取完整实现：
- 静态图像预测
- 实时相机检测
- 所有支持的模型类型

## 重大变更

### 从 1.1.0 开始
- iOS TensorFlow Lite 库从 TensorFlowLite 1.x 升级到 TensorFlowLiteObjC 2.x

### 从 1.0.0 开始
- 更新到 TensorFlow Lite API v1.12.0
- 移除 `inputSize` 和 `numChannels` 参数（从模型自动检测）
- 将 `numThreads` 移至 `Tflite.loadModel()`

## 开源协议

MIT License - 详见 [LICENSE](LICENSE) 文件

## 贡献

欢迎贡献！请随时提交 Pull Request。
