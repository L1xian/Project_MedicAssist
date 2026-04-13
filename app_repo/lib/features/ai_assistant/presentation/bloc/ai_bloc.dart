import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blog_app/features/ai_assistant/data/send_message.dart';
import 'package:blog_app/features/ai_assistant/data/message.dart';
import 'package:uuid/uuid.dart';

// Events
abstract class AiEvent {}
class SendMessageEvent extends AiEvent {
  final String message;
  SendMessageEvent(this.message);
}

// States
abstract class AiState {
  final List<Message> messages;
  const AiState(this.messages);
}
class AiInitial extends AiState {
  const AiInitial() : super(const []);
}
class AiLoading extends AiState {
  const AiLoading(super.messages);
}
class AiLoaded extends AiState {
  const AiLoaded(super.messages);
}
class AiError extends AiState {
  final String error;
  const AiError(super.messages, this.error);
}

class AiBloc extends Bloc<AiEvent, AiState> {
  final SendMessage sendMessage;
  final Uuid uuid = const Uuid();

  AiBloc(this.sendMessage) : super(const AiInitial()) {
    on<SendMessageEvent>((event, emit) async {
      // Add user message immediately
      final userMessage = Message(
        id: uuid.v4(),
        text: event.message,
        isUser: true,
      );
      final updatedMessages = List<Message>.from(state.messages)..add(userMessage);
      emit(AiLoading(updatedMessages));

      try {
        final aiResponse = await sendMessage(event.message);
        final aiMessage = Message(
          id: uuid.v4(),
          text: aiResponse,
          isUser: false,
        );
        final finalMessages = List<Message>.from(updatedMessages)..add(aiMessage);
        emit(AiLoaded(finalMessages));
      } catch (e) {
        emit(AiError(updatedMessages, e.toString()));
      }
    });
  }
}
