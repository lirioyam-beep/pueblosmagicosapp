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

// Contenido real de Izamal — investigado y redactado a partir del
// documento "Contenido cultural ruta mágica" compartido por el equipo.
const List<String> _textosContenido = [
  // Historia
  'Izamal fue uno de los centros religiosos y políticos más importantes '
      'de la civilización maya. En su época de mayor esplendor contaba con '
      'al menos cinco grandes pirámides, razón por la cual los mayas la '
      'llamaban "Itzmal" — "ciudad de los cinco cerros" o "lugar del rocío '
      'del cielo". Muchas de esas estructuras fueron demolidas durante la '
      'conquista española para usar sus piedras en la construcción del '
      'Convento de San Antonio de Padua, levantado en 1553 por los frailes '
      'franciscanos.\n\n'
      'El fraile Diego de Landa, quien estableció aquí el primer convento '
      'franciscano de la península, se haría después tristemente famoso '
      'por el Auto de Fe de Maní, donde quemó códices mayas — aunque '
      'paradójicamente también documentó extensamente la cultura maya en '
      'su obra "Relación de las Cosas de Yucatán".\n\n'
      'El característico color amarillo que cubre todas las fachadas del '
      'pueblo no es una tradición prehispánica, sino colonial: según los '
      'registros, Izamal fue pintado de amarillo ocre en 1993 para recibir '
      'la visita del Papa Juan Pablo II. Desde entonces el amarillo se '
      'convirtió en la identidad visual del pueblo y una de las razones '
      'por las que fue nombrado Pueblo Mágico en 2002.',

  // Leyendas
  'Las Dos Hermanas\n'
      'Fray Diego de Landa trajo desde Guatemala dos imágenes idénticas de '
      'la Virgen, bautizadas como "Las Dos Hermanas": una quedó en Mérida '
      'y otra en Izamal. El 16 de abril de 1829 un incendio destruyó el '
      'altar del convento. Cuenta la leyenda que, mientras las llamas '
      'consumían el altar, el sacristán —un humilde indígena que solía '
      'platicar con la Virgen— escuchó su voz decirle: "Sálvame, soy la '
      'Virgen". Siguiendo una tenue luz, la llevó hasta una oquedad en el '
      'cerro de Kinich Kakmó, donde ambas encontraron refugio.\n\n'
      'Desde entonces, cada 8 de diciembre durante la madrugada, un '
      'agradable olor a flores recorre la calle que une el convento con '
      'la pirámide: señal de que las dos hermanas se intercambian de '
      'lugar. Nadie las ha visto, pero todos en Izamal lo sienten. Se dice '
      'que la oquedad donde se refugió la Virgen está custodiada hasta '
      'hoy por una enorme serpiente.\n\n'
      'La Esquina del Venado\n'
      'Un pordiosero dormía cada noche en el zaguán de la casa de Don '
      'Rodrigo Jesús de la Plata y Albornoz, hombre conocido por su '
      'dureza. Una mañana, su criado Gaspar le contó algo asombroso: '
      'donde dormía el mendigo había amanecido un hermoso venado, '
      'tranquilo como si fuera su casa. Se decía que el pordiosero había '
      'sido testigo, una noche de diciembre, del intercambio de las dos '
      'vírgenes de Izamal — y que, conmovidas por su sufrimiento, se '
      'llevaron su alma al cielo, quedando su espíritu en el venado.\n\n'
      'Desde ese día el carácter de Don Rodrigo cambió por completo: '
      'vendió sus bienes para ayudar al prójimo, y el venado nunca se '
      'separó de su lado. Al morir una mañana de diciembre, Gaspar lo '
      'encontró en paz — y a sus pies, el venado también había muerto, '
      'negándose a separarse de él ni en la muerte.',

  // Cultura
  'Izamal es el corazón espiritual de Yucatán: aquí se venera a la Virgen '
      'de Izamal, patrona oficial del estado, cuya imagen —tallada en el '
      'siglo XVI por el fraile franciscano Juan de Mérida— representa la '
      'fusión entre la espiritualidad maya y la fe católica que define la '
      'identidad yucateca hasta hoy. Cada 15 de agosto, miles de '
      'peregrinos llegan caminando desde distintas partes de Yucatán para '
      'su fiesta patronal.\n\n'
      'Antes de la conquista, el Cerro Kinich Kakmó era el centro '
      'religioso más importante del pueblo: los mayas peregrinaban desde '
      'lugares lejanos para ofrendar al dios solar y pedir curas para '
      'enfermedades. Y el mercado municipal sigue siendo hoy el corazón '
      'social de Izamal, donde conviven hierberos tradicionales, '
      'artesanos y vendedores de henequén — la fibra que fue la base '
      'económica de Yucatán y que se conoció como "el oro verde".\n\n'
      'Platillos típicos:\n'
      '• Papadzul — tortillas bañadas en salsa de pepita de calabaza, '
      'rellenas de huevo cocido; uno de los platillos más antiguos de la '
      'cocina yucateca.\n'
      '• Pollo en escabeche oriental — pollo deshebrado marinado en '
      'vinagre, cebolla morada y chile xcatic; infaltable en las '
      'reuniones familiares.\n'
      '• Tamales de chipilín — masa de maíz con hojas de chipilín, '
      'envueltos en hoja de plátano; una variante que casi no se '
      'encuentra fuera de Izamal.',

  // Recomendaciones
  'Kinich Restaurante\n'
      'Uno de los restaurantes más reconocidos de Izamal, especializado '
      'en cocina yucateca tradicional. Sirven cochinita pibil, pollo en '
      'escabeche, papadzules y sopa de lima en un ambiente de casa '
      'colonial con jardín. A media cuadra del convento, calle 27 entre '
      '28 y 26.\n\n'
      'El Toro\n'
      'Restaurante familiar conocido por sus porciones generosas y '
      'precios accesibles, con carnes asadas y platillos yucatecos del '
      'día. Popular entre los habitantes locales — garantía de '
      'autenticidad. Cerca del mercado municipal, en el centro del '
      'pueblo.\n\n'
      'Los Mestizos\n'
      'Local tradicional que sirve desayunos y comidas típicas desde '
      'temprano. Famoso por sus huevos motuleños y su sopa de lima '
      'casera. Ambiente sencillo y trato muy amable, en los portales del '
      'parque principal.',
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
  int get _lugaresDescubiertos => widget.pueblo.misiones
      .where((mision) => mision.descubierta || mision.completada)
      .length;

  bool _misionDescubierta(String id) {
    return widget.pueblo.misiones.any(
      (mision) => mision.id == id && (mision.descubierta || mision.completada),
    );
  }

  bool _pestanaDesbloqueada(int indice) {
    switch (indice) {
      case 0:
        return _lugaresDescubiertos > 0;
      case 1:
        return _misionDescubierta('izamal_mision_2');
      case 2:
        return _lugaresDescubiertos > 0;
      case 3:
        return _misionDescubierta('izamal_mision_3');
      default:
        return false;
    }
  }

  String _mensajeBloqueado(int indice) {
    switch (indice) {
      case 1:
        return 'Leyendas bloqueadas. Descubre el Cerro Kinich Kakmo para revelar esta parte de Izamal.';
      case 3:
        return 'Recomendaciones bloqueadas. Explora el mercado y la zona gastronomica para desbloquearlas.';
      default:
        return 'Contenido bloqueado. Explora al menos un punto del pueblo para revelar esta seccion.';
    }
  }

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
                  _buildResumenDescubrimiento(),
                  const SizedBox(height: 20),
                  _buildSegmentedControl(),
                  const SizedBox(height: 20),
                  _buildContenidoPestana(),
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

  Widget _buildResumenDescubrimiento() {
    final total = widget.pueblo.misiones.length;
    final progreso = total == 0 ? 0.0 : _lugaresDescubiertos / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _colorBordeSuave),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Descubrimientos',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _colorTextoPrincipal,
                  ),
                ),
                Text(
                  '$_lugaresDescubiertos/$total',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _colorPueblo,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progreso,
                minHeight: 8,
                backgroundColor: _colorBordeSuave,
                valueColor: AlwaysStoppedAnimation(_colorPueblo),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'La informacion cultural se desbloquea conforme visitas puntos reales del pueblo.',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: _colorTextoSecundario,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContenidoPestana() {
    final desbloqueada = _pestanaDesbloqueada(_pestanaSeleccionada);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: desbloqueada
            ? Text(
                _textosContenido[_pestanaSeleccionada],
                key: ValueKey('contenido-$_pestanaSeleccionada'),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  height: 1.5,
                  color: _colorTextoSecundario,
                ),
              )
            : Container(
                key: ValueKey('bloqueado-$_pestanaSeleccionada'),
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _colorBordeSuave),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.lock_outline, color: _colorTextoSecundario),
                    const SizedBox(height: 10),
                    Text(
                      _mensajeBloqueado(_pestanaSeleccionada),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.4,
                        color: _colorTextoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
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
          onPressed: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PuebloMapaScreen(pueblo: widget.pueblo),
              ),
            );
            // Refresca insignias/estado al volver de explorar/retos.
            if (mounted) setState(() {});
          },
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
