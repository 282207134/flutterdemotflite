/// TFLite Flutter 插件使用示例
/// 
/// 本文件展示了如何使用 TFLite 插件的各种功能
/// 所有代码都包含详细的中文注释

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:camera/camera.dart';

/// 图像分类示例
class ImageClassificationExample {
  /// 加载并运行图像分类模型
  Future<void> classifyImage(String imagePath) async {
    try {
      // 1. 加载模型
      // model: 模型文件路径
      // labels: 标签文件路径
      // numThreads: 使用的线程数，可以根据设备性能调整
      String? result = await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/labels.txt",
        numThreads: 2,
        useGpuDelegate: false, // 如果设备支持，可以设为 true 以提升性能
      );
      
      print('模型加载结果: $result');
      
      // 2. 对图像运行推理
      // path: 图像文件路径
      // imageMean: 图像归一化的均值，根据模型训练时的预处理设置
      // imageStd: 图像归一化的标准差
      // numResults: 返回前 N 个结果
      // threshold: 只返回置信度高于此阈值的结果
      var recognitions = await Tflite.runModelOnImage(
        path: imagePath,
        imageMean: 0.0,      // MobileNet 使用 0-255 范围
        imageStd: 255.0,
        numResults: 5,       // 返回前 5 个结果
        threshold: 0.1,      // 10% 置信度阈值
        asynch: true,        // 异步执行，不阻塞 UI
      );
      
      // 3. 处理结果
      // 结果格式: [{"index": 0, "label": "猫", "confidence": 0.87}, ...]
      if (recognitions != null) {
        for (var recognition in recognitions) {
          print('识别结果: ${recognition['label']} - '
                '置信度: ${(recognition['confidence'] * 100).toStringAsFixed(1)}%');
        }
      }
      
      // 4. 使用完毕后释放资源
      await Tflite.close();
      
    } catch (e) {
      print('图像分类出错: $e');
    }
  }
  
  /// 使用二进制数据进行分类
  /// 适用于从网络或内存中获取的图像数据
  Future<void> classifyBinary(Uint8List imageBytes) async {
    try {
      // 假设模型已经加载
      var recognitions = await Tflite.runModelOnBinary(
        binary: imageBytes,
        numResults: 5,
        threshold: 0.1,
      );
      
      // 处理结果...
      print('识别到 ${recognitions?.length ?? 0} 个结果');
      
    } catch (e) {
      print('二进制数据分类出错: $e');
    }
  }
}

/// 实时相机检测示例
class RealTimeDetectionExample {
  CameraController? _cameraController;
  bool _isDetecting = false;
  
  /// 初始化相机并开始实时检测
  Future<void> startRealTimeDetection() async {
    try {
      // 1. 获取可用相机
      final cameras = await availableCameras();
      final camera = cameras.first;
      
      // 2. 初始化相机控制器
      _cameraController = CameraController(
        camera,
        ResolutionPreset.medium, // 中等分辨率，平衡性能和质量
        enableAudio: false,
      );
      
      await _cameraController!.initialize();
      
      // 3. 加载模型
      await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/labels.txt",
        numThreads: 2,
      );
      
      // 4. 开始图像流处理
      _cameraController!.startImageStream((CameraImage image) async {
        // 避免同时处理多个帧
        if (_isDetecting) return;
        _isDetecting = true;
        
        try {
          // 将 CameraImage 转换为字节列表
          // bytesList: 包含图像平面数据的列表
          // imageHeight/imageWidth: 图像尺寸
          // rotation: Android 设备可能需要旋转图像
          var recognitions = await Tflite.runModelOnFrame(
            bytesList: image.planes.map((plane) => plane.bytes).toList(),
            imageHeight: image.height,
            imageWidth: image.width,
            imageMean: 127.5,    // 视频帧通常使用 127.5
            imageStd: 127.5,
            rotation: 90,        // 根据设备方向调整
            numResults: 3,       // 实时检测时减少结果数量以提高性能
            threshold: 0.3,      // 提高阈值以减少误检
            asynch: true,
          );
          
          // 处理结果（更新 UI 等）
          if (recognitions != null && recognitions.isNotEmpty) {
            print('实时检测: ${recognitions.first['label']}');
          }
          
        } catch (e) {
          print('帧处理出错: $e');
        } finally {
          _isDetecting = false;
        }
      });
      
    } catch (e) {
      print('实时检测初始化失败: $e');
    }
  }
  
  /// 停止检测并清理资源
  Future<void> stopRealTimeDetection() async {
    await _cameraController?.stopImageStream();
    await _cameraController?.dispose();
    await Tflite.close();
  }
}

