import 'package:postgres/postgres.dart';
import 'package:flutter/foundation.dart';

class LocalDbService {
  late final Connection _connection;

  Future<void> connect() async {
    try {
      // 10.0.2.2 is the localhost address for Android Emulator
      final endpoint = Endpoint(
        host: kDebugMode ? '10.0.2.2' : 'localhost',
        database: 'postgres',
        username: 'postgres',
        password: 'postgres',
      );

      _connection = await Connection.open(endpoint);
      debugPrint('Connected to local PostgreSQL database.');
    } catch (e) {
      debugPrint('Error connecting to local database: $e');
    }
  }

  Future<Result> query(String sql, {Map<String, dynamic>? parameters}) async {
    return await _connection.execute(sql, parameters: parameters);
  }

  Future<void> close() async {
    await _connection.close();
  }
}
