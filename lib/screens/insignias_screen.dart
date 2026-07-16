import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/pueblos_data.dart';
import '../models/insignia.dart';
import '../utils/progreso_utils.dart';
import '../widgets/insignia_badge.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorDoradoXP = Color(0xFFD9A441);

const List<String> _rutasAvatar = [
  'assets/avatares/avatar_1v.png',
  'assets/avatares/avatar_2v.png',
  'assets/avatares/avatar_3v.png',
];

// XP necesaria por nivel — placeholder simple, sin backend todavía.
const int _xpPorNivel = 100;

class InsigniasScreen extends StatefulWidget {
  const InsigniasScreen({super.key});

  @override
  State<InsigniasScreen> createState() => _InsigniasScreenState();
}

class _InsigniasScreenState extends State<InsigniasScreen> {
  int _avatarSeleccionado = 0;

  @override
  Widget build(BuildContext context) {
    final xpTotal = calcularXpTotal(pueblosData);
    final nivel = (xpTotal ~/ _xpPorNivel) + 1;
    final progresoNivel = (xpTotal % _xpPorNivel) / _xpPorNivel;

    return Scaffold(
      backgroundColor: _colorFondoCrema,
      appBar: AppBar(
        backgroundColor: _colorFondoCrema,
        elevation: 0,
        iconTheme: const IconThemeData(color: _colorTextoPrincipal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_rutasAvatar.length, (i) {
                final seleccionado = i == _avatarSeleccionado;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _avatarSeleccionado = i),
                    child: Container(
                      width: 64,
                      height: 64,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: seleccionado ? _colorDoradoXP : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(_rutasAvatar[i], fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Text(
              'Turista',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _colorTextoPrincipal,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _colorBordeSuave),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nivel $nivel',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _colorTextoPrincipal,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: _colorDoradoXP, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '$xpTotal XP',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _colorDoradoXP,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progresoNivel,
                      minHeight: 8,
                      backgroundColor: _colorBordeSuave,
                      valueColor: const AlwaysStoppedAnimation(_colorDoradoXP),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            _SeccionInsignias(titulo: 'Insignias de Izamal', insignias: insigniasIzamal),
            const SizedBox(height: 24),
            _SeccionInsignias(titulo: 'Insignias generales', insignias: insigniasGenerales),
          ],
        ),
      ),
    );
  }
}

class _SeccionInsignias extends StatelessWidget {
  final String titulo;
  final List<Insignia> insignias;

  const _SeccionInsignias({required this.titulo, required this.insignias});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _colorTextoPrincipal,
          ),
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final insignia in insignias) InsigniaBadge(insignia: insignia),
          ],
        ),
      ],
    );
  }
}
