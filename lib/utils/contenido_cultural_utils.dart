import 'package:flutter/material.dart';
import '../models/pueblo.dart';

/// Las 4 secciones de contenido cultural de un pueblo — mismo orden en
/// categoria_cultural_screen.dart y en menu_cultural_screen.dart.
const List<String> nombresPestanasCultural = [
  'Historia',
  'Leyendas',
  'Cultura',
  'Recomendaciones',
];

/// Un ícono por sección, en el mismo orden que [nombresPestanasCultural].
const List<IconData> iconosPestanasCultural = [
  Icons.menu_book_outlined,
  Icons.auto_stories_outlined,
  Icons.festival_outlined,
  Icons.restaurant_outlined,
];

int lugaresDescubiertos(Pueblo pueblo) => pueblo.misiones
    .where((mision) => mision.descubierta || mision.completada)
    .length;

bool misionDescubierta(Pueblo pueblo, String id) {
  return pueblo.misiones.any(
    (mision) => mision.id == id && (mision.descubierta || mision.completada),
  );
}

/// Historia y Cultura se revelan al descubrir cualquier punto del pueblo;
/// Leyendas y Recomendaciones dependen de una misión específica (la 2a y
/// 3a de cada pueblo, respectivamente).
bool pestanaCulturalDesbloqueada(Pueblo pueblo, int indice) {
  switch (indice) {
    case 0:
      return lugaresDescubiertos(pueblo) > 0;
    case 1:
      return misionDescubierta(pueblo, '${pueblo.id}_mision_2');
    case 2:
      return lugaresDescubiertos(pueblo) > 0;
    case 3:
      return misionDescubierta(pueblo, '${pueblo.id}_mision_3');
    default:
      return false;
  }
}
