import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'insignias_screen.dart';
import 'map_screen.dart';

// Paleta general de la app - ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorSuperficie = Color(0xFFFFFFFF);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorVerde = Color(0xFF3F6F52);

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  String get _nombreUsuario {
    final usuario = AuthService.instance.usuarioActual;
    final nombre = usuario?.displayName?.trim();
    if (nombre != null && nombre.isNotEmpty) return nombre;
    final correo = usuario?.email;
    if (correo != null && correo.contains('@')) {
      return correo.split('@').first;
    }
    return 'explorador';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondoCrema,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  tooltip: 'Ver perfil',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const InsigniasScreen()),
                  ),
                  icon: const CircleAvatar(
                    radius: 22,
                    backgroundColor: _colorSuperficie,
                    child: Icon(Icons.person_outline, color: _colorTextoSecundario),
                  ),
                ),
              ),
              const Spacer(flex: 2),
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: _colorDoradoXP.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(color: _colorDoradoXP.withValues(alpha: 0.35)),
                ),
                child: const Icon(Icons.explore_outlined, color: _colorDoradoXP, size: 42),
              ),
              const SizedBox(height: 28),
              Text(
                'Bienvenido, $_nombreUsuario',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: _colorTextoPrincipal,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Tu ruta por los Pueblos Magicos de Yucatan esta lista. '
                'Camina, descubre lugares cercanos y desbloquea historias al explorar.',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.45,
                  color: _colorTextoSecundario,
                ),
              ),
              const SizedBox(height: 28),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _colorSuperficie,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _colorBordeSuave),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        color: _colorVerde,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.location_on_outlined, color: Colors.white),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Izamal disponible',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _colorTextoPrincipal,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Empieza con el mapa interactivo y descubre retos cercanos.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: _colorTextoSecundario,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const MapScreen()),
                  ),
                  icon: const Icon(Icons.map_outlined),
                  label: Text(
                    'Explorar',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colorDoradoXP,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
