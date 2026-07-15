import 'package:flutter/material.dart';

/// Convierte un color hexadecimal ej: "#D4A017" a [Color].
Color colorDesdeHex(String hex) {
  final valor = hex.replaceFirst('#', '');
  return Color(int.parse('ff$valor', radix: 16));
}
