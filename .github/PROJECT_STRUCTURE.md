# 项目结构

```
flutter_tflite/
├── android/                          # Android 平台实现
│   ├── src/main/
│   │   ├── AndroidManifest.xml      # Android 清单文件
│   │   └── java/sq/flutter/tflite/
│   │       └── TflitePlugin.java    # Android 插件主文件 (56K)
│   ├── build.gradle                  # Android 构建配置
│   ├── settings.gradle               # Android 设置
│   └── gradle.properties             # Gradle 属性
│
├── ios/                              # iOS 平台实现
│   ├── Classes/
│   │   ├── TflitePlugin.h           # iOS 插件头文件
│   │   ├── TflitePlugin.mm          # iOS 插件主文件 (54K)
│   │   ├── ios_image_load.h         # 图像加载工具
│   │   └── ios_image_load.mm        # 图像加载实现
│   ├── Assets/                       # iOS 资源文件夹
│   └── tflite.podspec               # CocoaPods 规范
│
├── lib/
│   └── tflite.dart                  # Dart API 主文件 (417 行)
│
├── test/
│   └── tflite_test.dart             # 单元测试 (570 行)
│
├── example/
│   └── README.md                     # 使用示例和教程
│
├── .gitignore                        # Git 忽略规则
├── CHANGELOG.md                      # 版本历史 (75 行)
├── CONTRIBUTING.md                   # 贡献指南 (113 行)
├── LICENSE                           # MIT 许可证
├── README.md                         # 主文档 (323 行)
└── pubspec.yaml                      # 包配置
```

## 关键文件

### Dart 层 (`lib/tflite.dart`)
- Flutter 插件主 API
- Method Channel 通信
- 支持所有 TFLite 操作：
  - 图像分类
  - 目标检测（SSD、YOLO）
  - Pix2Pix
  - Deeplab 分割
  - PoseNet 姿态估计

### Android 层 (`android/src/main/java/sq/flutter/tflite/TflitePlugin.java`)
- Android 平台实现
- TensorFlow Lite 解释器集成
- 图像处理工具
- GPU 加速支持
- 异步操作处理

### iOS 层 (`ios/Classes/TflitePlugin.mm`)
- iOS 平台实现
- TensorFlow Lite C API 集成
- iOS 图像处理
- Metal GPU 加速支持
- 线程管理

## 文档

- **README.md**：清晰简洁的主文档和快速入门指南
- **CHANGELOG.md**：详细的版本历史
- **CONTRIBUTING.md**：贡献者指南
- **example/README.md**：全面的使用示例

## 配置文件

- **pubspec.yaml**：Flutter 包配置
- **android/build.gradle**：Android 构建设置
- **ios/tflite.podspec**：iOS CocoaPods 设置

## 代码统计

- Dart：~987 行
- Java (Android)：~1,587 行
- Objective-C++ (iOS)：~1,484 行
- 文档：~511 行
- 测试：~570 行

**总计：~4,639 行**
