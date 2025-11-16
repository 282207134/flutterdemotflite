import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' show Color;
import 'package:flutter/services.dart';

/// TensorFlow Lite Flutter 插件主类
/// 
/// 提供了在 Flutter 应用中运行 TensorFlow Lite 模型的接口
/// 支持图像分类、目标检测、姿态估计、图像分割等多种 ML 任务
class Tflite {
  /// Method Channel，用于与原生平台（Android/iOS）通信
  static const MethodChannel _channel = MethodChannel('tflite');

  /// 加载 TensorFlow Lite 模型
  /// 
  /// [model] - 模型文件路径，如 "assets/model.tflite"
  /// [labels] - 标签文件路径，如 "assets/labels.txt"
  /// [numThreads] - 推理使用的线程数，默认为 1
  /// [isAsset] - 模型是否在 assets 目录中，默认为 true
  /// [useGpuDelegate] - 是否使用 GPU 加速，默认为 false
  /// 
  /// 返回：加载结果字符串，成功返回 "success"
  static Future<String?> loadModel({
    required String model,
    String labels = "",
    int numThreads = 1,
    bool isAsset = true,
    bool useGpuDelegate = false,
  }) async {
    return await _channel.invokeMethod(
      'loadModel',
      {
        "model": model,
        "labels": labels,
        "numThreads": numThreads,
        "isAsset": isAsset,
        'useGpuDelegate': useGpuDelegate
      },
    );
  }

  /// 对图像文件运行图像分类模型
  /// 
  /// [path] - 图像文件路径
  /// [imageMean] - 图像归一化均值，默认为 117.0
  /// [imageStd] - 图像归一化标准差，默认为 1.0
  /// [numResults] - 返回的最大结果数量，默认为 5
  /// [threshold] - 置信度阈值，低于此值的结果会被过滤，默认为 0.1
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：识别结果列表，每个结果包含 index、label 和 confidence
  static Future<List?> runModelOnImage({
    required String path,
    double imageMean = 117.0,
    double imageStd = 1.0,
    int numResults = 5,
    double threshold = 0.1,
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runModelOnImage',
      {
        "path": path,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "numResults": numResults,
        "threshold": threshold,
        "asynch": asynch,
      },
    );
  }

  /// 对二进制数据运行图像分类模型
  /// 
  /// [binary] - 图像的二进制数据（Uint8List）
  /// [numResults] - 返回的最大结果数量，默认为 5
  /// [threshold] - 置信度阈值，默认为 0.1
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：识别结果列表
  static Future<List?> runModelOnBinary({
    required Uint8List binary,
    int numResults = 5,
    double threshold = 0.1,
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runModelOnBinary',
      {
        "binary": binary,
        "numResults": numResults,
        "threshold": threshold,
        "asynch": asynch,
      },
    );
  }

  /// 对视频帧运行图像分类模型（用于实时检测）
  /// 
  /// [bytesList] - 图像平面数据列表（来自 CameraImage）
  /// [imageHeight] - 图像高度，默认为 1280
  /// [imageWidth] - 图像宽度，默认为 720
  /// [imageMean] - 图像归一化均值，默认为 127.5
  /// [imageStd] - 图像归一化标准差，默认为 127.5
  /// [rotation] - 图像旋转角度（仅 Android），默认为 90 度
  /// [numResults] - 返回的最大结果数量，默认为 5
  /// [threshold] - 置信度阈值，默认为 0.1
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：识别结果列表
  static Future<List?> runModelOnFrame({
    required List<Uint8List> bytesList,
    int imageHeight = 1280,
    int imageWidth = 720,
    double imageMean = 127.5,
    double imageStd = 127.5,
    int rotation = 90,
    int numResults = 5,
    double threshold = 0.1,
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runModelOnFrame',
      {
        "bytesList": bytesList,
        "imageHeight": imageHeight,
        "imageWidth": imageWidth,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "rotation": rotation,
        "numResults": numResults,
        "threshold": threshold,
        "asynch": asynch,
      },
    );
  }

