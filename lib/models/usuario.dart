import 'pueblo.dart';

class Usuario {
  String id; // UID de Firebase Auth
  String nombre;
  String avatarId; // "avatar_1", "avatar_2", "avatar_3"
  int xpTotal;
  List<String> insigniasDesbloqueadas; // IDs de insignias
  List<String> misionesCompletadas; // IDs de misiones
  Map<String, EstadoPueblo> estadoPueblos; // progreso por pueblo

  Usuario({
    required this.id,
    required this.nombre,
    required this.avatarId,
    this.xpTotal = 0,
    List<String>? insigniasDesbloqueadas,
    List<String>? misionesCompletadas,
    Map<String, EstadoPueblo>? estadoPueblos,
  })  : insigniasDesbloqueadas = insigniasDesbloqueadas ?? [],
        misionesCompletadas = misionesCompletadas ?? [],
        estadoPueblos = estadoPueblos ?? {};
}
