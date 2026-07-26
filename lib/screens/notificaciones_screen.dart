import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/barra_navegacion_inferior.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);

/// Pantalla de notificaciones — accesible desde la barra de navegación
/// inferior. Por ahora es un placeholder: la app solo dispara
/// notificaciones locales de llegada (ver NotificationService), todavía
/// no guarda un historial para mostrar aquí.
class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondoCrema,
      bottomNavigationBar: const BarraNavegacionInferior(
        seccionActual: SeccionNav.notificaciones,
      ),
      appBar: AppBar(
        backgroundColor: _colorFondoCrema,
        elevation: 0,
        iconTheme: const IconThemeData(color: _colorTextoPrincipal),
        title: Text(
          'Notificaciones',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: _colorTextoPrincipal,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _colorDoradoXP.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: _colorBordeSuave),
                ),
                child: const Icon(
                  Icons.notifications_none,
                  color: _colorDoradoXP,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Sin notificaciones todavía',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _colorTextoPrincipal,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cuando camines cerca de un lugar del pueblo, te avisaremos '
                'aquí para que descubras su historia.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.5,
                  color: _colorTextoSecundario,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
