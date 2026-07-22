import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mision.dart';
import '../models/pueblo.dart';
import '../utils/color_utils.dart';
import '../utils/mision_utils.dart';
import 'pueblo_mapa_screen.dart';
import 'retos_screen.dart';

// Paleta general de la app - ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorVerdeCompletado = Color(0xFF3F6F52);

/// Tarjeta de descubrimiento que se abre al llegar fisicamente a un lugar
/// o al tocarlo manualmente desde el modo simulado.
class DescubrimientoScreen extends StatefulWidget {
  final Pueblo pueblo;
  final Mision mision;

  const DescubrimientoScreen({
    super.key,
    required this.pueblo,
    required this.mision,
  });

  @override
  State<DescubrimientoScreen> createState() => _DescubrimientoScreenState();
}

class _DescubrimientoScreenState extends State<DescubrimientoScreen> {
  Color get _colorPueblo => colorDesdeHex(pueblo.colorHex);

  Pueblo get pueblo => widget.pueblo;
  Mision get mision => widget.mision;

  Mision? get _siguienteMision {
    if (pueblo.misiones.isEmpty) return null;

    final indiceActual = pueblo.misiones.indexWhere(
      (candidata) => candidata.id == mision.id,
    );
    final inicio = indiceActual < 0 ? 0 : indiceActual + 1;

    for (var paso = 0; paso < pueblo.misiones.length; paso++) {
      final indice = (inicio + paso) % pueblo.misiones.length;
      final candidata = pueblo.misiones[indice];
      final esActual = candidata.id == mision.id;
      final yaDescubierta = candidata.descubierta || candidata.completada;
      if (!esActual && !yaDescubierta) return candidata;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    mision.descubierta = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondoCrema,
      appBar: AppBar(
        backgroundColor: _colorFondoCrema,
        elevation: 0,
        iconTheme: IconThemeData(color: _colorPueblo),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        color: _colorPueblo,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        iconoPorTipoMision(mision.tipo),
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _colorVerdeCompletado,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Llegaste',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      mision.lugarFisico,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: _colorTextoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      mision.contenidoDescubrimiento.isNotEmpty
                          ? mision.contenidoDescubrimiento
                          : mision.descripcion,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.6,
                        color: _colorTextoSecundario,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSugerencia(context),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: _colorDoradoXP, size: 18),
                const SizedBox(width: 6),
                Text(
                  'Reto disponible: +${mision.xpRecompensa} XP',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _colorDoradoXP,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => RetosScreen(pueblo: pueblo)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _colorPueblo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Hacer el reto',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSugerencia(BuildContext context) {
    final siguiente = _siguienteMision;

    if (siguiente == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _colorBordeSuave),
        ),
        child: Column(
          children: [
            const Icon(Icons.emoji_events_outlined, color: _colorVerdeCompletado),
            const SizedBox(height: 8),
            Text(
              'Ya descubriste todos los puntos disponibles de ${pueblo.nombre}.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.4,
                color: _colorTextoSecundario,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _colorBordeSuave),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Siguiente descubrimiento',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _colorTextoPrincipal,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(color: _colorPueblo, shape: BoxShape.circle),
                child: Icon(
                  iconoPorTipoMision(siguiente.tipo),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      siguiente.lugarFisico,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _colorTextoPrincipal,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Ve al mapa para encontrar este punto y desbloquear su historia.',
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
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => PuebloMapaScreen(
                    pueblo: pueblo,
                    misionResaltadaId: siguiente.id,
                  ),
                ),
              ),
              icon: const Icon(Icons.map_outlined, size: 18),
              label: Text(
                'Ver en mapa',
                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: _colorPueblo,
                side: BorderSide(color: _colorPueblo),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
