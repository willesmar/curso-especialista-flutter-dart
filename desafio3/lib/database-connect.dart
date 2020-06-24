import 'package:mysql1/mysql1.dart';

class MysqlConnect {
  static final _settings = ConnectionSettings(
      host: 'localhost', port: 3306, user: 'root', password: 'root', db: 'desafiodb');

  static Future<MySqlConnection> get getConnection async {
    return await MySqlConnection.connect(_settings);
  }
}
