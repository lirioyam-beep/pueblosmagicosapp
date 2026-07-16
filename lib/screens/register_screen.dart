import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../widgets/campo_texto_auth.dart';
import 'login_screen.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();
  final _confirmarController = TextEditingController();

  bool _cargando = false;

  @override
  void dispose() {
    _nombreController.dispose();
    _correoController.dispose();
    _contrasenaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _crearCuenta() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);
    try {
      await AuthService.instance.registrarConCorreo(
        nombre: _nombreController.text.trim(),
        correo: _correoController.text.trim(),
        contrasena: _contrasenaController.text,
      );
      if (!mounted) return;
      irABienvenidaTrasLogin(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AuthService.instance.mensajeError(e))),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorFondoCrema,
      appBar: AppBar(
        backgroundColor: _colorFondoCrema,
        elevation: 0,
        iconTheme: const IconThemeData(color: _colorTextoPrincipal),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Crea tu cuenta',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: _colorTextoPrincipal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Guarda tu progreso y tus insignias.',
                style: GoogleFonts.inter(fontSize: 14, color: _colorTextoSecundario),
              ),
              const SizedBox(height: 28),
              CampoTextoAuth(
                controller: _nombreController,
                etiqueta: 'Nombre',
                validador: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre' : null,
              ),
              const SizedBox(height: 16),
              CampoTextoAuth(
                controller: _correoController,
                etiqueta: 'Correo electrónico',
                tipoTeclado: TextInputType.emailAddress,
                validador: (v) {
                  if (v == null || v.trim().isEmpty) return 'Ingresa tu correo';
                  if (!v.contains('@')) return 'Correo no válido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CampoTextoAuth(
                controller: _contrasenaController,
                etiqueta: 'Contraseña',
                esPassword: true,
                validador: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa una contraseña';
                  if (v.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CampoTextoAuth(
                controller: _confirmarController,
                etiqueta: 'Confirmar contraseña',
                esPassword: true,
                validador: (v) {
                  if (v != _contrasenaController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _cargando ? null : _crearCuenta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colorDoradoXP,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: _cargando
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Crear cuenta',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _colorTextoSecundario,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
