import 'dart:async';

import 'package:geolocator/geolocator.dart';
import '../models/mision.dart';
import '../models/pueblo.dart';
import 'location_service.dart';
import 'notification_service.dart';

/// Vigila la posición del usuario mientras recorre un pueblo y dispara una
/// notificación local la primera vez que entra al radio de una misión de
/// tipo ubicación aún no completada. Vive independiente del ciclo de vida
/// de cualquier pantalla — sigue corriendo mientras la app esté viva
/// (abierta o minimizada; no funciona con la app cerrada del todo).
class ExploracionController {
  ExploracionController._();
  static final ExploracionController instance = ExploracionController._();

  final LocationService _locationService = LocationService();
  StreamSubscription<Position>? _suscripcion;
  Pueblo? _puebloActivo;
  final Set<String> _misionesNotificadas = {};

  /// Empieza (o reinicia, si cambió el pueblo) el monitoreo de posición.
  /// Es seguro llamarla varias veces desde distintas pantallas del mismo
  /// pueblo — es idempotente si ya está vigilando ese pueblo.
  void activarPueblo(Pueblo pueblo) {
    if (_puebloActivo?.id == pueblo.id && _suscripcion != null) return;

    _puebloActivo = pueblo;
    _misionesNotificadas.clear();
    _suscripcion?.cancel();
    _suscripcion = _locationService.posicionEnVivo().listen(_alRecibirPosicion);
  }

  /// Detiene el monitoreo. Se llama al volver al selector de pueblos.
  void detener() {
    _suscripcion?.cancel();
    _suscripcion = null;
    _puebloActivo = null;
    _misionesNotificadas.clear();
  }

  void _alRecibirPosicion(Position posicion) {
    final pueblo = _puebloActivo;
    if (pueblo == null) return;

    for (final mision in pueblo.misiones) {
      if (mision.tipo != TipoMision.ubicacion) continue;
      if (mision.completada) continue;
      if (_misionesNotificadas.contains(mision.id)) continue;
      if (!_locationService.estaCercaDeMision(posicion, mision)) continue;

      _misionesNotificadas.add(mision.id);
      NotificationService.instance.mostrarLlegada(
        titulo: '¡Llegaste a ${mision.lugarFisico}!',
        cuerpo: mision.contenidoDescubrimiento.isNotEmpty
            ? mision.contenidoDescubrimiento
            : 'Toca para descubrir la historia de este lugar.',
        payload: '${pueblo.id}|${mision.id}',
      );
    }
  }
}