/// 目标检测示例
class ObjectDetectionExample {
  /// 使用 SSD MobileNet 进行目标检测
  Future<void> detectObjectsSSD(String imagePath) async {
    try {
      // 1. 加载 SSD MobileNet 模型
      await Tflite.loadModel(
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_labels.txt",
      );
      
      // 2. 运行目标检测
      // model: 指定使用 SSDMobileNet
      // threshold: 检测置信度阈值
      // numResultsPerClass: 每个类别最多返回多少个结果
      var detections = await Tflite.detectObjectOnImage(
        path: imagePath,
        model: "SSDMobileNet",
        imageMean: 127.5,
        imageStd: 127.5,
        threshold: 0.4,        // 40% 置信度阈值
        numResultsPerClass: 5,
      );
      
      // 3. 处理检测结果
      // 结果格式: [{"detectedClass": "狗", "confidenceInClass": 0.92, 
      //            "rect": {"x": 0.15, "y": 0.33, "w": 0.45, "h": 0.52}}, ...]
      if (detections != null) {
        for (var detection in detections) {
          // 获取检测信息
          String className = detection['detectedClass'];
          double confidence = detection['confidenceInClass'];
          var rect = detection['rect'];
          
          // rect 中的坐标是归一化的 (0-1)，需要乘以图像尺寸得到实际坐标
          print('检测到: $className (${(confidence * 100).toStringAsFixed(1)}%)');
          print('位置: x=${rect['x']}, y=${rect['y']}, '
                'w=${rect['w']}, h=${rect['h']}');
        }
      }
      
      await Tflite.close();
      
    } catch (e) {
      print('SSD 目标检测出错: $e');
    }
  }
  
  /// 使用 YOLO 进行目标检测
  Future<void> detectObjectsYOLO(String imagePath) async {
    try {
      // 1. 加载 YOLO 模型
      await Tflite.loadModel(
        model: "assets/yolov2_tiny.tflite",
        labels: "assets/yolo_labels.txt",
      );
      
      // 2. 运行 YOLO 检测
      // YOLO 需要特定的参数配置
      // anchors: 锚框，用于预测边界框
      // blockSize: YOLO 网格大小
      // numBoxesPerBlock: 每个网格单元预测的边界框数量
      var detections = await Tflite.detectObjectOnImage(
        path: imagePath,
        model: "YOLO",
        imageMean: 0.0,        // YOLO 通常使用 0-255 范围
        imageStd: 255.0,
        threshold: 0.3,        // 30% 置信度阈值
        numResultsPerClass: 5,
        anchors: Tflite.anchors, // 使用默认锚框
        blockSize: 32,
        numBoxesPerBlock: 5,
      );
      
      // 处理结果...
      print('YOLO 检测到 ${detections?.length ?? 0} 个目标');
      
      await Tflite.close();
      
    } catch (e) {
      print('YOLO 目标检测出错: $e');
    }
  }
}

/// 图像分割示例 (Deeplab)
class ImageSegmentationExample {
  /// 运行语义分割
  Future<void> segmentImage(String imagePath) async {
    try {
      // 1. 加载 Deeplab 模型
      await Tflite.loadModel(
        model: "assets/deeplabv3_257_mv_gpu.tflite",
      );
      
      // 2. 运行分割
      // labelColors: 为每个类别指定颜色，默认使用 Pascal VOC 颜色
      // outputType: 输出格式，"png" 或 "bytes"
      Uint8List? segmentedImage = await Tflite.runSegmentationOnImage(
        path: imagePath,
        imageMean: 0.0,
        imageStd: 255.0,
        labelColors: Tflite.pascalVOCLabelColors, // 使用默认颜色方案
        outputType: "png",     // 输出 PNG 格式
      );
      
      // 3. 保存或显示分割结果
      if (segmentedImage != null) {
        // 保存到文件
        File outputFile = File('segmented_output.png');
        await outputFile.writeAsBytes(segmentedImage);
        print('分割结果已保存到: ${outputFile.path}');
      }
      
      await Tflite.close();
      
    } catch (e) {
      print('图像分割出错: $e');
    }
  }
}

