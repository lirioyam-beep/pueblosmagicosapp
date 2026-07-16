import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/mision.dart';
import '../utils/mision_utils.dart';

const Color _colorSuperficie = Color(0xFFFFFFFF);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorTerracotaActivo = Color(0xFFC1502E);

/// Tarjeta de una misión/reto dentro de retos_screen.dart.
/// Refleja el estado pendiente (terracota) / completada (verde) según
/// el sistema de tres estados de DESIGN.md. Las misiones de tipo
/// [TipoMision.ubicacion] además requieren que [cerca] sea true (por GPS
/// real o confirmación manual "Estoy aquí") antes de poder completarse.
class MisionCard extends StatelessWidget {
  final Mision mision;
  final Color colorPueblo;
  final VoidCallback onCompletar;
  final bool cerca;
  final double? distanciaMetros;
  final VoidCallback? onConfirmarUbicacion;
  final VoidCallback? onDescubrir;

  const MisionCard({
    super.key,
    required this.mision,
    required this.colorPueblo,
    required this.onCompletar,
    this.cerca = true,
    this.distanciaMetros,
    this.onConfirmarUbicacion,
    this.onDescubrir,
  });

  bool get _requiereUbicacion => mision.tipo == TipoMision.ubicacion;
  bool get _bloqueadaPorUbicacion =>
      _requiereUbicacion && !cerca && !mision.completada;

  @override
  Widget build(BuildContext context) {
    final completada = mision.completada;
    final descubierta = mision.descubierta || completada;
    final puedeDescubrir = !descubierta && cerca;
    final colorIcono = completada
        ? _colorVerdeCompletado
        : descubierta || cerca
            ? _colorTerracotaActivo
            : _colorTextoSecundario;
    final textoEstado = textoEstadoMision(mision, cerca: cerca);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: completada
            ? _colorVerdeCompletado.withValues(alpha: 0.08)
            : _colorSuperficie,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: completada ? _colorVerdeCompletado : _colorBordeSuave,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: colorIcono, shape: BoxShape.circle),
            child: Icon(
              completada
                  ? Icons.check
                  : descubierta || cerca
                      ? iconoPorTipoMision(mision.tipo)
                      : Icons.lock_outline,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mision.titulo,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _colorTextoPrincipal,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorIcono.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    textoEstado,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: colorIcono,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  descubierta
                      ? mision.descripcion
                      : 'Contenido bloqueado. Acercate al lugar para revelar su historia y activar el reto.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: _colorTextoSecundario,
                  ),
                ),
                const SizedBox(height: 8),
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
                if (_bloqueadaPorUbicacion) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.near_me_disabled,
                        size: 14,
                        color: _colorTextoSecundario,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          distanciaMetros != null
                              ? 'Acércate a ${mision.lugarFisico} (${distanciaMetros!.round()} m)'
                              : 'Acércate a ${mision.lugarFisico} para completar',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: _colorTextoSecundario,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: puedeDescubrir
                      ? ElevatedButton(
                          onPressed: onDescubrir,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorPueblo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Descubrir lugar',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : _bloqueadaPorUbicacion
                      ? OutlinedButton(
                          onPressed: onConfirmarUbicacion,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorPueblo,
                            side: BorderSide(color: colorPueblo),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Estoy aquí',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: completada ? null : onCompletar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                completada ? _colorVerdeCompletado : colorPueblo,
                            disabledBackgroundColor: _colorVerdeCompletado,
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            completada ? 'Completado' : 'Completar reto',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
