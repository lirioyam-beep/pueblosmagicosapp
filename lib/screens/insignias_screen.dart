import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/pueblos_data.dart';
import '../models/insignia.dart';
import '../models/pueblo.dart';
import '../services/auth_service.dart';
import '../utils/color_utils.dart';
import '../utils/progreso_utils.dart';
import '../widgets/barra_navegacion_inferior.dart';
import '../widgets/insignia_badge.dart';
import 'login_screen.dart';
import 'niveles_screen.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorIconoBloqueado = Color(0xFFA89A85);

// XP necesaria por nivel — placeholder simple, sin backend todavía.
const int _xpPorNivel = 100;

class InsigniasScreen extends StatefulWidget {
  const InsigniasScreen({super.key});

  @override
  State<InsigniasScreen> createState() => _InsigniasScreenState();
}

class _InsigniasScreenState extends State<InsigniasScreen> {
  // Foto de perfil placeholder: un círculo de color liso por cada pueblo,
  // mientras el equipo de diseño entrega arte real. No se persiste todavía.
  int _puebloFotoSeleccionada = 0;

  Future<void> _elegirFotoPerfil() async {
    final indiceElegido = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Elige tu foto de perfil',
              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Un color por cada pueblo, mientras llega el arte definitivo.',
              style: GoogleFonts.inter(fontSize: 12, color: _colorTextoSecundario),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(pueblosData.length, (i) {
                final pueblo = pueblosData[i];
                final color = colorDesdeHex(pueblo.colorHex);
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(i),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: i == _puebloFotoSeleccionada
                                ? _colorTextoPrincipal
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 28),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        pueblo.nombre,
                        style: GoogleFonts.inter(fontSize: 12, color: _colorTextoPrincipal),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
    if (indiceElegido != null) {
      setState(() => _puebloFotoSeleccionada = indiceElegido);
    }
  }

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

  Future<void> _editarNombre(String nombreActual) async {
    final controller = TextEditingController(text: nombreActual);
    final nuevoNombre = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Editar nombre', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Tu nombre'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text.trim()),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    if (nuevoNombre == null || nuevoNombre.isEmpty) return;
    await AuthService.instance.actualizarNombre(nuevoNombre);
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
      bottomNavigationBar: const BarraNavegacionInferior(
        seccionActual: SeccionNav.perfil,
      ),
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
            GestureDetector(
              onTap: _elegirFotoPerfil,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: colorDesdeHex(pueblosData[_puebloFotoSeleccionada].colorHex),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 36),
                  ),
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: _colorBordeSuave),
                      ),
                      child: const Icon(Icons.edit, size: 14, color: _colorTextoSecundario),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nombreMostrado,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _colorTextoPrincipal,
                  ),
                ),
                if (sesionIniciada) ...[
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => _editarNombre(nombreMostrado),
                    child: const Icon(Icons.edit_outlined, size: 18, color: _colorTextoSecundario),
                  ),
                ],
              ],
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
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NivelesScreen()),
              ),
              icon: const Icon(Icons.military_tech_outlined, size: 18),
              label: const Text('Ver niveles'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _colorTextoPrincipal,
                side: const BorderSide(color: _colorBordeSuave),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
