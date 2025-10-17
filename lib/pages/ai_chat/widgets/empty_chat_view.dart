import 'package:flutter/material.dart';

class EmptyChatView extends StatelessWidget {
  const EmptyChatView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, size: 80, color: Colors.blue.shade300),
            const SizedBox(height: 20),
            const Text(
              'Start a conversation with Apple Intelligence',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Ask anything — from creative writing to productivity tips.\n'
              'Your device will respond privately and intelligently.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
