main() {
  var pessoas = [
    'Rodrigo Rahman|35|Masculino',
    'Jose|56|Masculino',
    'Joaquim|84|Masculino',
    'Rodrigo Rahman|35|Masculino',
    'Maria|88|Feminino',
    'Helena|24|Feminino',
    'Leonardo|5|Masculino',
    'Laura Maria|29|Feminino',
    'Joaquim|72|Masculino',
    'Helena|24|Feminino',
    'Guilherme|15|Masculino',
    'Manuela|85|Masculino',
    'Leonardo|5|Masculino',
    'Helena|24|Feminino',
    'Laura|29|Feminino',
  ];

  // Baseado na lista acima.
  // 1 - Remover os duplicados
  // 2 - Me mostre a quantidade de pessoas do sexo Masculino e Feminino
  // 3 - Filtrar e deixar a lista somente com pessoas maiores de 18 anos
  //     e mostre a quantidade de pessoas com mais de 18 anos
  // 4 - Encontre a pessoa mais velha.

  print("\nPasso 1 - Remover registros duplicados\n");
  var uniquePersons = <String>{};
  uniquePersons.addAll(pessoas);
  print('\t$uniquePersons');

  print(
      "\nPasso 2 - Mostrar a quantidade de pessoas do sexo Masculino e Feminino\n");
  var personsMap = uniquePersons.map((person) {
    List<String> valores = person.split('|');
    return {"nome": valores[0], "idade": valores[1], "sexo": valores[2]};
  });

  int countMasculino =
      personsMap.where((element) => element["sexo"] == "Masculino").length;
  print('\t$countMasculino pessoas são do sexo Masculino.');

  int countFeminino =
      personsMap.where((element) => element["sexo"] == "Feminino").length;
  print('\t$countFeminino pessoas são do sexo Feminino.');

  print(
      '\nPasso 3.1 - Filtrar e deixar a lista somente com pessoas maiores de 18 anos\n');
  var greaterThan18 =
      personsMap.where((element) => num.tryParse(element["idade"]) > 18);
  print('\t${greaterThan18}');
  print("");
  print('\nPasso 3.2 - Mostrar a quantidade de pessoas com mais de 18 anos\n');
  print('\t${greaterThan18.length} pessoas têm mais de 18 anos.');

  print('\nPasso 4 - Encontrar a pessoa mais velha\n');
  var oldestPerson = greaterThan18.toList();
  oldestPerson.sort((a,b) => num.parse(a['idade']).compareTo(num.parse(b['idade'])));
  print(
      '\t${oldestPerson.last["nome"]} é a pessoa mais velha e tem ${oldestPerson.last["idade"]} anos.\n');

  // var idades =
  //     greaterThan18.map((person) => num.tryParse(person["idade"])).toList();
  // idades.sort((a, b) => a - b);
  // var oldestPerson = personsMap
  //     .where((element) => num.tryParse(element["idade"]) == idades.last)
  //     .toList();
  // print(
  //     '\t${oldestPerson[0]["nome"]} é a pessoa mais velha e tem ${oldestPerson[0]["idade"]} anos.\n');
}
