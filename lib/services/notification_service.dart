import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Envuelve `flutter_local_notifications`: inicializa el plugin, pide el
/// permiso de notificaciones (Android 13+) y dispara los avisos de
/// "llegaste a un lugar" mientras la app sigue viva (abierta o
/// minimizada — no funciona con la app completamente cerrada).
class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _inicializado = false;

  static const String _idCanal = 'descubrimientos';
  static const String _nombreCanal = 'Descubrimientos culturales';
  static const String _descripcionCanal =
      'Avisos cuando llegas a un lugar del recorrido';

  Future<void> inicializar({
    required void Function(String? payload) onTocarNotificacion,
  }) async {
    if (_inicializado) return;

    const configAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const configuracion = InitializationSettings(android: configAndroid);

    await _plugin.initialize(
      settings: configuracion,
      onDidReceiveNotificationResponse: (respuesta) {
        onTocarNotificacion(respuesta.payload);
      },
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    _inicializado = true;
  }

  Future<void> mostrarLlegada({
    required String titulo,
    required String cuerpo,
    required String payload,
  }) async {
    const detallesAndroid = AndroidNotificationDetails(
      _idCanal,
      _nombreCanal,
      channelDescription: _descripcionCanal,
      importance: Importance.high,
      priority: Priority.high,
    );
    const detalles = NotificationDetails(android: detallesAndroid);

    await _plugin.show(
      id: payload.hashCode & 0x7fffffff,
      title: titulo,
      body: cuerpo,
      notificationDetails: detalles,
      payload: payload,
    );
  }
}
