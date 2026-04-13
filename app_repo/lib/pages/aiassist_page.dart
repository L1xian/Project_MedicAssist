import 'dart:async';
import 'dart:math' as math;
import 'package:blog_app/theme/app_pallete.dart';
import 'package:blog_app/core/utils/settings_menu.dart';
import 'package:flutter/material.dart';
// Removed CustomAppBar import as it's no longer needed here

class AiAssistPage extends StatefulWidget {
  const AiAssistPage({super.key});

  @override
  State<AiAssistPage> createState() => _AiAssistPageState();
}

class _AiAssistPageState extends State<AiAssistPage> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _startGreeting();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _startGreeting() async {
    setState(() => _isTyping = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add({
          'text': "Hey there!\n How can I help you today?",
          'isBot': true,
        });
      });
      _scrollToBottom();
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isNotEmpty) {
      final userText = _controller.text.trim();
      setState(() {
        _messages.add({
          'text': userText,
          'isBot': false,
        });
        _controller.clear();
        _isTyping = true;
      });
      _scrollToBottom();

      // Simulate AI thinking and response
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            'text': "This is a simulated AI response to: \"$userText\"",
            'isBot': true,
          });
        });
        _scrollToBottom();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor; // No longer needed here

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Removed AppBar as it will be displayed as a modal
      body: SafeArea(
        child: Column(
          children: [
            // Add a custom close button or handle back navigation for the modal
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 12),
                        itemCount: _messages.length + (_isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _messages.length && _isTyping) {
                            return const Padding(
                              padding: EdgeInsets.only(bottom: 12.0),
                              child: _TypingIndicator(),
                            );
                          }
                          final message = _messages[index];
                          if (message['isBot']) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _BotMessage(text: message['text']),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: _UserMessage(text: message['text']),
                            );
                          }
                        },
                      ),
                    ),
                    _InputBar(
                      controller: _controller,
                      onSend: _sendMessage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  const _TypingIndicator();

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppPallete.surfaceColor : AppPallete.whiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppPallete.borderColor.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final double delay = index * 0.2;
                final double val = math.sin((_controller.value * 2 * math.pi) - delay);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                    color: (isDark ? AppPallete.whiteColor : AppPallete.backgroundColor).withOpacity(0.3 + (val + 1) / 4),
                    shape: BoxShape.circle,
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

class _BotMessage extends StatelessWidget {
  const _BotMessage({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppPallete.surfaceColor : AppPallete.whiteColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppPallete.borderColor.withOpacity(0.5)),
        ),
        child: Text(
          text,
          style: TextStyle(color: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor, fontSize: 14, height: 1.4),
        ),
      ),
    );
  }
}

class _UserMessage extends StatelessWidget {
  const _UserMessage({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppPallete.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppPallete.primaryColor.withOpacity(0.5)),
        ),
        child: Text(
          text,
          style: TextStyle(color: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor, fontSize: 14, height: 1.4),
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _InputBar({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppPallete.surfaceColor : AppPallete.whiteColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppPallete.borderColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: isDark ? AppPallete.whiteColor : AppPallete.backgroundColor),
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Ask me anything...',
                hintStyle: TextStyle(color: AppPallete.greyColor),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 7 ),
              ),
            ),
          ),
          IconButton(
            onPressed: onSend,
            icon: const Icon(Icons.send_rounded),
            color: AppPallete.primaryColor,
          ),
        ],
      ),
    );
  }
}