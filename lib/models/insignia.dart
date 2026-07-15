class Insignia {
  String id;
  String nombre; // ej: "Explorador de Izamal"
  String descripcion;
  String imagenUrl; // URL en Firebase Storage
  bool desbloqueada;
  String? puebloId; // null si es insignia general
  List<String> requisitos; // IDs de misiones necesarias para desbloquear

  Insignia({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.imagenUrl,
    this.desbloqueada = false,
    this.puebloId,
    required this.requisitos,
  });
}
