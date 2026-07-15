import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/insignia.dart';

// Sistema de tres estados — ver DESIGN.md
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorGrisBloqueado = Color(0xFFE7E0D3);
const Color _colorIconoBloqueado = Color(0xFFA89A85);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);

/// Insignia individual con estado desbloqueada (verde/check) o
/// bloqueada (gris/candado), según DESIGN.md.
class InsigniaBadge extends StatelessWidget {
  final Insignia insignia;

  const InsigniaBadge({super.key, required this.insignia});

  @override
  Widget build(BuildContext context) {
    final desbloqueada = insignia.desbloqueada;
    final colorFondo = desbloqueada ? _colorVerdeCompletado : _colorGrisBloqueado;
    final colorIcono = desbloqueada ? Colors.white : _colorIconoBloqueado;
    final icono = desbloqueada ? Icons.check : Icons.lock;

    return SizedBox(
      width: 72,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: colorFondo, shape: BoxShape.circle),
            child: Icon(icono, color: colorIcono, size: 24),
          ),
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
}
