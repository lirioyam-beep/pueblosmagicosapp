import 'mision.dart';
import 'insignia.dart';

enum EstadoPueblo { completado, activo, bloqueado }

class Pueblo {
  String id; // ej: "izamal"
  String nombre; // ej: "Izamal"
  String descripcion; // descripción breve
  String colorHex; // color principal ej: "#D4A017"
  double latitud; // coordenadas GPS del centro del pueblo
  double longitud;
  EstadoPueblo estado; // completado, activo, bloqueado
  List<Mision> misiones;
  List<Insignia> insignias;

  Pueblo({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.colorHex,
    required this.latitud,
    required this.longitud,
    required this.estado,
    List<Mision>? misiones,
    List<Insignia>? insignias,
  })  : misiones = misiones ?? [],
        insignias = insignias ?? [];
}
