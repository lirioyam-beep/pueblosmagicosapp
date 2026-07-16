import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../widgets/campo_texto_auth.dart';
import 'insignias_screen.dart';
import 'register_screen.dart';

/// Tras iniciar sesión con éxito, limpia login/registro de la pila y
/// lleva directo al perfil — así el usuario ve de inmediato que ya
/// quedó dentro de su cuenta, sin quedarse varado en la splash.
void irAlPerfilTrasLogin(BuildContext context) {
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => const InsigniasScreen()),
    (route) => route.isFirst,
  );
}

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorBordeSuave = Color(0xFFEFE2C8);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorTextoSecundario = Color(0xFF7A6353);
const Color _colorDoradoXP = Color(0xFFD9A441);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correoController = TextEditingController();
  final _contrasenaController = TextEditingController();

  bool _cargando = false;

  @override
  void dispose() {
    _correoController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> _iniciarSesion() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _cargando = true);
    try {
      await AuthService.instance.iniciarSesionConCorreo(
        correo: _correoController.text.trim(),
        contrasena: _contrasenaController.text,
      );
      if (!mounted) return;
      irAlPerfilTrasLogin(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AuthService.instance.mensajeError(e))),
      );
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  Future<void> _iniciarSesionConGoogle() async {
    setState(() => _cargando = true);
    try {
      await AuthService.instance.iniciarSesionConGoogle();
      if (!mounted) return;
      irAlPerfilTrasLogin(context);
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
                'Bienvenido de vuelta',
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: _colorTextoPrincipal,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Inicia sesión para continuar tu ruta.',
                style: GoogleFonts.inter(fontSize: 14, color: _colorTextoSecundario),
              ),
              const SizedBox(height: 28),
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
                validador: (v) =>
                    (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _cargando ? null : _iniciarSesion,
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
                          'Iniciar sesión',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Divider(color: _colorBordeSuave)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'o',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: _colorTextoSecundario,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: _colorBordeSuave)),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton.icon(
                  onPressed: _cargando ? null : _iniciarSesionConGoogle,
                  icon: const Icon(Icons.g_mobiledata, size: 28, color: _colorTextoPrincipal),
                  label: Text(
                    'Continuar con Google',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: _colorTextoPrincipal,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: _colorBordeSuave),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: Text(
                    '¿No tienes cuenta? Regístrate',
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
