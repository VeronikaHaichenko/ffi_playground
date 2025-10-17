import 'package:ffi_playground/ffi_home_page.dart';
import 'package:flutter/material.dart';
import 'ffi_bridge.dart';

void main() async {
  await FFIBridge.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFI Playground',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const FfiHomePage(),
    );
  }
}