  /// YOLO 模型的默认锚框（anchor boxes）
  /// 用于目标检测中预测边界框的位置和大小
  static const anchors = [
    0.57273,
    0.677385,
    1.87446,
    2.06253,
    3.33843,
    5.47434,
    7.88282,
    3.52778,
    9.77052,
    9.16828
  ];

  /// 对图像文件运行目标检测模型
  /// 
  /// [path] - 图像文件路径
  /// [model] - 模型类型，"SSDMobileNet" 或 "YOLO"，默认为 "SSDMobileNet"
  /// [imageMean] - 图像归一化均值，默认为 127.5
  /// [imageStd] - 图像归一化标准差，默认为 127.5
  /// [threshold] - 置信度阈值，默认为 0.1
  /// [numResultsPerClass] - 每个类别返回的最大结果数，默认为 5
  /// [anchors] - 锚框数组（仅用于 YOLO）
  /// [blockSize] - 块大小（仅用于 YOLO），默认为 32
  /// [numBoxesPerBlock] - 每个块的边界框数量（仅用于 YOLO），默认为 5
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：检测结果列表，每个结果包含 detectedClass、confidenceInClass 和 rect（边界框）
  static Future<List?> detectObjectOnImage({
    required String path,
    String model = "SSDMobileNet",
    double imageMean = 127.5,
    double imageStd = 127.5,
    double threshold = 0.1,
    int numResultsPerClass = 5,
    List anchors = anchors,
    int blockSize = 32,
    int numBoxesPerBlock = 5,
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'detectObjectOnImage',
      {
        "path": path,
        "model": model,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "threshold": threshold,
        "numResultsPerClass": numResultsPerClass,
        "anchors": anchors,
        "blockSize": blockSize,
        "numBoxesPerBlock": numBoxesPerBlock,
        "asynch": asynch,
      },
    );
  }

  /// 对二进制数据运行目标检测模型
  /// 
  /// [binary] - 图像的二进制数据（Uint8List）
  /// [model] - 模型类型，"SSDMobileNet" 或 "YOLO"
  /// [threshold] - 置信度阈值，默认为 0.1
  /// [numResultsPerClass] - 每个类别返回的最大结果数，默认为 5
  /// [anchors] - 锚框数组（仅用于 YOLO）
  /// [blockSize] - 块大小（仅用于 YOLO），默认为 32
  /// [numBoxesPerBlock] - 每个块的边界框数量（仅用于 YOLO），默认为 5
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：检测结果列表
  static Future<List?> detectObjectOnBinary({
    required Uint8List binary,
    String model = "SSDMobileNet",
    double threshold = 0.1,
    int numResultsPerClass = 5,
    List anchors = anchors,
    int blockSize = 32,
    int numBoxesPerBlock = 5,
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'detectObjectOnBinary',
      {
        "binary": binary,
        "model": model,
        "threshold": threshold,
        "numResultsPerClass": numResultsPerClass,
        "anchors": anchors,
        "blockSize": blockSize,
        "numBoxesPerBlock": numBoxesPerBlock,
        "asynch": asynch,
      },
    );
  }

