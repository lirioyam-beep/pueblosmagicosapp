import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mision.dart';
import '../models/pueblo.dart';
import '../utils/color_utils.dart';
import '../utils/mision_utils.dart';
import 'retos_screen.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorVerdeCompletado = Color(0xFF3F6F52);

/// Tarjeta de "descubrimiento" que se abre al llegar físicamente a un
/// lugar (vía la notificación de ExploracionController) o al tocarla
/// manualmente. Muestra el contenido cultural del sitio y luego invita
/// al reto — así el usuario primero lee, después actúa.
class DescubrimientoScreen extends StatelessWidget {
  final Pueblo pueblo;
  final Mision mision;

  const DescubrimientoScreen({super.key, required this.pueblo, required this.mision});

  Color get _colorPueblo => colorDesdeHex(pueblo.colorHex);

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
            Container(
              width: 84,
              height: 84,
              decoration: BoxDecoration(color: _colorPueblo, shape: BoxShape.circle),
              child: Icon(iconoPorTipoMision(mision.tipo), color: Colors.white, size: 36),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _colorVerdeCompletado,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '¡Llegaste!',
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
            const Spacer(),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 0,
                ),
                child: Text(
                  'Hacer el reto',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
