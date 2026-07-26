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
const Color _colorVerdeCompletado = Color(0xFF3F6F52);
const Color _colorRojoError = Color(0xFFB3423A);

/// Reglas mínimas de contraseña — ver checklist en la pantalla de registro.
final RegExp _reMayuscula = RegExp(r'[A-Z]');
final RegExp _reMinuscula = RegExp(r'[a-z]');
final RegExp _reNumero = RegExp(r'[0-9]');
final RegExp _reSimbolo = RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=\[\];/\\~`]');

String? _validarContrasena(String? v) {
  if (v == null || v.isEmpty) return 'Ingresa una contraseña';
  if (v.length < 6) return 'Mínimo 6 caracteres';
  if (!_reMayuscula.hasMatch(v)) return 'Falta una letra mayúscula';
  if (!_reMinuscula.hasMatch(v)) return 'Falta una letra minúscula';
  if (!_reNumero.hasMatch(v)) return 'Falta un número';
  if (!_reSimbolo.hasMatch(v)) return 'Falta un símbolo (ej. !@#\$%)';
  return null;
}

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
                validador: _validarContrasena,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              _ChecklistContrasena(contrasena: _contrasenaController.text),
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
                onChanged: (_) => setState(() {}),
              ),
              if (_confirmarController.text.isNotEmpty) ...[
                const SizedBox(height: 8),
                _IndicadorCoincidencia(
                  coinciden: _confirmarController.text == _contrasenaController.text,
                ),
              ],
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

/// Lista de requisitos de la contraseña — cada uno se marca en verde
/// conforme se va cumpliendo mientras el usuario escribe.
class _ChecklistContrasena extends StatelessWidget {
  final String contrasena;

  const _ChecklistContrasena({required this.contrasena});

  @override
  Widget build(BuildContext context) {
    final requisitos = [
      ('Mínimo 6 caracteres', contrasena.length >= 6),
      ('Una letra mayúscula', _reMayuscula.hasMatch(contrasena)),
      ('Una letra minúscula', _reMinuscula.hasMatch(contrasena)),
      ('Un número', _reNumero.hasMatch(contrasena)),
      ('Un símbolo (ej. ! @ # \$)', _reSimbolo.hasMatch(contrasena)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (texto, cumplido) in requisitos)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(
                  cumplido ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 16,
                  color: cumplido ? _colorVerdeCompletado : _colorTextoSecundario,
                ),
                const SizedBox(width: 8),
                Text(
                  texto,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: cumplido ? _colorVerdeCompletado : _colorTextoSecundario,
                    fontWeight: cumplido ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Indica si "Confirmar contraseña" coincide con la contraseña escrita.
class _IndicadorCoincidencia extends StatelessWidget {
  final bool coinciden;

  const _IndicadorCoincidencia({required this.coinciden});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          coinciden ? Icons.check_circle : Icons.error_outline,
          size: 16,
          color: coinciden ? _colorVerdeCompletado : _colorRojoError,
        ),
        const SizedBox(width: 8),
        Text(
          coinciden ? 'Las contraseñas coinciden' : 'Las contraseñas no coinciden',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            color: coinciden ? _colorVerdeCompletado : _colorRojoError,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
