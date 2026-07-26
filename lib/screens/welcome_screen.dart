import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'map_screen.dart';

// Paleta general de la app - ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);

/// Animación de bienvenida tras iniciar sesión — sin botones, sin
/// selector de perfil. Solo da la bienvenida y, tras un momento, avanza
/// sola a la lista de pueblos.
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  static const _duracionAnimacion = Duration(milliseconds: 700);
  static const _esperaAntesDeAvanzar = Duration(milliseconds: 2200);

  late final AnimationController _controller;
  late final Animation<double> _escala;
  late final Animation<double> _opacidad;
  Timer? _timer;

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
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duracionAnimacion);
    _escala = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _opacidad = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    _timer = Timer(_esperaAntesDeAvanzar, () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MapScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondoCrema,
      body: Center(
        child: FadeTransition(
          opacity: _opacidad,
          child: ScaleTransition(
            scale: _escala,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: _colorDoradoXP.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                    border: Border.all(color: _colorDoradoXP.withValues(alpha: 0.35)),
                  ),
                  child: const Icon(Icons.explore_outlined, color: _colorDoradoXP, size: 48),
                ),
                const SizedBox(height: 28),
                Text(
                  'Bienvenido, $_nombreUsuario',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                    color: _colorTextoPrincipal,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tu ruta por los Pueblos Mágicos de Yucatán está lista.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14, color: _colorTextoSecundario),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
