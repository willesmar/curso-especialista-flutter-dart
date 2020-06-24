import 'package:equatable/equatable.dart';

class Cidade extends Equatable {
  int id;
  String nome;
  int estadoId;

  Cidade({
    this.id,
    this.nome,
    this.estadoId,
  });

    static Cidade fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Cidade(
      id: map['id'],
      nome: map['nome'],
      estadoId: map['estadoId'],
    );
  }

  @override
  List<Object> get props => [id, estadoId];
}
