import '../models/pueblo.dart';

/// XP total acumulada sumando las misiones completadas de todos los pueblos.
/// Placeholder: sin backend ni estado global todavía — se recalcula leyendo
/// directamente pueblosData (fuente única compartida por toda la app).
int calcularXpTotal(List<Pueblo> pueblos) {
  return pueblos
      .expand((p) => p.misiones)
      .where((m) => m.completada)
      .fold(0, (suma, m) => suma + m.xpRecompensa);
}
