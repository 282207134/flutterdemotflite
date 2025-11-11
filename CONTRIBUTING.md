# Contributing to TFLite Flutter Plugin

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/flutter_tflite.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test your changes thoroughly
6. Commit with clear messages
7. Push to your fork: `git push origin feature/your-feature-name`
8. Open a Pull Request

## Development Setup

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / Xcode for platform-specific development
- Git

### Building the Plugin

```bash
# Get dependencies
flutter pub get

# Run tests
flutter test

# Analyze code
flutter analyze
```

## Code Guidelines

### Dart Code
- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Keep functions focused and concise

### Platform Code

**Android (Java)**
- Follow Java code conventions
- Handle errors gracefully
- Use async operations where appropriate

**iOS (Objective-C++)**
- Follow Objective-C conventions
- Manage memory properly
- Test on multiple iOS versions

## Testing

- Write unit tests for new features
- Test on both Android and iOS
- Test with different model types
- Verify GPU delegate functionality
- Test edge cases and error handling

## Documentation

- Update README.md for new features
- Add examples for complex functionality
- Update CHANGELOG.md with your changes
- Document breaking changes clearly

## Pull Request Process

1. Ensure all tests pass
2. Update documentation
3. Add entry to CHANGELOG.md
4. Provide clear PR description
5. Link related issues
6. Wait for review

## Reporting Issues

When reporting bugs, include:
- Flutter version
- Platform (Android/iOS)
- Device information
- Steps to reproduce
- Expected vs actual behavior
- Error messages/stack traces

## Feature Requests

For feature requests, provide:
- Clear use case description
- Expected behavior
- Alternative solutions considered
- Willingness to contribute

## Code Review

- Be respectful and constructive
- Focus on code quality
- Suggest improvements
- Test thoroughly before approving

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

## Questions?

Feel free to open an issue for questions or join discussions.

Thank you for contributing! 🎉
