import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/pueblos_data.dart';
import '../models/pueblo.dart';
import '../services/exploracion_controller.dart';
import '../utils/color_utils.dart';
import '../utils/progreso_utils.dart';
import '../widgets/pueblo_node.dart';
import 'insignias_screen.dart';
import 'pueblo_detail_screen.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorVerdeCompletado = Color(0xFF3F6F52);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Future<void> _onTapPueblo(BuildContext context, Pueblo pueblo) async {
    if (pueblo.estado == EstadoPueblo.bloqueado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa Izamal primero')),
      );
      return;
    }
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => PuebloDetailScreen(pueblo: pueblo)),
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
    final puebloActivo = pueblos.firstWhere(
      (p) => p.estado == EstadoPueblo.activo,
      orElse: () => pueblos.first,
    );

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
              child: _CaminoPueblos(
                pueblos: pueblos,
                onTapPueblo: (pueblo) => _onTapPueblo(context, pueblo),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => _onTapPueblo(context, puebloActivo),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorDesdeHex(puebloActivo.colorHex),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Continuar a ${puebloActivo.nombre}',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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

/// Camino punteado curvo que conecta los nodos de los pueblos, estilo
/// mapa de videojuego. Izamal abajo, Valladolid en medio, Maní arriba.
class _CaminoPueblos extends StatelessWidget {
  final List<Pueblo> pueblos;
  final ValueChanged<Pueblo> onTapPueblo;

  const _CaminoPueblos({required this.pueblos, required this.onTapPueblo});

  static const List<Offset> _posicionesFraccionales = [
    Offset(0.30, 0.88), // Izamal
    Offset(0.72, 0.50), // Valladolid
    Offset(0.32, 0.12), // Maní
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final puntos = _posicionesFraccionales
            .map((p) => Offset(p.dx * size.width, p.dy * size.height))
            .toList();

        return Stack(
          children: [
            CustomPaint(
              size: size,
              painter: _CaminoPunteadoPainter(puntos: puntos),
            ),
            for (var i = 0; i < pueblos.length && i < puntos.length; i++)
              Positioned(
                left: puntos[i].dx - 40,
                top: puntos[i].dy - 40,
                child: SizedBox(
                  width: 80,
                  child: PuebloNode(
                    pueblo: pueblos[i],
                    onTap: () => onTapPueblo(pueblos[i]),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CaminoPunteadoPainter extends CustomPainter {
  final List<Offset> puntos;

  _CaminoPunteadoPainter({required this.puntos});

  @override
  void paint(Canvas canvas, Size size) {
    if (puntos.length < 2) return;

    final path = Path()..moveTo(puntos.first.dx, puntos.first.dy);
    for (var i = 0; i < puntos.length - 1; i++) {
      final inicio = puntos[i];
      final fin = puntos[i + 1];
      final control = Offset(
        (inicio.dx + fin.dx) / 2 + (i.isEven ? 70 : -70),
        (inicio.dy + fin.dy) / 2,
      );
      path.quadraticBezierTo(control.dx, control.dy, fin.dx, fin.dy);
    }

    final pintura = Paint()
      ..color = _colorBordeSuave
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const anchoGuion = 8.0;
    const espacioGuion = 6.0;

    for (final metrica in path.computeMetrics()) {
      var distancia = 0.0;
      while (distancia < metrica.length) {
        final siguiente = distancia + anchoGuion;
        canvas.drawPath(
          metrica.extractPath(distancia, siguiente.clamp(0, metrica.length)),
          pintura,
        );
        distancia = siguiente + espacioGuion;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CaminoPunteadoPainter oldDelegate) {
    return oldDelegate.puntos != puntos;
  }
}