  /// 对视频帧运行目标检测模型（用于实时检测）
  /// 
  /// [bytesList] - 图像平面数据列表（来自 CameraImage）
  /// [model] - 模型类型，"SSDMobileNet" 或 "YOLO"
  /// [imageHeight] - 图像高度，默认为 1280
  /// [imageWidth] - 图像宽度，默认为 720
  /// [imageMean] - 图像归一化均值，默认为 127.5
  /// [imageStd] - 图像归一化标准差，默认为 127.5
  /// [threshold] - 置信度阈值，默认为 0.1
  /// [numResultsPerClass] - 每个类别返回的最大结果数，默认为 5
  /// [rotation] - 图像旋转角度（仅 Android），默认为 90 度
  /// [anchors] - 锚框数组（仅用于 YOLO）
  /// [blockSize] - 块大小（仅用于 YOLO），默认为 32
  /// [numBoxesPerBlock] - 每个块的边界框数量（仅用于 YOLO），默认为 5
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：检测结果列表
  static Future<List?> detectObjectOnFrame({
    required List<Uint8List> bytesList,
    String model = "SSDMobileNet",
    int imageHeight = 1280,
    int imageWidth = 720,
    double imageMean = 127.5,
    double imageStd = 127.5,
    double threshold = 0.1,
    int numResultsPerClass = 5,
    int rotation = 90,
    List anchors = anchors,
    int blockSize = 32,
    int numBoxesPerBlock = 5,
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'detectObjectOnFrame',
      {
        "bytesList": bytesList,
        "model": model,
        "imageHeight": imageHeight,
        "imageWidth": imageWidth,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "rotation": rotation,
        "threshold": threshold,
        "numResultsPerClass": numResultsPerClass,
        "anchors": anchors,
        "blockSize": blockSize,
        "numBoxesPerBlock": numBoxesPerBlock,
        "asynch": asynch,
      },
    );
  }

  /// 关闭模型并释放资源
  /// 
  /// 应在不再需要使用模型时调用，以释放内存和其他资源
  static Future close() async {
    return await _channel.invokeMethod('close');
  }

  /// 对图像文件运行 Pix2Pix 模型（图像到图像转换）
  /// 
  /// [path] - 图像文件路径
  /// [imageMean] - 图像归一化均值，默认为 0
  /// [imageStd] - 图像归一化标准差，默认为 255.0
  /// [outputType] - 输出类型，默认为 "png"
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：转换后的图像数据（Uint8List）
  static Future<Uint8List?> runPix2PixOnImage({
    required String path,
    double imageMean = 0,
    double imageStd = 255.0,
    String outputType = "png",
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runPix2PixOnImage',
      {
        "path": path,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "asynch": asynch,
        "outputType": outputType,
      },
    );
  }

  /// 对二进制数据运行 Pix2Pix 模型
  /// 
  /// [binary] - 图像的二进制数据（Uint8List）
  /// [outputType] - 输出类型，默认为 "png"
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：转换后的图像数据
  static Future<Uint8List?> runPix2PixOnBinary({
    required Uint8List binary,
    String outputType = "png",
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runPix2PixOnBinary',
      {
        "binary": binary,
        "asynch": asynch,
        "outputType": outputType,
      },
    );
  }

  /// 对视频帧运行 Pix2Pix 模型（用于实时转换）
  /// 
  /// [bytesList] - 图像平面数据列表（来自 CameraImage）
  /// [imageHeight] - 图像高度，默认为 1280
  /// [imageWidth] - 图像宽度，默认为 720
  /// [imageMean] - 图像归一化均值，默认为 0
  /// [imageStd] - 图像归一化标准差，默认为 255.0
  /// [rotation] - 图像旋转角度（仅 Android），默认为 90 度
  /// [outputType] - 输出类型，默认为 "png"
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：转换后的图像数据
  static Future<Uint8List?> runPix2PixOnFrame({
    required List<Uint8List> bytesList,
    int imageHeight = 1280,
    int imageWidth = 720,
    double imageMean = 0,
    double imageStd = 255.0,
    int rotation = 90,
    String outputType = "png",
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runPix2PixOnFrame',
      {
        "bytesList": bytesList,
        "imageHeight": imageHeight,
        "imageWidth": imageWidth,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "rotation": rotation,
        "asynch": asynch,
        "outputType": outputType,
      },
    );
  }

