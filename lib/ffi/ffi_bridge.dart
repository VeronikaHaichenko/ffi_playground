import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';

typedef _GetBatteryLevelNative = ffi.Float Function();
typedef _GetPlatformNameNative = ffi.Pointer<Utf8> Function();
typedef _GetDeviceNameNative = ffi.Pointer<Utf8> Function();
typedef _GetLocaleNative = ffi.Pointer<Utf8> Function();
typedef _GetCurrentTimeNative = ffi.Pointer<Utf8> Function();
typedef _PlaySystemSoundNative = ffi.Void Function();
typedef _SetBrightnessNative = ffi.Void Function(ffi.Float);
typedef _GetBrightnessNative = ffi.Float Function();

class FFIBridge {
  static late final ffi.DynamicLibrary _lib;

  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isAndroid) {
      _lib = ffi.DynamicLibrary.open('libnative_bridge.so');
    } else if (Platform.isIOS) {
      _lib = ffi.DynamicLibrary.process();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
    await Future.delayed(const Duration(milliseconds: 100));
    debugPrint('✅ FFI library initialized and waiting done');
  }

  static String getDeviceName() {
    final ptr = _lib
        .lookupFunction<
          _GetDeviceNameNative,
          ffi.Pointer<Utf8> Function()
        >('getDeviceName')();
    return ptr.cast<Utf8>().toDartString();
  }

  static String getLocale() {
    final ptr = _lib
        .lookupFunction<_GetLocaleNative, ffi.Pointer<Utf8> Function()>(
          'getLocale',
        )();
    return ptr.cast<Utf8>().toDartString();
  }

  static double getBatteryLevel() =>
      _lib.lookupFunction<_GetBatteryLevelNative, double Function()>(
        'getBatteryLevel',
      )();

  static String getPlatformName() {
    final ptr = _lib
        .lookupFunction<
          _GetPlatformNameNative,
          ffi.Pointer<Utf8> Function()
        >('getPlatformName')();
    return ptr.cast<Utf8>().toDartString();
  }

  static String getCurrentTime() {
    final ptr = _lib
        .lookupFunction<
          _GetCurrentTimeNative,
          ffi.Pointer<Utf8> Function()
        >('getCurrentTime')();
    return ptr.cast<Utf8>().toDartString();
  }

  static void playSystemSound() {
    _lib.lookupFunction<_PlaySystemSoundNative, void Function()>(
      'playSystemSound',
    )();
  }

  static void setBrightness(double value) {
    _lib.lookupFunction<_SetBrightnessNative, void Function(double)>(
      'setBrightness',
    )(value);
  }

  static double getBrightness() {
    return _lib.lookupFunction<_GetBrightnessNative, double Function()>(
      'getBrightness',
    )();
  }
}
