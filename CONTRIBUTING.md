# 为 TFLite Flutter 插件做贡献

感谢您对贡献的兴趣！本文档提供了为项目做贡献的指南。

## 开始

1. Fork 仓库
2. 克隆您的 fork：`git clone https://github.com/your-username/flutter_tflite.git`
3. 创建功能分支：`git checkout -b feature/your-feature-name`
4. 进行更改
5. 彻底测试您的更改
6. 使用清晰的消息提交
7. 推送到您的 fork：`git push origin feature/your-feature-name`
8. 打开 Pull Request

## 开发环境设置

### 前提条件
- Flutter SDK（最新稳定版本）
- Android Studio / Xcode 用于平台特定开发
- Git

### 构建插件

```bash
# 获取依赖
flutter pub get

# 运行测试
flutter test

# 分析代码
flutter analyze
```

## 代码规范

### Dart 代码
- 遵循 [Dart 代码风格指南](https://dart.dev/guides/language/effective-dart/style)
- 使用有意义的变量和函数名
- 为公共 API 添加文档注释
- 保持函数专注和简洁

### 平台代码

**Android (Java)**
- 遵循 Java 代码规范
- 优雅地处理错误
- 适当使用异步操作

**iOS (Objective-C++)**
- 遵循 Objective-C 规范
- 正确管理内存
- 在多个 iOS 版本上测试

## 测试

- 为新功能编写单元测试
- 在 Android 和 iOS 上测试
- 使用不同的模型类型测试
- 验证 GPU 加速功能
- 测试边缘情况和错误处理

## 文档

- 为新功能更新 README.md
- 为复杂功能添加示例
- 在 CHANGELOG.md 中更新您的更改
- 清楚地记录破坏性更改

## Pull Request 流程

1. 确保所有测试通过
2. 更新文档
3. 在 CHANGELOG.md 中添加条目
4. 提供清晰的 PR 描述
5. 链接相关问题
6. 等待审查

## 报告问题

报告错误时，请包括：
- Flutter 版本
- 平台（Android/iOS）
- 设备信息
- 重现步骤
- 预期与实际行为
- 错误消息/堆栈跟踪

## 功能请求

对于功能请求，请提供：
- 清晰的用例描述
- 预期行为
- 考虑过的替代方案
- 愿意贡献

## 代码审查

- 保持尊重和建设性
- 关注代码质量
- 提出改进建议
- 在批准前彻底测试

## 许可证

通过贡献，您同意您的贡献将在 MIT 许可证下授权。

## 有疑问？

请随时提出问题或加入讨论。

感谢您的贡献！🎉