  /// Pascal VOC 数据集的标签颜色
  /// 用于语义分割任务中为不同类别分配颜色
  /// 包含 21 个类别：背景、飞机、自行车、鸟、船、瓶子、公共汽车、汽车、
  /// 猫、椅子、牛、餐桌、狗、马、摩托车、人、盆栽植物、羊、沙发、火车、电视/显示器
  static List<int> pascalVOCLabelColors = [
    Color.fromARGB(255, 0, 0, 0).value,       // 背景
    Color.fromARGB(255, 128, 0, 0).value,     // 飞机
    Color.fromARGB(255, 0, 128, 0).value,     // 自行车
    Color.fromARGB(255, 128, 128, 0).value,   // 鸟
    Color.fromARGB(255, 0, 0, 128).value,     // 船
    Color.fromARGB(255, 128, 0, 128).value,   // 瓶子
    Color.fromARGB(255, 0, 128, 128).value,   // 公共汽车
    Color.fromARGB(255, 128, 128, 128).value, // 汽车
    Color.fromARGB(255, 64, 0, 0).value,      // 猫
    Color.fromARGB(255, 192, 0, 0).value,     // 椅子
    Color.fromARGB(255, 64, 128, 0).value,    // 牛
    Color.fromARGB(255, 192, 128, 0).value,   // 餐桌
    Color.fromARGB(255, 64, 0, 128).value,    // 狗
    Color.fromARGB(255, 192, 0, 128).value,   // 马
    Color.fromARGB(255, 64, 128, 128).value,  // 摩托车
    Color.fromARGB(255, 192, 128, 128).value, // 人
    Color.fromARGB(255, 0, 64, 0).value,      // 盆栽植物
    Color.fromARGB(255, 128, 64, 0).value,    // 羊
    Color.fromARGB(255, 0, 192, 0).value,     // 沙发
    Color.fromARGB(255, 128, 192, 0).value,   // 火车
    Color.fromARGB(255, 0, 64, 128).value,    // 电视/显示器
  ];

  /// 对图像文件运行语义分割模型（Deeplab）
  /// 
  /// [path] - 图像文件路径
  /// [imageMean] - 图像归一化均值，默认为 0
  /// [imageStd] - 图像归一化标准差，默认为 255.0
  /// [labelColors] - 标签颜色数组，默认使用 pascalVOCLabelColors
  /// [outputType] - 输出类型，默认为 "png"
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：分割结果图像数据（Uint8List）
  static Future<Uint8List?> runSegmentationOnImage({
    required String path,
    double imageMean = 0,
    double imageStd = 255.0,
    List<int>? labelColors,
    String outputType = "png",
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runSegmentationOnImage',
      {
        "path": path,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "labelColors": labelColors ?? pascalVOCLabelColors,
        "outputType": outputType,
        "asynch": asynch,
      },
    );
  }

  /// 对二进制数据运行语义分割模型
  /// 
  /// [binary] - 图像的二进制数据（Uint8List）
  /// [labelColors] - 标签颜色数组，默认使用 pascalVOCLabelColors
  /// [outputType] - 输出类型，默认为 "png"
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：分割结果图像数据
  static Future<Uint8List?> runSegmentationOnBinary({
    required Uint8List binary,
    List<int>? labelColors,
    String outputType = "png",
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runSegmentationOnBinary',
      {
        "binary": binary,
        "labelColors": labelColors ?? pascalVOCLabelColors,
        "outputType": outputType,
        "asynch": asynch,
      },
    );
  }

  /// 对视频帧运行语义分割模型（用于实时分割）
  /// 
  /// [bytesList] - 图像平面数据列表（来自 CameraImage）
  /// [imageHeight] - 图像高度，默认为 1280
  /// [imageWidth] - 图像宽度，默认为 720
  /// [imageMean] - 图像归一化均值，默认为 0
  /// [imageStd] - 图像归一化标准差，默认为 255.0
  /// [rotation] - 图像旋转角度（仅 Android），默认为 90 度
  /// [labelColors] - 标签颜色数组，默认使用 pascalVOCLabelColors
  /// [outputType] - 输出类型，默认为 "png"
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：分割结果图像数据
  static Future<Uint8List?> runSegmentationOnFrame({
    required List<Uint8List> bytesList,
    int imageHeight = 1280,
    int imageWidth = 720,
    double imageMean = 0,
    double imageStd = 255.0,
    int rotation = 90,
    List<int>? labelColors,
    String outputType = "png",
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runSegmentationOnFrame',
      {
        "bytesList": bytesList,
        "imageHeight": imageHeight,
        "imageWidth": imageWidth,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "rotation": rotation,
        "labelColors": labelColors ?? pascalVOCLabelColors,
        "outputType": outputType,
        "asynch": asynch,
      },
    );
  }

