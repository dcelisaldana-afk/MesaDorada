/// Formatea valores en pesos colombianos sin decimales: 45900 -> "$45.900".
String formatoPesos(int valor) {
  final negativo = valor < 0;
  final digitos = valor.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digitos.length; i++) {
    final restantes = digitos.length - i;
    buffer.write(digitos[i]);
    if (restantes > 1 && restantes % 3 == 1) buffer.write('.');
  }
  return '${negativo ? '-' : ''}\$${buffer.toString()}';
}
