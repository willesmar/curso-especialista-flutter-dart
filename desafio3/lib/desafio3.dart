import 'package:desafio3/cidade.dart';
import 'package:desafio3/customobj.dart';
import 'package:desafio3/estado.dart';
import 'package:dio/dio.dart';

import 'package:desafio3/database-connect.dart';

final baseURL = 'https://servicodados.ibge.gov.br/api/v1/localidades/estados';
Response response;
Dio dio = Dio();
Set<Estado> estadosSet = <Estado>{};
List<Object> estadosList = [];
Set<CustomObj> regioesSet = <CustomObj>{};
var regioesList = [];
Set<Cidade> cidadesSet = <Cidade>{};
List<Object> cidadesList = [];

void run() {
  executar();
}

Future<void> executar() async {
  await dropTables();
  await createTables();

  var pais = [55, 'BR', 'Brasil'];
  await salvarPais(values: [pais]);

  var estadosResponse = await getEstados();

  estadosResponse.forEach((estado) async {
    var regiaoObj = CustomObj.fromMap(estado['regiao']);
    var estadoObj = Estado(
        id: estado['id'],
        sigla: estado['sigla'],
        nome: estado['nome'],
        regiaoId: regiaoObj.id,
        paisId: 55);

    estadosSet.add(estadoObj);
    estadosList.add([
      estadoObj.id,
      estadoObj.sigla,
      estadoObj.nome,
      estadoObj.regiaoId,
      estadoObj.paisId
    ]);

    if (!regioesSet.contains(regiaoObj)) {
      regioesSet.add(regiaoObj);
      regioesList.add([regiaoObj.id, regiaoObj.sigla, regiaoObj.nome]);
    }
  });

  estadosSet.forEach((estado) async {
    var cidadesResponse = await getCidades(estado.id);
    cidadesResponse.forEach((cidade) {
      var cidadeObj = Cidade(
          id: cidade['municipio']['id'],
          nome: cidade['municipio']['nome'],
          estadoId: estado.id);

      if (!cidadesSet.contains(cidadeObj)) {
        cidadesSet.add(cidadeObj);
        cidadesList.add([cidadeObj.id, cidadeObj.nome, cidadeObj.estadoId]);
      }
    });
  });

  print(regioesList.length);
  await salvarRegiao(values: regioesList);

  print(estadosList.length);
  await salvarEstados(values: estadosList);

  print(cidadesList.length);
  await salvarCidades(values: cidadesList);
}

Future getEstados() async {
  try {
    response = await dio.get(baseURL);
    return response.data;
  } on DioError catch (e) {
    print(e);
  }
}

Future getCidades(int ufId) async {
  try {
    response = await dio.get('$baseURL/$ufId/distritos');
    return response.data;
  } on DioError catch (e) {
    print(e);
  }
}

Future salvarPais({List<dynamic> values}) async {
  var SQL_SAVE = '''
    INSERT INTO pais (id, sigla, nome) VALUES (?,?,?)
  ''';

  if (values != null) {
    for (var val in values) {
      await saveToDB(SQL_SAVE, val);
    }
  }
  return;
}

Future salvarRegiao({List<dynamic> values}) async {
  var SQL_SAVE = '''
    INSERT INTO regiao (id, sigla, nome) VALUES (?,?,?)
  ''';

  if (values != null) {
    for (var val in values) {
      await saveToDB(SQL_SAVE, val);
    }
  }
  return;
}

Future salvarEstados({List<dynamic> values}) async {
  var SQL_SAVE = '''
    INSERT INTO estados (id, sigla, nome, regiaoId, paisId) VALUES (?,?,?,?,?)
  ''';

  if (values != null) {
    for (var val in values) {
      await saveToDB(SQL_SAVE, val);
    }
  }
  return;
}

Future salvarCidades({List<dynamic> values}) async {
  var SQL_SAVE = '''
    INSERT INTO cidades (id, nome, estadoId) VALUES (?,?,?)
  ''';

  if (values != null) {
    for (var val in values) {
      await saveToDB(SQL_SAVE, val);
    }
  }
  return;
}