  /// 对图像文件运行 PoseNet 模型（姿态估计）
  /// 
  /// [path] - 图像文件路径
  /// [imageMean] - 图像归一化均值，默认为 127.5
  /// [imageStd] - 图像归一化标准差，默认为 127.5
  /// [numResults] - 返回的最大姿态数量，默认为 5
  /// [threshold] - 关键点置信度阈值，默认为 0.5
  /// [nmsRadius] - 非极大值抑制半径，默认为 20
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：姿态列表，每个姿态包含 score 和 keypoints（关键点）
  /// keypoints 包含身体各部位的坐标和置信度
  static Future<List?> runPoseNetOnImage({
    required String path,
    double imageMean = 127.5,
    double imageStd = 127.5,
    int numResults = 5,
    double threshold = 0.5,
    int nmsRadius = 20,
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runPoseNetOnImage',
      {
        "path": path,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "numResults": numResults,
        "threshold": threshold,
        "nmsRadius": nmsRadius,
        "asynch": asynch,
      },
    );
  }

  /// 对二进制数据运行 PoseNet 模型
  /// 
  /// [binary] - 图像的二进制数据（Uint8List）
  /// [numResults] - 返回的最大姿态数量，默认为 5
  /// [threshold] - 关键点置信度阈值，默认为 0.5
  /// [nmsRadius] - 非极大值抑制半径，默认为 20
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：姿态列表
  static Future<List?> runPoseNetOnBinary({
    required Uint8List binary,
    int numResults = 5,
    double threshold = 0.5,
    int nmsRadius = 20,
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runPoseNetOnBinary',
      {
        "binary": binary,
        "numResults": numResults,
        "threshold": threshold,
        "nmsRadius": nmsRadius,
        "asynch": asynch,
      },
    );
  }

  /// 对视频帧运行 PoseNet 模型（用于实时姿态估计）
  /// 
  /// [bytesList] - 图像平面数据列表（来自 CameraImage）
  /// [imageHeight] - 图像高度，默认为 1280
  /// [imageWidth] - 图像宽度，默认为 720
  /// [imageMean] - 图像归一化均值，默认为 127.5
  /// [imageStd] - 图像归一化标准差，默认为 127.5
  /// [rotation] - 图像旋转角度（仅 Android），默认为 90 度
  /// [numResults] - 返回的最大姿态数量，默认为 5
  /// [threshold] - 关键点置信度阈值，默认为 0.5
  /// [nmsRadius] - 非极大值抑制半径，默认为 20
  /// [asynch] - 是否异步执行，默认为 true
  /// 
  /// 返回：姿态列表
  static Future<List?> runPoseNetOnFrame({
    required List<Uint8List> bytesList,
    int imageHeight = 1280,
    int imageWidth = 720,
    double imageMean = 127.5,
    double imageStd = 127.5,
    int rotation = 90,
    int numResults = 5,
    double threshold = 0.5,
    int nmsRadius = 20,
    bool asynch = true,
  }) async {
    return await _channel.invokeMethod(
      'runPoseNetOnFrame',
      {
        "bytesList": bytesList,
        "imageHeight": imageHeight,
        "imageWidth": imageWidth,
        "imageMean": imageMean,
        "imageStd": imageStd,
        "rotation": rotation,
        "numResults": numResults,
        "threshold": threshold,
        "nmsRadius": nmsRadius,
        "asynch": asynch,
      },
    );
  }
}
