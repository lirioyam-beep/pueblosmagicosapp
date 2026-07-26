import 'package:flutter/material.dart';
import '../data/pueblos_data.dart';
import '../models/pueblo.dart';
import '../screens/insignias_screen.dart';
import '../screens/map_screen.dart';
import '../screens/menu_cultural_screen.dart';
import '../screens/notificaciones_screen.dart';
import '../screens/pueblo_mapa_screen.dart';
import '../screens/retos_screen.dart';

const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorBordeSuave = Color(0xFFEFE2C8);

/// Las 6 secciones fijas de la barra de navegación inferior. Se usan los
/// mismos 6 botones en todas las pantallas posteriores al login.
enum SeccionNav { perfil, mapa, misiones, cultura, pueblos, notificaciones }

/// Barra de navegación inferior fija y consistente en toda la app.
/// "Mapa", "Misiones" y "Recomendaciones" actúan sobre el pueblo indicado
/// en [pueblo]; si no se indica ninguno (por ejemplo desde Perfil), usan
/// el pueblo activo por defecto.
class BarraNavegacionInferior extends StatelessWidget {
  final SeccionNav seccionActual;
  final Pueblo? pueblo;

  const BarraNavegacionInferior({
    super.key,
    required this.seccionActual,
    this.pueblo,
  });

  Pueblo get _puebloContextual =>
      pueblo ??
      pueblosData.firstWhere(
        (p) => p.estado == EstadoPueblo.activo,
        orElse: () => pueblosData.first,
      );

  static const _items = [
    (SeccionNav.perfil, Icons.person_outline, 'Perfil'),
    (SeccionNav.mapa, Icons.map_outlined, 'Mapa'),
    (SeccionNav.misiones, Icons.flag_outlined, 'Misiones'),
    (SeccionNav.cultura, Icons.auto_stories_outlined, 'Cultura'),
    (SeccionNav.pueblos, Icons.location_city_outlined, 'Pueblos'),
    (SeccionNav.notificaciones, Icons.notifications_outlined, 'Avisos'),
  ];

  void _navegar(BuildContext context, SeccionNav destino) {
    if (destino == seccionActual) return;

    final Widget pantalla;
    switch (destino) {
      case SeccionNav.perfil:
        pantalla = const InsigniasScreen();
      case SeccionNav.mapa:
        pantalla = PuebloMapaScreen(pueblo: _puebloContextual);
      case SeccionNav.misiones:
        pantalla = RetosScreen(pueblo: _puebloContextual);
      case SeccionNav.cultura:
        pantalla = MenuCulturalScreen(pueblo: _puebloContextual);
      case SeccionNav.pueblos:
        pantalla = const MapScreen();
      case SeccionNav.notificaciones:
        pantalla = const NotificacionesScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => pantalla),
    );
  }

  @override
  Widget build(BuildContext context) {
    final indiceActual = _items.indexWhere((i) => i.$1 == seccionActual);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _colorBordeSuave)),
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: indiceActual < 0 ? 0 : indiceActual,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: _colorDoradoXP,
          unselectedItemColor: _colorTextoSecundario,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          onTap: (index) => _navegar(context, _items[index].$1),
          items: [
            for (final (_, icono, etiqueta) in _items)
              BottomNavigationBarItem(icon: Icon(icono), label: etiqueta),
          ],
        ),
      ),
    );
  }
}
