import '../models/pueblo.dart';

/// Recalcula qué insignias del pueblo deben quedar desbloqueadas, comparando
/// sus `requisitos` (IDs de misión) contra las misiones ya completadas.
/// Insignias sin requisitos definidos (placeholder) se dejan sin tocar.
void actualizarInsignias(Pueblo pueblo) {
  final completadas = pueblo.misiones
      .where((m) => m.completada)
      .map((m) => m.id)
      .toSet();

  for (final insignia in pueblo.insignias) {
    if (insignia.requisitos.isEmpty) continue;
    insignia.desbloqueada = insignia.requisitos.every(completadas.contains);
  }
}
