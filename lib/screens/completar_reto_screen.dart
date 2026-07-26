import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mision.dart';
import '../utils/mision_utils.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorRojoError = Color(0xFFB3423A);

/// Se abre al tocar "Completar reto" en retos_screen.dart. La interacción
/// depende del tipo de misión (trivia / ubicación / gastronómica).
/// Al terminar, hace pop(true) para que retos_screen marque la misión
/// como completada.
class CompletarRetoScreen extends StatelessWidget {
  final Mision mision;
  final Color colorPueblo;

  const CompletarRetoScreen({
    super.key,
    required this.mision,
    required this.colorPueblo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondoCrema,
      appBar: AppBar(
        backgroundColor: _colorFondoCrema,
        elevation: 0,
        iconTheme: IconThemeData(color: colorPueblo),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: switch (mision.tipo) {
            TipoMision.trivia => _RetoTrivia(mision: mision, colorPueblo: colorPueblo),
            TipoMision.ubicacion => _RetoUbicacion(mision: mision, colorPueblo: colorPueblo),
            TipoMision.gastronomica =>
              _RetoGastronomico(mision: mision, colorPueblo: colorPueblo),
          },
        ),
      ),
    );
  }
}

/// Encabezado compartido por los 3 tipos de reto: ícono, título y XP.
class _Encabezado extends StatelessWidget {
  final Mision mision;
  final Color colorPueblo;

  const _Encabezado({required this.mision, required this.colorPueblo});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(color: colorPueblo, shape: BoxShape.circle),
          child: Icon(iconoPorTipoMision(mision.tipo), color: Colors.white, size: 32),
        ),
        const SizedBox(height: 16),
        Text(
          mision.titulo,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: _colorTextoPrincipal,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: _colorDoradoXP, size: 16),
            const SizedBox(width: 4),
            Text(
              '+${mision.xpRecompensa} XP',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _colorDoradoXP,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

/// Trivia con opciones de respuesta. Para que no baste con tocar
/// cualquier opción para pasar, después de responder se muestra la
/// explicación y el botón "Continuar" queda deshabilitado unos segundos
/// mientras se supone que la lees.
class _RetoTrivia extends StatefulWidget {
  final Mision mision;
  final Color colorPueblo;

  const _RetoTrivia({required this.mision, required this.colorPueblo});

  @override
  State<_RetoTrivia> createState() => _RetoTriviaState();
}

class _RetoTriviaState extends State<_RetoTrivia> {
  static const _segundosLectura = 3;

  late final List<String> _opciones;
  String? _opcionElegida;
  int _segundosRestantes = _segundosLectura;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _opciones = List<String>.from(widget.mision.opcionesTrivia ?? [])..shuffle(Random());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool get _respondida => _opcionElegida != null;
  bool get _acerto => _opcionElegida == widget.mision.respuestaTrivia;

  void _elegir(String opcion) {
    if (_respondida) return;
    setState(() {
      _opcionElegida = opcion;
      _segundosRestantes = _segundosLectura;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_segundosRestantes <= 1) {
        t.cancel();
        setState(() => _segundosRestantes = 0);
      } else {
        setState(() => _segundosRestantes -= 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Encabezado(mision: widget.mision, colorPueblo: widget.colorPueblo),
            Text(
              widget.mision.preguntaTrivia ?? '',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: _colorTextoPrincipal,
              ),
            ),
            const SizedBox(height: 20),
            for (final opcion in _opciones) ...[
              _OpcionTrivia(
                texto: opcion,
                seleccionada: opcion == _opcionElegida,
                esCorrecta: opcion == widget.mision.respuestaTrivia,
                mostrarResultado: _respondida,
                colorPueblo: widget.colorPueblo,
                onTap: () => _elegir(opcion),
              ),
              const SizedBox(height: 10),
            ],
            if (_respondida) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _colorBordeSuave),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _acerto ? '¡Exacto! 🎉' : 'Casi — la próxima la tendrás.',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: _acerto ? _colorVerdeCompletado : _colorRojoError,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.mision.contenidoDescubrimiento.isNotEmpty
                          ? widget.mision.contenidoDescubrimiento
                          : 'La respuesta correcta era: ${widget.mision.respuestaTrivia}.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        height: 1.5,
                        color: _colorTextoSecundario,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _segundosRestantes > 0
                      ? null
                      : () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.colorPueblo,
                    disabledBackgroundColor: _colorBordeSuave,
                    foregroundColor: Colors.white,
                    disabledForegroundColor: _colorTextoSecundario,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: Text(
                    _segundosRestantes > 0 ? 'Continuar ($_segundosRestantes)' : 'Continuar',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OpcionTrivia extends StatelessWidget {
  final String texto;
  final bool seleccionada;
  final bool esCorrecta;
  final bool mostrarResultado;
  final Color colorPueblo;
  final VoidCallback onTap;

  const _OpcionTrivia({
    required this.texto,
    required this.seleccionada,
    required this.esCorrecta,
    required this.mostrarResultado,
    required this.colorPueblo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color colorBorde = _colorBordeSuave;
    Color colorFondo = Colors.white;
    IconData? icono;

    if (mostrarResultado) {
      if (esCorrecta) {
        colorBorde = _colorVerdeCompletado;
        colorFondo = _colorVerdeCompletado.withValues(alpha: 0.08);
        icono = Icons.check_circle;
      } else if (seleccionada) {
        colorBorde = _colorRojoError;
        colorFondo = _colorRojoError.withValues(alpha: 0.08);
        icono = Icons.cancel;
      }
    } else if (seleccionada) {
      colorBorde = colorPueblo;
    }

    return Material(
      color: colorFondo,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: mostrarResultado ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colorBorde, width: seleccionada ? 2 : 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  texto,
                  style: GoogleFonts.inter(fontSize: 14, color: _colorTextoPrincipal),
                ),
              ),
              if (icono != null) Icon(icono, color: colorBorde, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

/// Confirmación de visita para misiones de ubicación — ya se validó que
/// el usuario está cerca (GPS o "Estoy aquí") antes de llegar aquí.
class _RetoUbicacion extends StatelessWidget {
  final Mision mision;
  final Color colorPueblo;

  const _RetoUbicacion({required this.mision, required this.colorPueblo});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _Encabezado(mision: mision, colorPueblo: colorPueblo),
                  Text(
                    'Sella tu visita a ${mision.lugarFisico} para guardar el recuerdo '
                    'en tu ruta.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: _colorTextoSecundario,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.approval_outlined),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPueblo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              label: Text(
                'Sellar mi visita',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Confirmación para misiones gastronómicas.
class _RetoGastronomico extends StatelessWidget {
  final Mision mision;
  final Color colorPueblo;

  const _RetoGastronomico({required this.mision, required this.colorPueblo});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _Encabezado(mision: mision, colorPueblo: colorPueblo),
                  Text(
                    '¿Ya probaste lo típico de ${mision.lugarFisico}?',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      height: 1.5,
                      color: _colorTextoSecundario,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(true),
              icon: const Icon(Icons.restaurant),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorPueblo,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                elevation: 0,
              ),
              label: Text(
                '¡Sí, delicioso!',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
