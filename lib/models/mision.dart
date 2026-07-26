enum TipoMision { ubicacion, trivia, gastronomica }

class Mision {
  String id;
  String titulo; // ej: "Visita el Convento de San Antonio"
  String descripcion;
  String lugarFisico; // nombre del lugar donde debe estar el usuario
  double latitud; // coordenadas del lugar físico
  double longitud;
  double radioMetros; // radio de activación (default: 100m)
  TipoMision tipo; // ubicacion, trivia, gastronomica
  int xpRecompensa; // XP que otorga al completarse
  bool descubierta; // true cuando el usuario llego o abrio el descubrimiento
  bool completada;
  String? preguntaTrivia; // solo para tipo trivia
  String? respuestaTrivia;
  List<String>? opcionesTrivia; // opciones de respuesta, incluye la correcta

  /// Dato curioso, leyenda o contexto cultural del lugar. Se muestra en la
  /// tarjeta de descubrimiento cuando el usuario llega físicamente (antes
  /// de invitarlo a hacer el reto). Ver la visión de guía turístico.
  String contenidoDescubrimiento;

  Mision({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.lugarFisico,
    required this.latitud,
    required this.longitud,
    this.radioMetros = 100,
    required this.tipo,
    required this.xpRecompensa,
    this.descubierta = false,
    this.completada = false,
    this.preguntaTrivia,
    this.respuestaTrivia,
    this.opcionesTrivia,
    this.contenidoDescubrimiento = '',
  });
}