Future saveToDB(String SQL, List<dynamic> value) async {
  var conn = await MysqlConnect.getConnection;
  print(value);
  var resultInsert = await conn.query(SQL, value);
  print(resultInsert.affectedRows);
  await conn.close();
  return;
}

void createTables() async {
  await createPaisTable();
  await createRegiaoTable();
  await createEstadosTable();
  await createCidadesTable();
}

void createPaisTable() async {
  var conn = await MysqlConnect.getConnection;
  try {
    var SQL_CREATE = '''CREATE TABLE IF NOT EXISTS pais (
    id INT NOT NULL PRIMARY KEY,
    sigla VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL
  )  ENGINE=INNODB''';
    var resultCreate = await conn.query(SQL_CREATE);
    print(resultCreate.affectedRows);
    print('Tabela pais criada com sucesso');
    await conn.close();
  } catch (e) {
    print(e);
    await conn.close();
  }
}

void createRegiaoTable() async {
  var conn = await MysqlConnect.getConnection;
  try {
    var SQL_CREATE = '''CREATE TABLE IF NOT EXISTS regiao (
    id INT NOT NULL PRIMARY KEY,
    sigla VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL
  )  ENGINE=INNODB''';
    var resultCreate = await conn.query(SQL_CREATE);
    print(resultCreate.affectedRows);
    print('Tabela regiao criada com sucesso');
    await conn.close();
  } catch (e) {
    print(e);
    await conn.close();
  }
}

void createEstadosTable() async {
  var conn = await MysqlConnect.getConnection;
  try {
    var SQL_CREATE = '''CREATE TABLE IF NOT EXISTS estados (
    id INT NOT NULL PRIMARY KEY,
    sigla VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL,
    regiaoId INT,
    paisId INT,
    FOREIGN KEY (regiaoId) REFERENCES regiao(id),
    FOREIGN KEY (paisId) REFERENCES pais(id)
  )  ENGINE=INNODB''';
    var resultCreate = await conn.query(SQL_CREATE);
    print(resultCreate.affectedRows);
    print('Tabela estados criada com sucesso');
    await conn.close();
  } catch (e) {
    print(e);
    await conn.close();
  }
}

void createCidadesTable() async {
  var conn = await MysqlConnect.getConnection;
  try {
    var SQL_CREATE = '''CREATE TABLE IF NOT EXISTS cidades (
    id INT NOT NULL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    estadoId INT,
    FOREIGN KEY (estadoId) REFERENCES estados(id)
  )  ENGINE=INNODB''';
    var resultCreate = await conn.query(SQL_CREATE);
    print(resultCreate.affectedRows);
    print('Tabela cidades criada com sucesso');
    await conn.close();
  } catch (e) {
    print(e);
    await conn.close();
  }
}

void dropTableCidade() async {
  var conn = await MysqlConnect.getConnection;
  var SQL = 'DROP TABLE cidades';
  try {
    var result = await conn.query(SQL);
    print(result.affectedRows);
    print('Tabela cidades deletada');
    await conn.close();
  } catch (e) {
    print(e);
    await conn.close();
  }
}

void dropTableEstados() async {
  var conn = await MysqlConnect.getConnection;
  var SQL = 'DROP TABLE estados';
  try {
    var result = await conn.query(SQL);
    print(result.affectedRows);
    print('Tabela estados deletada');
    await conn.close();
  } catch (e) {
    print(e);
    await conn.close();
  }
}

void dropTableRegiao() async {
  var conn = await MysqlConnect.getConnection;
  var SQL = 'DROP TABLE regiao';
  try {
    var result = await conn.query(SQL);
    print(result.affectedRows);
    print('Tabela regiao deletada');
    await conn.close();
  } catch (e) {
    print(e);
    await conn.close();
  }
}

void dropTablePais() async {
  var conn = await MysqlConnect.getConnection;
  var SQL = 'DROP TABLE pais';
  try {
    var result = await conn.query(SQL);
    print(result.affectedRows);
    print('Tabela pais deletada');
    await conn.close();
  } catch (e) {
    print(e);
    await conn.close();
  }
}

void dropTables() async {
  await dropTableCidade();
  await dropTableEstados();
  await dropTableRegiao();
  await dropTablePais();
}
