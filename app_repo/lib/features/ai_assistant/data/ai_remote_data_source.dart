import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blog_app/core/constants/db_linkup.dart';

abstract class AiRemoteDataSource {
  Future<String> sendMessage(String message);
}

class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  @override
  Future<String> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${AppSecrets.openAiApiKey}',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        'messages': [
          {'role': 'system', 'content': 'You are a helpful medical assistant.'},
          {'role': 'user', 'content': message}
        ],
        'max_tokens': 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get AI response: ${response.body}');
    }
  }
}
