const _meses = [
  'ene', 'feb', 'mar', 'abr', 'may', 'jun',
  'jul', 'ago', 'sep', 'oct', 'nov', 'dic',
];

/// 14 oct 2026 · 9:41 p. m.
String formatoFecha(DateTime f) {
  final hora12 = f.hour % 12 == 0 ? 12 : f.hour % 12;
  final minutos = f.minute.toString().padLeft(2, '0');
  final ampm = f.hour < 12 ? 'a. m.' : 'p. m.';
  return '${f.day} ${_meses[f.month - 1]} ${f.year} · $hora12:$minutos $ampm';
}

/// 1:05  (minutos:segundos)
String formatoDuracion(Duration d) {
  final m = d.inMinutes;
  final s = (d.inSeconds % 60).toString().padLeft(2, '0');
  return '$m:$s';
}

/// 9:41 p. m.
String formatoHora(DateTime f) {
  final hora12 = f.hour % 12 == 0 ? 12 : f.hour % 12;
  final minutos = f.minute.toString().padLeft(2, '0');
  return '$hora12:$minutos ${f.hour < 12 ? 'a. m.' : 'p. m.'}';
}

/// "hace un momento", "hace 5 min", "hace 2 h"
String haceCuanto(DateTime fecha, [DateTime? ahora]) {
  final d = (ahora ?? DateTime.now()).difference(fecha);
  if (d.inMinutes < 1) return 'hace un momento';
  if (d.inHours < 1) return 'hace ${d.inMinutes} min';
  if (d.inDays < 1) return 'hace ${d.inHours} h';
  return 'hace ${d.inDays} d';
}
