import 'package:flutter/material.dart';
import '../ffi/ai_bridge.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _controller = TextEditingController();
  final _messages = <_Message>[];
  bool _isLoading = false;
  bool? _modelAvailable;

  @override
  void initState() {
    super.initState();
    AiBridge.init();
    _checkModelAvailability();
  }

  void _checkModelAvailability() {
    setState(() {
      _modelAvailable = AiBridge.isModelAvailable();
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_Message(text, isUser: true));
      _isLoading = true;
    });
    _controller.clear();

    await Future.delayed(const Duration(milliseconds: 150)); // smooth UI
    final reply = AiBridge.generate(text);

    setState(() {
      _messages.add(_Message(reply, isUser: false));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_modelAvailable == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_modelAvailable == false) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('AI Chat (Apple Intelligence)'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              spacing: 16,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.info_outline,
                  size: 64,
                  color: Colors.blueAccent,
                ),

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
                  onPressed: _checkModelAvailability,
                  icon: Icon(Icons.refresh, color: Colors.blueAccent),
                  label: const Text(
                    'Check Again',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
      
        appBar: AppBar(
          title: const Text('AI Chat (Apple Intelligence)'),
          centerTitle: true,
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        itemCount: _messages.length,
                        itemBuilder: (_, i) {
                          final msg = _messages[_messages.length - 1 - i];
                          return Align(
                            alignment: msg.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: msg.isUser
                                    ? Colors.blueAccent
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: msg.isUser
                                      ? const Radius.circular(16)
                                      : Radius.zero,
                                  bottomRight: msg.isUser
                                      ? Radius.zero
                                      : const Radius.circular(16),
                                ),
                              ),
                              child: Text(
                                msg.text,
                                style: TextStyle(
                                  color: msg.isUser
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: ThemeData.dark().textTheme.bodyMedium
                                  ?.copyWith(color: Colors.white54),
                              filled: true,
                              fillColor: Colors.blue.withOpacity(0.1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (_) => _send(),
                          ),
                        ),
                      
                        IconButton(
                          icon: const Icon(Icons.send_rounded),
                          color: Colors.blueAccent,
                          onPressed: _isLoading ? null : _send,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            if (_isLoading)
              Container(
                padding: const EdgeInsets.only(bottom: kToolbarHeight),
                alignment: Alignment.center,
                color: Colors.black.withOpacity(0.5),
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                  backgroundColor: Colors.blueAccent.withOpacity(0.3),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;
  _Message(this.text, {required this.isUser});
}
