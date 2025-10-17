import 'package:flutter/material.dart';

class UnavialableModelView extends StatelessWidget {
  const UnavialableModelView({super.key, required this.checkModelAvailability});

  final Function() checkModelAvailability;  

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline, size: 64, color: Colors.blueAccent),

            const Text(
              'Apple Intelligence Unavailable',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            const Text(
              'Please make sure Apple Intelligence is enabled and model assets are downloaded.\n\n'
              'Go to Settings → Siri & Spotlight → Apple Intelligence.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white38),
            ),
            const SizedBox(height: 4),
            ElevatedButton.icon(
              onPressed: checkModelAvailability,
              icon: Icon(Icons.refresh, color: Colors.blueAccent),
              label: const Text(
                'Check Again',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
