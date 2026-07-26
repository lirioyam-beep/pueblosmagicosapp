import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);

/// Campo de texto estilizado para las pantallas de login/registro.
/// Cuando [esPassword] es true, incluye un ícono de "ojito" para
/// mostrar/ocultar la contraseña.
class CampoTextoAuth extends StatefulWidget {
  final TextEditingController controller;
  final String etiqueta;
  final bool esPassword;
  final TextInputType? tipoTeclado;
  final String? Function(String?) validador;
  final ValueChanged<String>? onChanged;

  const CampoTextoAuth({
    super.key,
    required this.controller,
    required this.etiqueta,
    required this.validador,
    this.esPassword = false,
    this.tipoTeclado,
    this.onChanged,
  });

  @override
  State<CampoTextoAuth> createState() => _CampoTextoAuthState();
}

class _CampoTextoAuthState extends State<CampoTextoAuth> {
  bool _ocultarTexto = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.esPassword && _ocultarTexto,
      keyboardType: widget.tipoTeclado,
      validator: widget.validador,
      onChanged: widget.onChanged,
      style: GoogleFonts.inter(fontSize: 15, color: _colorTextoPrincipal),
      decoration: InputDecoration(
        labelText: widget.etiqueta,
        labelStyle: GoogleFonts.inter(color: _colorTextoSecundario),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: widget.esPassword
            ? IconButton(
                icon: Icon(
                  _ocultarTexto ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: _colorTextoSecundario,
                ),
                tooltip: _ocultarTexto ? 'Mostrar contraseña' : 'Ocultar contraseña',
                onPressed: () => setState(() => _ocultarTexto = !_ocultarTexto),
              )
            : null,
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
