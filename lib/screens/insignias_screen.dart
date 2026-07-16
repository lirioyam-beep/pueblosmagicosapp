import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/pueblos_data.dart';
import '../models/insignia.dart';
import '../models/pueblo.dart';
import '../services/auth_service.dart';
import '../utils/color_utils.dart';
import '../utils/progreso_utils.dart';
import '../widgets/insignia_badge.dart';
import 'login_screen.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorIconoBloqueado = Color(0xFFA89A85);

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

  Future<void> _irALogin() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    if (mounted) setState(() {});
  }

  Future<void> _cerrarSesion() async {
    await AuthService.instance.cerrarSesion();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final xpTotal = calcularXpTotal(pueblosData);
    final nivel = (xpTotal ~/ _xpPorNivel) + 1;
    final progresoNivel = (xpTotal % _xpPorNivel) / _xpPorNivel;
    final usuario = AuthService.instance.usuarioActual;
    final sesionIniciada = usuario != null;
    final nombreMostrado = usuario?.displayName?.isNotEmpty == true
        ? usuario!.displayName!
        : (usuario?.email ?? 'Turista');

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
              nombreMostrado,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: _colorTextoPrincipal,
              ),
            ),
            if (sesionIniciada && usuario.email != null) ...[
              const SizedBox(height: 2),
              Text(
                usuario.email!,
                style: GoogleFonts.inter(fontSize: 13, color: _colorTextoSecundario),
              ),
            ],
            const SizedBox(height: 8),
            TextButton(
              onPressed: sesionIniciada ? _cerrarSesion : _irALogin,
              child: Text(
                sesionIniciada ? 'Cerrar sesión' : 'Iniciar sesión',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _colorDoradoXP,
                ),
              ),
            ),
            const SizedBox(height: 12),
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
            const _SeccionRuta(),
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

/// Resumen de progreso por pueblo — cuántas misiones llevas de cuántas,
/// o si el pueblo sigue bloqueado.
class _SeccionRuta extends StatelessWidget {
  const _SeccionRuta();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tu ruta',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _colorTextoPrincipal,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _colorBordeSuave),
          ),
          child: Column(
            children: [
              for (var i = 0; i < pueblosData.length; i++) ...[
                if (i > 0) Divider(height: 1, color: _colorBordeSuave),
                _FilaPueblo(pueblo: pueblosData[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _FilaPueblo extends StatelessWidget {
  final Pueblo pueblo;

  const _FilaPueblo({required this.pueblo});

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
        textoEstado = total > 0 ? '$completadas/$total misiones' : 'En progreso';
      case EstadoPueblo.bloqueado:
        colorEstado = _colorIconoBloqueado;
        icono = Icons.lock;
        textoEstado = 'Bloqueado';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: colorEstado, shape: BoxShape.circle),
            child: Icon(icono, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              pueblo.nombre,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _colorTextoPrincipal,
              ),
            ),
          ),
          Text(
            textoEstado,
            style: GoogleFonts.inter(fontSize: 12, color: _colorTextoSecundario),
          ),
        ],
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
