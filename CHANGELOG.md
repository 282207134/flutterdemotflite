## 1.1.2

- 为 Android 添加 null safety 支持
- 文档改进

## 1.1.1

- 修复 Android 上的错误：预期有 ';'

## 1.1.0

- 升级到 TensorFlowLiteObjC 2.2
- 添加 GPU 加速支持
- 修复 YOLO 的标签大小

## 1.0.6

- 添加对打包资源外部资源的支持
- 升级 Flutter SDK 和 Android Studio 版本
- 设置最低 SDK 版本为 2.1.0

## 1.0.5

- 设置 compileSdkVersion 为 28
- 添加关于 CONTRIB_PATH 的说明
- 为 Flutter 1.10.0 及更高版本更新 pubspec.yaml
- 更新示例应用以使用 image 插件 2.1.4

## 1.0.4

- 添加 PoseNet 支持

## 1.0.3

- 添加 asynch 选项以将 TfLite 运行从 UI 线程卸载
- 添加 Deeplab 支持

## 1.0.2

- 添加 pix2pix 支持
- 使 Android 中的检测数量动态化

## 1.0.1

- 添加 detectObjectOnBinary
- 添加 runModelOnFrame
- 添加 detectObjectOnFrame

## 1.0.0

- 支持使用 SSD MobileNet 和 Tiny YOLOv2 进行目标检测
- 更新到 TensorFlow Lite API v1.12.0
- 不再接受 `inputSize` 和 `numChannels` 参数（从输入张量检索）
- 将 `numThreads` 移至 `Tflite.loadModel`

## 0.0.5

- 支持字节列表：runModelOnBinary

## 0.0.4

- 支持基于 Swift 的项目

## 0.0.3

- 在 Android 中通过通道传递错误消息
- 在 iOS 中使用非硬编码标签大小

## 0.0.2

- 修复链接

## 0.0.1

- 初始版本
