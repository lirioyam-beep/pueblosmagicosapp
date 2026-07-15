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
