import 'dart:io';

import 'package:ffi_playground/ffi/ffi_bridge.dart';
import 'package:ffi_playground/pages/ai_chat/ai_chat_page.dart';
import 'package:flutter/material.dart';

class FfiHomePage extends StatefulWidget {
  const FfiHomePage({super.key});

  @override
  State<FfiHomePage> createState() => _FfiHomePageState();
}

class _FfiHomePageState extends State<FfiHomePage> {
  double brightness = 1.0;

  @override
  void initState() {
    super.initState();
    brightness = FFIBridge.getBrightness();
  }

  void _onBrightnessChanged(double value) {
    setState(() => brightness = value);
    FFIBridge.setBrightness(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FFI Playground')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '🔋 Battery: ${(FFIBridge.getBatteryLevel() * 100).toStringAsFixed(0)}%',
                ),
                Text('📱 Platform: ${FFIBridge.getPlatformName()}'),
                Text('🕒 Time: ${FFIBridge.getCurrentTime()}'),
                Text('📱 Device: ${FFIBridge.getDeviceName()}'),
                Text('🌍 Locale: ${FFIBridge.getLocale()}'),
          
                Text(
                  'Current brightness: ${(brightness * 100).toStringAsFixed(0)}%',
                ),
                Slider(
                  value: brightness,
                  min: 0.0,
                  max: 1.0,
                  divisions: 20,
                  label: '${(brightness * 100).toStringAsFixed(0)}%',
                  onChanged: _onBrightnessChanged,
                ),
                ElevatedButton(
                  onPressed: FFIBridge.playSystemSound,
                  child: const Text('🔊 Play System Sound'),
                ),
                if (Platform.isIOS)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => const AiChatPage(),
                    ));
                  },
                  child: const Text('🔊 Go to AI Chat'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
