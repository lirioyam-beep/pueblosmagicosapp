import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mision.dart';
import '../models/pueblo.dart';
import '../services/exploracion_controller.dart';
import '../services/location_service.dart';
import '../utils/color_utils.dart';
import '../widgets/mision_card.dart';
import 'pueblo_mapa_screen.dart';

const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);

class RetosScreen extends StatefulWidget {
  final Pueblo pueblo;

  const RetosScreen({super.key, required this.pueblo});

  @override
  State<RetosScreen> createState() => _RetosScreenState();
}

class _RetosScreenState extends State<RetosScreen> {
  final LocationService _locationService = LocationService();
  StreamSubscription<Position>? _suscripcionPosicion;

  Position? _posicionActual;
  EstadoUbicacion _estadoUbicacion = EstadoUbicacion.servicioDesactivado;
  final Set<String> _confirmadasManualmente = {};

  Color get _colorPueblo => colorDesdeHex(widget.pueblo.colorHex);

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

  bool _misionCerca(Mision mision) {
    if (mision.tipo != TipoMision.ubicacion) return true;
    if (_confirmadasManualmente.contains(mision.id)) return true;
    if (_posicionActual == null) return false;
    return _locationService.estaCercaDeMision(_posicionActual!, mision);
  }

  double? _distanciaAMision(Mision mision) {
    if (_posicionActual == null) return null;
    return _locationService.distanciaAMision(_posicionActual!, mision);
  }

  void _completarMision(Mision mision) {
    setState(() => mision.completada = true);
  }

  void _confirmarUbicacionManual(Mision mision) {
    setState(() => _confirmadasManualmente.add(mision.id));
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
          'Retos de ${widget.pueblo.nombre}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: _colorTextoPrincipal,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Ver mapa',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PuebloMapaScreen(pueblo: widget.pueblo),
              ),
            ),
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
      body: Column(
        children: [
          if (sinGps)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
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
                      'No detectamos tu ubicación. Usa "Estoy aquí" en cada '
                      'reto para confirmar manualmente.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _colorTextoSecundario,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: widget.pueblo.misiones.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final mision = widget.pueblo.misiones[index];
                return MisionCard(
                  mision: mision,
                  colorPueblo: _colorPueblo,
                  cerca: _misionCerca(mision),
                  distanciaMetros: _distanciaAMision(mision),
                  onCompletar: () => _completarMision(mision),
                  onConfirmarUbicacion: () => _confirmarUbicacionManual(mision),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
