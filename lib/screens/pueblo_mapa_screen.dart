import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart' as latlong;
import '../models/mision.dart';
import '../models/pueblo.dart';
import '../services/exploracion_controller.dart';
import '../services/location_service.dart';
import '../utils/color_utils.dart';
import '../utils/mision_utils.dart';
import 'retos_screen.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorTerracotaActivo = Color(0xFFC1502E);
const Color _colorAzulUsuario = Color(0xFF2E6FDB);

/// Mapa geográfico real del pueblo (flutter_map + OpenStreetMap), distinto
/// del mapa-selector estilo videojuego de map_screen.dart. Muestra la
/// posición del usuario en vivo y un marcador por cada misión, para
/// orientarse durante el recorrido. Ver CONTEXT.md y FEATURES.md.
class PuebloMapaScreen extends StatefulWidget {
  final Pueblo pueblo;

  const PuebloMapaScreen({super.key, required this.pueblo});

  @override
  State<PuebloMapaScreen> createState() => _PuebloMapaScreenState();
}

class _PuebloMapaScreenState extends State<PuebloMapaScreen> {
  final LocationService _locationService = LocationService();
  final MapController _mapController = MapController();
  StreamSubscription<Position>? _suscripcionPosicion;

  Position? _posicionActual;
  EstadoUbicacion _estadoUbicacion = EstadoUbicacion.servicioDesactivado;

  Color get _colorPueblo => colorDesdeHex(widget.pueblo.colorHex);

  latlong.LatLng get _centroPueblo =>
      latlong.LatLng(widget.pueblo.latitud, widget.pueblo.longitud);

  // Placeholder: XP ganada en este pueblo durante la sesión (sin backend
  // ni estado global todavía — se calcula sumando las misiones completadas).
  int get _xpGanada => widget.pueblo.misiones
      .where((m) => m.completada)
      .fold(0, (suma, m) => suma + m.xpRecompensa);

  @override
  void initState() {
    super.initState();
    _iniciarUbicacion();
    ExploracionController.instance.activarPueblo(widget.pueblo);
  }

  @override
  void dispose() {
    _suscripcionPosicion?.cancel();
    super.dispose();
  }

  Future<void> _iniciarUbicacion() async {
    final (posicion, estado) = await _locationService.obtenerPosicionActual();
    if (!mounted) return;
    setState(() {
      _posicionActual = posicion;
      _estadoUbicacion = estado;
    });

    if (estado == EstadoUbicacion.disponible) {
      _suscripcionPosicion = _locationService.posicionEnVivo().listen((posicion) {
        if (mounted) setState(() => _posicionActual = posicion);
      });
    }
  }

  void _centrarEnUsuario() {
    if (_posicionActual == null) return;
    _mapController.move(
      latlong.LatLng(_posicionActual!.latitude, _posicionActual!.longitude),
      17,
    );
  }

  void _mostrarMision(Mision mision) {
    double? distancia;
    if (_posicionActual != null) {
      distancia = _locationService.distanciaAMision(_posicionActual!, mision);
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _HojaMision(
        mision: mision,
        colorPueblo: _colorPueblo,
        distanciaMetros: distancia,
      ),
    );
  }

  List<Marker> _construirMarcadores() {
    final marcadores = <Marker>[
      for (final mision in widget.pueblo.misiones)
        Marker(
          point: latlong.LatLng(mision.latitud, mision.longitud),
          width: 44,
          height: 44,
          child: GestureDetector(
            onTap: () => _mostrarMision(mision),
            child: _MarcadorMision(mision: mision),
          ),
        ),
    ];

    if (_posicionActual != null) {
      marcadores.add(
        Marker(
          point: latlong.LatLng(_posicionActual!.latitude, _posicionActual!.longitude),
          width: 24,
          height: 24,
          child: Container(
            decoration: BoxDecoration(
              color: _colorAzulUsuario,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: _colorAzulUsuario.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return marcadores;
  }

  @override
  Widget build(BuildContext context) {
    final sinGps = _estadoUbicacion != EstadoUbicacion.disponible;

    return Scaffold(
      backgroundColor: _colorFondoCrema,
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
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt_outlined),
            tooltip: 'Ver lista de retos',
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => RetosScreen(pueblo: widget.pueblo),
                ),
              );
              // Refresca marcadores/XP al volver de la lista de retos.
              if (mounted) setState(() {});
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _colorBordeSuave),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: _colorDoradoXP, size: 16),
                const SizedBox(width: 4),
                Text(
                  '$_xpGanada',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: _colorTextoPrincipal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _posicionActual != null
                  ? latlong.LatLng(_posicionActual!.latitude, _posicionActual!.longitude)
                  : _centroPueblo,
              initialZoom: 15,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.pueblosmagicosapp',
              ),
              MarkerLayer(markers: _construirMarcadores()),
            ],
          ),
          if (sinGps)
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _colorBordeSuave),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_off, size: 18, color: _colorTextoSecundario),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'No detectamos tu ubicación. Mostrando el centro del pueblo.',
                        style: GoogleFonts.inter(fontSize: 12, color: _colorTextoSecundario),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: _colorPueblo,
              onPressed: _posicionActual == null ? null : _centrarEnUsuario,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _MarcadorMision extends StatelessWidget {
  final Mision mision;

  const _MarcadorMision({required this.mision});

  @override
  Widget build(BuildContext context) {
    final colorFondo = mision.completada ? _colorVerdeCompletado : _colorTerracotaActivo;
    final icono = mision.completada ? Icons.check : iconoPorTipoMision(mision.tipo);

    return Container(
      decoration: BoxDecoration(
        color: colorFondo,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(icono, color: Colors.white, size: 20),
    );
  }
}

class _HojaMision extends StatelessWidget {
  final Mision mision;
  final Color colorPueblo;
  final double? distanciaMetros;

  const _HojaMision({
    required this.mision,
    required this.colorPueblo,
    this.distanciaMetros,
  });

  @override
  Widget build(BuildContext context) {
    final completada = mision.completada;
    final colorEstado = completada ? _colorVerdeCompletado : colorPueblo;

    String textoDistancia;
    if (completada) {
      textoDistancia = 'Reto completado';
    } else if (distanciaMetros == null) {
      textoDistancia = 'Distancia desconocida';
    } else if (distanciaMetros! <= mision.radioMetros) {
      textoDistancia = 'Estás aquí';
    } else {
      textoDistancia = 'A ${distanciaMetros!.round()} m de ti';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: colorEstado, shape: BoxShape.circle),
                child: Icon(
                  completada ? Icons.check : iconoPorTipoMision(mision.tipo),
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mision.titulo,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _colorTextoPrincipal,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            mision.descripcion,
            style: GoogleFonts.inter(fontSize: 13, color: _colorTextoSecundario),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.place, size: 16, color: _colorTextoSecundario),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${mision.lugarFisico} · $textoDistancia',
                  style: GoogleFonts.inter(fontSize: 12, color: _colorTextoSecundario),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.star, color: _colorDoradoXP, size: 16),
              const SizedBox(width: 4),
              Text(
                '+${mision.xpRecompensa} XP',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _colorDoradoXP,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
