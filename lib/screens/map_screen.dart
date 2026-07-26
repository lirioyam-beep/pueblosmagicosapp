import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/pueblos_data.dart';
import '../models/pueblo.dart';
import '../services/exploracion_controller.dart';
import '../utils/color_utils.dart';
import '../utils/progreso_utils.dart';
import 'insignias_screen.dart';
import 'pueblo_mapa_screen.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorGrisBloqueado = Color(0xFFE7E0D3);
const Color _colorIconoBloqueado = Color(0xFFA89A85);

/// Selector de pueblos — tarjetas tipo menú, una por pueblo (mismo
/// lenguaje visual que "Tu ruta" en insignias_screen.dart). Tocar un
/// pueblo activo o completado lleva directo al mapa real; tocar uno
/// bloqueado explica que llegará en una futura actualización.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Future<void> _onTapPueblo(BuildContext context, Pueblo pueblo) async {
    if (pueblo.estado == EstadoPueblo.bloqueado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pueblo.nombre} estará disponible en una futura actualización'),
        ),
      );
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PuebloMapaScreen(pueblo: pueblo)),
    );
    // Al volver, el usuario pudo haber completado retos en otra pantalla:
    // refrescamos para que el XP/progreso no se quede con datos viejos.
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ExploracionController.instance.detener();

    final pueblos = pueblosData;
    final total = pueblos.length;
    final completados =
        pueblos.where((p) => p.estado == EstadoPueblo.completado).length;

    return Scaffold(
      backgroundColor: _colorFondoCrema,
      body: SafeArea(
        child: Column(
          children: [
            _BarraSuperior(
              completados: completados,
              total: total,
              xpTotal: calcularXpTotal(pueblos),
              onTapXp: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const InsigniasScreen()),
                );
                if (mounted) setState(() {});
              },
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                itemCount: pueblos.length,
                separatorBuilder: (_, _) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final pueblo = pueblos[index];
                  return _TarjetaPueblo(
                    pueblo: pueblo,
                    onTap: () => _onTapPueblo(context, pueblo),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarraSuperior extends StatelessWidget {
  final int completados;
  final int total;
  final int xpTotal;
  final VoidCallback onTapXp;

  const _BarraSuperior({
    required this.completados,
    required this.total,
    required this.xpTotal,
    required this.onTapXp,
  });

  @override
  Widget build(BuildContext context) {
    final indiceActual = (completados + 1).clamp(1, total);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: completados / total,
                    minHeight: 6,
                    backgroundColor: _colorBordeSuave,
                    valueColor:
                        const AlwaysStoppedAnimation(_colorVerdeCompletado),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '$indiceActual de $total pueblos',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: _colorTextoSecundario,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: onTapXp,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _colorBordeSuave),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: _colorDoradoXP, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '$xpTotal',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: _colorTextoPrincipal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Tarjeta tipo menú de un pueblo — mismo lenguaje visual que las filas
/// de "Tu ruta" en insignias_screen.dart, pero como tarjeta principal de
/// selección. Refleja el sistema de tres estados de DESIGN.md.
class _TarjetaPueblo extends StatelessWidget {
  final Pueblo pueblo;
  final VoidCallback onTap;

  const _TarjetaPueblo({required this.pueblo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final completadas = pueblo.misiones.where((m) => m.completada).length;
    final total = pueblo.misiones.length;

    final Color colorEstado;
    final IconData icono;
    final String textoEstado;

    switch (pueblo.estado) {
      case EstadoPueblo.completado:
        colorEstado = _colorVerdeCompletado;
        icono = Icons.check;
        textoEstado = 'Completado';
      case EstadoPueblo.activo:
        colorEstado = colorDesdeHex(pueblo.colorHex);
        icono = Icons.star;
        textoEstado = total > 0 ? '$completadas/$total misiones' : 'Disponible';
      case EstadoPueblo.bloqueado:
        colorEstado = _colorGrisBloqueado;
        icono = Icons.lock;
        textoEstado = 'Próxima actualización';
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _colorBordeSuave),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(color: colorEstado, shape: BoxShape.circle),
                child: Icon(
                  icono,
                  color: pueblo.estado == EstadoPueblo.bloqueado
                      ? _colorIconoBloqueado
                      : Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pueblo.nombre,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _colorTextoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      textoEstado,
                      style: GoogleFonts.inter(fontSize: 13, color: _colorTextoSecundario),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: _colorTextoSecundario),
            ],
          ),
        ),
      ),
    );
  }
}
