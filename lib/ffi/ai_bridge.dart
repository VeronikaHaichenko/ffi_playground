import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';
import 'dart:io';

typedef _GenerateTextC = ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>);
typedef _GenerateTextDart =
    ffi.Pointer<ffi.Char> Function(ffi.Pointer<ffi.Char>);

typedef _IsModelAvailableC = ffi.Uint8 Function();
typedef _IsModelAvailableDart = int Function();

class AiBridge {
  static late final ffi.DynamicLibrary _lib;
  static late final _IsModelAvailableDart _isModelAvailable;
  static late final _GenerateTextDart _generateText;

  static bool _initialized = false;

  static void init() {
    if (_initialized) return; // 🧱 предотвращает повторную инициализацию

    if (Platform.isIOS) {
      _lib = ffi.DynamicLibrary.process();
    } else {
      throw UnsupportedError('Apple Intelligence is only available on iOS 18+');
    }

    _isModelAvailable = _lib
        .lookupFunction<_IsModelAvailableC, _IsModelAvailableDart>(
          'isModelAvailable',
        );

    _generateText = _lib.lookupFunction<_GenerateTextC, _GenerateTextDart>(
      'generateText',
    );
    _initialized = true;
  }

  static bool isModelAvailable() => _isModelAvailable() != 0;

  static String generate(String prompt) {
    final promptPtr = prompt.toNativeUtf8();
    final resultPtr = _generateText(promptPtr.cast<ffi.Char>());
    final result = resultPtr.cast<Utf8>().toDartString();
    malloc.free(promptPtr);
    return result;
  }
}
