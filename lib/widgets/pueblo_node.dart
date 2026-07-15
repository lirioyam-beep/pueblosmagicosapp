import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pueblo.dart';

// Sistema de tres estados — ver DESIGN.md
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorTerracotaActivo = Color(0xFFC1502E);
const Color _colorGrisBloqueado = Color(0xFFE7E0D3);
const Color _colorIconoBloqueado = Color(0xFFA89A85);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);

/// Nodo circular de un pueblo dentro del mapa de exploración.
/// Refleja el estado (completado / activo / bloqueado) con color, ícono
/// y, en el caso del nodo activo, una animación de pulso continua.
class PuebloNode extends StatefulWidget {
  final Pueblo pueblo;
  final VoidCallback onTap;

  const PuebloNode({super.key, required this.pueblo, required this.onTap});

  @override
  State<PuebloNode> createState() => _PuebloNodeState();
}

class _PuebloNodeState extends State<PuebloNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _pulso;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulso = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  (Color, IconData) get _estiloEstado {
    switch (widget.pueblo.estado) {
      case EstadoPueblo.completado:
        return (_colorVerdeCompletado, Icons.check);
      case EstadoPueblo.activo:
        return (_colorTerracotaActivo, Icons.star);
      case EstadoPueblo.bloqueado:
        return (_colorGrisBloqueado, Icons.lock);
    }
  }

  @override
  Widget build(BuildContext context) {
    final estado = widget.pueblo.estado;
    final (colorFondo, icono) = _estiloEstado;
    final colorIcono =
        estado == EstadoPueblo.bloqueado ? _colorIconoBloqueado : Colors.white;
    final esActivo = estado == EstadoPueblo.activo;

    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: colorFondo,
                  shape: BoxShape.circle,
                  boxShadow: esActivo
                      ? [
                          BoxShadow(
                            color: colorFondo.withValues(
                              alpha: 0.45 - (_pulso.value / 10) * 0.35,
                            ),
                            blurRadius: 6 + _pulso.value * 1.5,
                            spreadRadius: _pulso.value,
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                ),
                child: child,
              );
            },
            child: Icon(icono, color: colorIcono, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            widget.pueblo.nombre,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _colorTextoPrincipal,
            ),
          ),
        ],
      ),
    );
  }
}
