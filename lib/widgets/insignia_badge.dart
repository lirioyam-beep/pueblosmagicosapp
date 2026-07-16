import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/insignia.dart';

// Sistema de tres estados — ver DESIGN.md
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorGrisBloqueado = Color(0xFFE7E0D3);
const Color _colorIconoBloqueado = Color(0xFFA89A85);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);

// Convierte a escala de grises el arte de una insignia aún bloqueada.
const List<double> _matrizGris = <double>[
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0.2126, 0.7152, 0.0722, 0, 0,
  0, 0, 0, 1, 0,
];

/// Insignia individual. Si tiene arte propio (`imagenUrl` como asset local),
/// se muestra a color cuando está desbloqueada y en gris con un candado
/// pequeño encima cuando no. Sin arte, cae al círculo genérico con
/// check/candado — sistema de tres estados de DESIGN.md.
class InsigniaBadge extends StatelessWidget {
  final Insignia insignia;

  const InsigniaBadge({super.key, required this.insignia});

  @override
  Widget build(BuildContext context) {
    final desbloqueada = insignia.desbloqueada;
    final tieneArte = insignia.imagenUrl.isNotEmpty;

    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          tieneArte ? _buildConArte(desbloqueada) : _buildGenerico(desbloqueada),
          const SizedBox(height: 6),
          Text(
            insignia.nombre,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: _colorTextoPrincipal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerico(bool desbloqueada) {
    final colorFondo = desbloqueada ? _colorVerdeCompletado : _colorGrisBloqueado;
    final colorIcono = desbloqueada ? Colors.white : _colorIconoBloqueado;
    final icono = desbloqueada ? Icons.check : Icons.lock;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(color: colorFondo, shape: BoxShape.circle),
      child: Icon(icono, color: colorIcono, size: 24),
    );
  }

  Widget _buildConArte(bool desbloqueada) {
    final imagen = ClipOval(
      child: Image.asset(
        insignia.imagenUrl,
        width: 56,
        height: 56,
        fit: BoxFit.cover,
      ),
    );

    if (desbloqueada) return imagen;

    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        children: [
          Opacity(
            opacity: 0.5,
            child: ColorFiltered(
              colorFilter: const ColorFilter.matrix(_matrizGris),
              child: imagen,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: _colorGrisBloqueado,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock, size: 12, color: _colorIconoBloqueado),
            ),
          ),
        ],
      ),
    );
  }
}
