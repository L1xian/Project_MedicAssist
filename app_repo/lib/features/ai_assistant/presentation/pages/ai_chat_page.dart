import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:scroll_to_index/scroll_to_index.dart';
import '../bloc/ai_bloc.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final List<types.Message> _chatMessages = [];
  final types.User _user = const types.User(id: 'user');
  final types.User _ai = const types.User(id: 'ai');
  final AutoScrollController _scrollController = AutoScrollController();

  void _addMessage(types.Message message) {
    setState(() {
      _chatMessages.add(message); // Append to the end for chronological order
    });
    _scrollToBottom();
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

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      text: message.text,
    );
    _addMessage(textMessage);
    context.read<AiBloc>().add(SendMessageEvent(message.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Assistant')),
      body: BlocListener<AiBloc, AiState>(
        listener: (context, state) {
          if (state is AiLoaded && state.messages.isNotEmpty) {
            final lastMessage = state.messages.last;
            if (!lastMessage.isUser) {
              final aiMessage = types.TextMessage(
                author: _ai,
                createdAt: DateTime.now().millisecondsSinceEpoch,
                id: DateTime.now().toString(),
                text: lastMessage.text,
              );
              _addMessage(aiMessage);
            }
          } else if (state is AiError) {
            // Show error as a message
            final errorMessage = types.TextMessage(
              author: _ai,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              id: DateTime.now().toString(),
              text: 'Error: ${state.error}',
            );
            _addMessage(errorMessage);
          }
        },
        child: Chat(
          messages: _chatMessages,
          onSendPressed: _handleSendPressed,
          user: _user,
          scrollController: _scrollController,
          showUserAvatars: true,
          showUserNames: true,
          theme: const DefaultChatTheme(
            inputBackgroundColor: Colors.grey,
            inputTextColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
