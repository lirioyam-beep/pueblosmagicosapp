# Ruta Mágica — Base de Datos

## Tecnología
Firebase (Google) — fase futura del proyecto.
Ahorita NO está implementado. El MVP usa datos locales en pueblos_data.dart.

## Servicios de Firebase a usar
- **Firebase Authentication** — login con Google o email/contraseña
- **Cloud Firestore** — base de datos en tiempo real para progreso del usuario
- **Firebase Storage** — imágenes de insignias y avatares

## Modelos de datos

### Pueblo
```dart
class Pueblo {
  String id;           // ej: "izamal"
  String nombre;       // ej: "Izamal"
  String descripcion;  // descripción breve
  String colorHex;     // color principal ej: "#D4A017"
  double latitud;      // coordenadas GPS del centro del pueblo
  double longitud;
  EstadoPueblo estado; // completado, activo, bloqueado
  List<Mision> misiones;
  List<Insignia> insignias;
}

enum EstadoPueblo { completado, activo, bloqueado }
```

### Mision
```dart
class Mision {
  String id;
  String titulo;          // ej: "Visita el Convento de San Antonio"
  String descripcion;
  String lugarFisico;     // nombre del lugar donde debe estar el usuario
  double latitud;         // coordenadas del lugar físico
  double longitud;
  double radioMetros;     // radio de activación (default: 100m)
  TipoMision tipo;        // ubicacion, trivia, gastronomica
  int xpRecompensa;       // XP que otorga al completarse
  bool completada;
  String? preguntaTrivia; // solo para tipo trivia
  String? respuestaTrivia;
}

enum TipoMision { ubicacion, trivia, gastronomica }
```

### Insignia
```dart
class Insignia {
  String id;
  String nombre;        // ej: "Explorador de Izamal"
  String descripcion;
  String imagenUrl;     // URL en Firebase Storage
  bool desbloqueada;
  String? puebloId;     // null si es insignia general
  List<String> requisitos; // IDs de misiones necesarias para desbloquear
}
```

### Usuario
```dart
class Usuario {
  String id;            // UID de Firebase Auth
  String nombre;
  String avatarId;      // "avatar_1", "avatar_2", "avatar_3"
  int xpTotal;
  List<String> insigniasDesbloqueadas; // IDs de insignias
  List<String> misionesCompletadas;    // IDs de misiones
  Map<String, EstadoPueblo> estadoPueblos; // progreso por pueblo
}
```

## Estructura en Firestore

```
usuarios/
  {userId}/
    nombre: string
    avatarId: string
    xpTotal: number
    insigniasDesbloqueadas: array
    misionesCompletadas: array
    estadoPueblos: map

pueblos/               ← datos maestros, no cambian por usuario
  izamal/
    misiones/
      {misionId}/
    insignias/
      {insigniaId}/
```

## Datos locales (MVP actual)
Mientras Firebase no está implementado, todos los datos 
viven en lib/data/pueblos_data.dart como listas de objetos Dart.
El progreso del usuario se guarda en memoria (se pierde al cerrar la app).
Cuando Firebase esté listo, solo se cambia de dónde vienen los datos,
la lógica de pantallas no cambia.

## Orden de implementación Firebase
1. Primero: completar todas las pantallas con datos locales
2. Segundo: agregar Firebase Auth (login con Google)
3. Tercero: migrar datos locales a Firestore
4. Cuarto: agregar Storage para imágenes reales
