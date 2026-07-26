import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pueblo.dart';
import '../utils/color_utils.dart';
import '../utils/contenido_cultural_utils.dart';
import '../widgets/barra_navegacion_inferior.dart';
import 'categoria_cultural_screen.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorIconoBloqueado = Color(0xFFA89A85);

const List<String> _teasersPestanas = [
  'La historia real detrás de este pueblo mágico.',
  'Leyendas contadas por generaciones — resuélvelas como un juego.',
  'Tradiciones, platillos y fiestas que le dan vida al pueblo.',
  'Lugares para comer y pasear, calculados según dónde estés.',
];

/// Puerta de entrada a Historia/Leyendas/Cultura/Recomendaciones — se
/// navega entre las 4 categorías como historias de Instagram (deslizando)
/// y tocar una te lleva a su propia pantalla dedicada en
/// categoria_cultural_screen.dart (cada categoría vive separada).
class MenuCulturalScreen extends StatefulWidget {
  final Pueblo pueblo;

  const MenuCulturalScreen({super.key, required this.pueblo});

  @override
  State<MenuCulturalScreen> createState() => _MenuCulturalScreenState();
}

class _MenuCulturalScreenState extends State<MenuCulturalScreen> {
  final _controladorPagina = PageController(viewportFraction: 0.82);
  int _paginaActual = 0;

  @override
  void dispose() {
    _controladorPagina.dispose();
    super.dispose();
  }

  Color get _colorPueblo => colorDesdeHex(widget.pueblo.colorHex);

  Future<void> _abrirPestana(int indice) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoriaCulturalScreen(pueblo: widget.pueblo, categoriaIndice: indice),
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondoCrema,
      bottomNavigationBar: BarraNavegacionInferior(
        seccionActual: SeccionNav.cultura,
        pueblo: widget.pueblo,
      ),
      appBar: AppBar(
        backgroundColor: _colorFondoCrema,
        elevation: 0,
        iconTheme: IconThemeData(color: _colorPueblo),
        title: Text(
          widget.pueblo.nombre,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: _colorTextoPrincipal,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Text(
            'Desliza para descubrir',
            style: GoogleFonts.inter(fontSize: 13, color: _colorTextoSecundario),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PageView.builder(
              controller: _controladorPagina,
              itemCount: nombresPestanasCultural.length,
              onPageChanged: (indice) => setState(() => _paginaActual = indice),
              itemBuilder: (context, indice) {
                final desbloqueada = pestanaCulturalDesbloqueada(widget.pueblo, indice);
                return AnimatedBuilder(
                  animation: _controladorPagina,
                  builder: (context, child) {
                    double escala = 1;
                    if (_controladorPagina.position.haveDimensions) {
                      final desplazamiento =
                          (_controladorPagina.page ?? _paginaActual.toDouble()) - indice;
                      escala = (1 - (desplazamiento.abs() * 0.15)).clamp(0.85, 1.0);
                    }
                    return Transform.scale(scale: escala, child: child);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _TarjetaCategoria(
                      nombre: nombresPestanasCultural[indice],
                      icono: iconosPestanasCultural[indice],
                      teaser: _teasersPestanas[indice],
                      desbloqueada: desbloqueada,
                      colorPueblo: _colorPueblo,
                      onTap: () => _abrirPestana(indice),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(nombresPestanasCultural.length, (i) {
              final activo = i == _paginaActual;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: activo ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: activo ? _colorPueblo : _colorBordeSuave,
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _TarjetaCategoria extends StatelessWidget {
  final String nombre;
  final IconData icono;
  final String teaser;
  final bool desbloqueada;
  final Color colorPueblo;
  final VoidCallback onTap;

  const _TarjetaCategoria({
    required this.nombre,
    required this.icono,
    required this.teaser,
    required this.desbloqueada,
    required this.colorPueblo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorFondo = desbloqueada ? colorPueblo : _colorIconoBloqueado;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _colorBordeSuave),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 84,
                height: 84,
                decoration: BoxDecoration(color: colorFondo, shape: BoxShape.circle),
                child: Icon(
                  desbloqueada ? icono : Icons.lock_outline,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                nombre,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: _colorTextoPrincipal,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                desbloqueada ? teaser : 'Bloqueado — descubre más lugares del pueblo para revelarlo.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.4,
                  color: _colorTextoSecundario,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: colorFondo.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  desbloqueada ? 'Toca para entrar' : 'Bloqueado',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colorFondo,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
