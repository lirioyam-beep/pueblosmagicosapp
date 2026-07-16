import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);

/// Campo de texto estilizado para las pantallas de login/registro.
class CampoTextoAuth extends StatelessWidget {
  final TextEditingController controller;
  final String etiqueta;
  final bool esPassword;
  final TextInputType? tipoTeclado;
  final String? Function(String?) validador;

  const CampoTextoAuth({
    super.key,
    required this.controller,
    required this.etiqueta,
    required this.validador,
    this.esPassword = false,
    this.tipoTeclado,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: esPassword,
      keyboardType: tipoTeclado,
      validator: validador,
      style: GoogleFonts.inter(fontSize: 15, color: _colorTextoPrincipal),
      decoration: InputDecoration(
        labelText: etiqueta,
        labelStyle: GoogleFonts.inter(color: _colorTextoSecundario),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _colorBordeSuave),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _colorBordeSuave),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _colorDoradoXP, width: 2),
        ),
      ),
    );
  }
}
