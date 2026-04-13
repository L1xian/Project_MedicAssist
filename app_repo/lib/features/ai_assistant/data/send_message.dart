import 'ai_repository.dart';

class SendMessage {
  final AiRepository repository;

  SendMessage(this.repository);

  Future<String> call(String message) async {
    return await repository.sendMessage(message);
  }
}
