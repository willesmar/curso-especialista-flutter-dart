void main(List<String> args) {
  var pacientes = [
    'Rodrigo Rahman|35|desenvolvedor|SP',
    'Manoel Silva|12|estudante|MG',
    'Joaquim Rahman|18|estudante|SP',
    'Fernando Verne|35|estudante|MG',
    'Gustavo Silva|40|estudante|MG',
    'Sandra Silva|40|estudante|MG',
    'Regina Verne|35|estudante|MG',
    'João Rahman|55|Jornalista|SP',
  ];

  // Baseado no array acima monte um relatório onde mostre
  // Apresente a quantidade de pacientes com mais de 20 anos
  // Agrupar os pacientes por familia(considerar o sobrenome) apresentar por familia.

  var quantidadePacientesMais20Anos = 0;
  Map<String, List<String>> familias = {};
  pacientes.forEach((item) {
    List<String> valores = item.split('|');
    var nome_sobrenome = valores[0].split(' ');
    if (familias.length == 0 || familias[nome_sobrenome[1]] == null) {
      familias[nome_sobrenome[1]] = [];
    }
    familias[nome_sobrenome[1]].add(nome_sobrenome[0]);

    if (num.tryParse(valores[1]) > 20) {
      quantidadePacientesMais20Anos++;
    }
  });

  print('\n');
  print(
      'Total de pacientes com mais de 20 anos: $quantidadePacientesMais20Anos');
  print('\n');
  familias.forEach((key, value) {
    print('Família $key:');
    for (var integrante in value) {
      print('\t $integrante');
    }
    print('\n');
  });
}
