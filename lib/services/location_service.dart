import 'package:geolocator/geolocator.dart';
import '../models/mision.dart';

/// Resultado de intentar obtener la ubicación del usuario.
enum EstadoUbicacion {
  disponible, // se obtuvo la posición correctamente
  servicioDesactivado, // el GPS del teléfono está apagado
  permisoDenegado, // el usuario no dio permiso de ubicación
}

/// Envuelve el paquete `geolocator`: permisos, posición actual/streaming
/// y cálculo de distancia contra los puntos de misiones. Ver DATABASE.md
/// (Mision.latitud/longitud/radioMetros) y FEATURES.md (radio de 100m).
class LocationService {
  // Varias pantallas y ExploracionController escuchan la posición en vivo
  // al mismo tiempo. Geolocator.getPositionStream() abre un canal nativo
  // nuevo cada vez que se llama — si se invoca varias veces en paralelo,
  // en algunos dispositivos el canal nativo se pisa entre sí y truena la
  // app. Por eso se cachea como un solo broadcast stream compartido.
  Stream<Position>? _streamPosicion;

  Future<LocationPermission> _asegurarPermiso() async {
    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }
    return permiso;
  }

  /// Intenta obtener la posición actual. Devuelve null si el GPS está
  /// apagado o el usuario negó el permiso; [estado] explica por qué,
  /// para poder mostrar el modo simulado "Estoy aquí" como fallback.
  Future<(Position?, EstadoUbicacion)> obtenerPosicionActual() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return (null, EstadoUbicacion.servicioDesactivado);
    }

    final permiso = await _asegurarPermiso();
    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      return (null, EstadoUbicacion.permisoDenegado);
    }

    try {
      final posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      return (posicion, EstadoUbicacion.disponible);
    } catch (_) {
      return (null, EstadoUbicacion.servicioDesactivado);
    }
  }

  /// Stream de posición en vivo (solo emite si hay permiso y servicio
  /// activo). Se actualiza conforme el usuario camina por el pueblo.
  Stream<Position> posicionEnVivo() {
    return _streamPosicion ??= Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // metros mínimos entre actualizaciones
      ),
    ).asBroadcastStream();
  }

  double distanciaAMision(Position posicionUsuario, Mision mision) {
    return Geolocator.distanceBetween(
      posicionUsuario.latitude,
      posicionUsuario.longitude,
      mision.latitud,
      mision.longitud,
    );
  }

  bool estaCercaDeMision(Position posicionUsuario, Mision mision) {
    return distanciaAMision(posicionUsuario, mision) <= mision.radioMetros;
  }
}
