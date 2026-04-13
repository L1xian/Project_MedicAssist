import 'ai_repository.dart';
import 'ai_remote_data_source.dart';

class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource remoteDataSource;

  AiRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> sendMessage(String message) async {
    return await remoteDataSource.sendMessage(message);
  }
}