/// 姿态估计示例 (PoseNet)
class PoseEstimationExample {
  /// 运行姿态估计
  Future<void> estimatePose(String imagePath) async {
    try {
      // 1. 加载 PoseNet 模型
      await Tflite.loadModel(
        model: "assets/posenet_mv1_075_float_from_checkpoints.tflite",
      );
      
      // 2. 运行姿态估计
      // numResults: 最多检测多少个人的姿态
      // threshold: 关键点置信度阈值
      // nmsRadius: 非极大值抑制半径，用于去除重复检测
      var poses = await Tflite.runPoseNetOnImage(
        path: imagePath,
        numResults: 2,         // 最多检测 2 个人
        threshold: 0.7,        // 70% 置信度阈值
        nmsRadius: 10,         // NMS 半径
      );
      
      // 3. 处理姿态结果
      // 结果格式: [{"score": 0.85, "keypoints": {...}}, ...]
      // keypoints 包含 17 个关键点：鼻子、眼睛、耳朵、肩膀、肘部、手腕、
      // 臀部、膝盖、脚踝等
      if (poses != null) {
        for (var pose in poses) {
          double score = pose['score'];
          var keypoints = pose['keypoints'];
          
          print('姿态得分: ${(score * 100).toStringAsFixed(1)}%');
          
          // 遍历关键点
          keypoints.forEach((key, value) {
            String part = value['part'];      // 部位名称
            double x = value['x'];            // x 坐标 (0-1)
            double y = value['y'];            // y 坐标 (0-1)
            double confidence = value['score']; // 置信度
            
            print('  $part: ($x, $y) - ${(confidence * 100).toStringAsFixed(1)}%');
          });
        }
      }
      
      await Tflite.close();
      
    } catch (e) {
      print('姿态估计出错: $e');
    }
  }
}

/// Pix2Pix 图像转换示例
class Pix2PixExample {
  /// 运行图像到图像的转换
  Future<void> transformImage(String imagePath) async {
    try {
      // 1. 加载 Pix2Pix 模型
      await Tflite.loadModel(
        model: "assets/pix2pix_model.tflite",
      );
      
      // 2. 运行转换
      // 例如：将草图转换为真实图像，或将白天场景转换为夜晚场景
      Uint8List? transformedImage = await Tflite.runPix2PixOnImage(
        path: imagePath,
        imageMean: 0.0,
        imageStd: 255.0,
        outputType: "png",
      );
      
      // 3. 保存转换结果
      if (transformedImage != null) {
        File outputFile = File('pix2pix_output.png');
        await outputFile.writeAsBytes(transformedImage);
        print('转换结果已保存到: ${outputFile.path}');
      }
      
      await Tflite.close();
      
    } catch (e) {
      print('Pix2Pix 转换出错: $e');
    }
  }
}

/// 完整应用示例
class TFLiteApp extends StatefulWidget {
  @override
  _TFLiteAppState createState() => _TFLiteAppState();
}

class _TFLiteAppState extends State<TFLiteApp> {
  String _result = '等待处理...';
  
  @override
  void initState() {
    super.initState();
    // 应用启动时加载模型
    _loadModel();
  }
  
  /// 加载模型
  Future<void> _loadModel() async {
    try {
      String? result = await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/labels.txt",
        numThreads: 2,
      );
      
      setState(() {
        _result = result ?? '模型加载成功';
      });
    } catch (e) {
      setState(() {
        _result = '模型加载失败: $e';
      });
    }
  }
  
  /// 处理图像
  Future<void> _processImage(String imagePath) async {
    try {
      var recognitions = await Tflite.runModelOnImage(
        path: imagePath,
        numResults: 5,
        threshold: 0.1,
      );
      
      if (recognitions != null && recognitions.isNotEmpty) {
        setState(() {
          _result = '识别结果:\n${recognitions.map((r) => 
            '${r['label']}: ${(r['confidence'] * 100).toStringAsFixed(1)}%'
          ).join('\n')}';
        });
      }
    } catch (e) {
      setState(() {
        _result = '处理失败: $e';
      });
    }
  }
  
  @override
  void dispose() {
    // 释放资源
    Tflite.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TFLite 示例'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_result),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // 选择图像并处理
                // _processImage('path/to/image.jpg');
              },
              child: Text('选择图像'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 性能优化建议
/// 
/// 1. 线程数优化：
///    - 单核设备：numThreads = 1
///    - 双核设备：numThreads = 2
///    - 多核设备：numThreads = 4 或更多
/// 
/// 2. GPU 加速：
///    - 在支持的设备上启用：useGpuDelegate = true
///    - 需要在 Android release 模式下额外配置
/// 
/// 3. 异步处理：
///    - 保持 asynch = true 以避免阻塞 UI
///    - 实时检测时控制帧率，避免过度消耗资源
/// 
/// 4. 模型优化：
///    - 使用量化模型减小体积和提高速度
///    - 根据需求选择合适的输入尺寸
/// 
/// 5. 内存管理：
///    - 及时调用 Tflite.close() 释放资源
///    - 避免同时加载多个大型模型
