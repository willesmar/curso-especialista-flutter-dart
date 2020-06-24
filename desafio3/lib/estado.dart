import 'package:equatable/equatable.dart';

class Estado extends Equatable {
  int id;
  String sigla;
  String nome;
  int regiaoId;
  int paisId;

  Estado({
    this.id,
    this.sigla,
    this.nome,
    this.regiaoId,
    this.paisId,
  });

    static Estado fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Estado(
      id: map['id'],
      sigla: map['sigla'],
      nome: map['nome'],
      regiaoId: map['regiaoId'],
      paisId: map['paisId']
    );
  }

  @override
  List<Object> get props => [id];
}
