import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/pueblos_data.dart';
import '../utils/progreso_utils.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);

const List<String> _rutasAvatar = [
  'assets/avatares/avatar_1v.png',
  'assets/avatares/avatar_2v.png',
  'assets/avatares/avatar_3v.png',
];

// Nombre y mensaje de ánimo por nivel.
const List<(String nombre, String comentario)> _infoNiveles = [
  ('Turista', '¡Bienvenido a Yucatán! Apenas empiezas tu ruta — cada lugar que visites te acerca al siguiente nivel.'),
  ('Explorador', 'Ya te animaste a caminar y descubrir historias reales. ¡Vas muy bien!'),
  ('Aventurero', 'Conoces Izamal como pocos. Sigue así y desbloquea todas las insignias.'),
];

// XP necesaria por nivel — placeholder simple, sin backend todavía.
const int _xpPorNivel = 100;

/// Pantalla de niveles — antes eran los "avatares" que se elegían en el
/// perfil, pero en realidad representan el nivel del usuario, así que
/// viven aparte. Se desbloquean conforme sube el nivel.
class NivelesScreen extends StatefulWidget {
  const NivelesScreen({super.key});

  @override
  State<NivelesScreen> createState() => _NivelesScreenState();
}

class _NivelesScreenState extends State<NivelesScreen> {
  int _nivelSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    final xpTotal = calcularXpTotal(pueblosData);
    final nivelActual = (xpTotal ~/ _xpPorNivel) + 1;

    return Scaffold(
      backgroundColor: _colorFondoCrema,
      appBar: AppBar(
        backgroundColor: _colorFondoCrema,
        elevation: 0,
        iconTheme: const IconThemeData(color: _colorTextoPrincipal),
        title: Text(
          'Niveles',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: _colorTextoPrincipal,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Nivel actual: $nivelActual',
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _colorTextoPrincipal,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Cada nivel desbloquea una nueva insignia de nivel.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12, color: _colorTextoSecundario),
            ),
            const SizedBox(height: 24),
            for (var i = 0; i < _rutasAvatar.length; i++) ...[
              if (i > 0) const SizedBox(height: 14),
              _TarjetaNivel(
                indice: i,
                nivelRequerido: i + 1,
                desbloqueado: nivelActual >= i + 1,
                seleccionado: i == _nivelSeleccionado,
                onTap: nivelActual >= i + 1
                    ? () => setState(() => _nivelSeleccionado = i)
                    : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TarjetaNivel extends StatelessWidget {
  final int indice;
  final int nivelRequerido;
  final bool desbloqueado;
  final bool seleccionado;
  final VoidCallback? onTap;

  const _TarjetaNivel({
    required this.indice,
    required this.nivelRequerido,
    required this.desbloqueado,
    required this.seleccionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (nombre, comentario) = _infoNiveles[indice];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: seleccionado ? _colorDoradoXP : _colorBordeSuave,
            width: seleccionado ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: seleccionado ? _colorDoradoXP : _colorBordeSuave,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Opacity(
                  opacity: desbloqueado ? 1 : 0.35,
                  child: Image.asset(_rutasAvatar[indice], fit: BoxFit.cover),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        nombre,
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: desbloqueado ? _colorTextoPrincipal : _colorTextoSecundario,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Nivel $nivelRequerido',
                        style: GoogleFonts.inter(fontSize: 11, color: _colorTextoSecundario),
                      ),
                      if (!desbloqueado) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.lock_outline, size: 13, color: _colorTextoSecundario),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    comentario,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      height: 1.4,
                      color: _colorTextoSecundario,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
