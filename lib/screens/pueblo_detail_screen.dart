import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/pueblo.dart';
import '../utils/color_utils.dart';
import '../widgets/insignia_badge.dart';
import 'pueblo_mapa_screen.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorTerracotaActivo = Color(0xFFC1502E);

const List<String> _nombresPestanas = [
  'Historia',
  'Leyendas',
  'Cultura',
  'Recomendaciones',
];

const List<String> _textosPlaceholder = [
  'Aquí irá la historia real de este pueblo: su fundación, épocas '
      'importantes y cómo llegó a convertirse en Pueblo Mágico. '
      'Contenido pendiente de redactar.',
  'Aquí irán las leyendas y relatos tradicionales que se cuentan sobre '
      'este lugar, transmitidos de generación en generación. '
      'Contenido pendiente de redactar.',
  'Aquí se describirán las tradiciones, fiestas, artesanías y '
      'costumbres vivas que forman parte de la cultura de este pueblo. '
      'Contenido pendiente de redactar.',
  'Aquí aparecerán recomendaciones de lugares para comer, hospedarse '
      'y actividades imperdibles durante la visita. '
      'Contenido pendiente de redactar.',
];

class PuebloDetailScreen extends StatefulWidget {
  final Pueblo pueblo;

  const PuebloDetailScreen({super.key, required this.pueblo});

  @override
  State<PuebloDetailScreen> createState() => _PuebloDetailScreenState();
}

class _PuebloDetailScreenState extends State<PuebloDetailScreen> {
  int _pestanaSeleccionada = 0;

  Color get _colorPueblo => colorDesdeHex(widget.pueblo.colorHex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondoCrema,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: _colorPueblo,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBanner(),
                  const SizedBox(height: 20),
                  _buildSegmentedControl(),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      _textosPlaceholder[_pestanaSeleccionada],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        height: 1.5,
                        color: _colorTextoSecundario,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  _buildSeccionInsignias(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          _buildBotonExplorar(context),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 200,
      color: _colorPueblo,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _colorVerdeCompletado,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Pueblo Mágico',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.pueblo.nombre,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: List.generate(_nombresPestanas.length, (i) {
          final activa = i == _pestanaSeleccionada;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => setState(() => _pestanaSeleccionada = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: activa ? _colorTerracotaActivo : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: activa ? _colorTerracotaActivo : _colorBordeSuave,
                  ),
                ),
                child: Text(
                  _nombresPestanas[i],
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: activa ? Colors.white : _colorTextoSecundario,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSeccionInsignias() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Insignias',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: _colorTextoPrincipal,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.pueblo.insignias
                .map((insignia) => InsigniaBadge(insignia: insignia))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBotonExplorar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PuebloMapaScreen(pueblo: widget.pueblo),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: _colorPueblo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 0,
          ),
          child: Text(
            'Explorar ${widget.pueblo.nombre}',
            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
