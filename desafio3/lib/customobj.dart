import 'dart:convert';

class CustomObj {
  int id;
  String sigla;
  String nome;
  CustomObj(
    this.id,
    this.sigla,
    this.nome,
  );

  // @override
  // List<Object> get props => [id];

  CustomObj copyWith({
    int id,
    String sigla,
    String nome,
  }) {
    return CustomObj(
      id ?? this.id,
      sigla ?? this.sigla,
      nome ?? this.nome,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sigla': sigla,
      'nome': nome,
    };
  }

  static CustomObj fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CustomObj(
      map['id'],
      map['sigla'],
      map['nome'],
    );
  }

  String toJson() => json.encode(toMap());

  static CustomObj fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() => 'CustomObj(id: $id, sigla: $sigla, nome: $nome)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is CustomObj && o.id == id && o.sigla == sigla && o.nome == nome;
  }

  @override
  int get hashCode => id.hashCode ^ sigla.hashCode ^ nome.hashCode;
}