import 'package:flutter/material.dart';
import '../models/mision.dart';

IconData iconoPorTipoMision(TipoMision tipo) {
  switch (tipo) {
    case TipoMision.ubicacion:
      return Icons.location_on;
    case TipoMision.trivia:
      return Icons.quiz;
    case TipoMision.gastronomica:
      return Icons.restaurant;
  }
}

String textoEstadoMision(Mision mision, {required bool cerca}) {
  if (mision.completada) return 'Completado';
  if (mision.descubierta) return 'Descubierto';
  if (cerca) return 'Cerca de ti';
  return 'Bloqueado';
}
