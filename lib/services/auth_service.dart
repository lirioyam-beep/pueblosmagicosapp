import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Envuelve Firebase Auth + Google Sign-In. Todos los métodos son seguros
/// de llamar incluso antes de que `Firebase.initializeApp()` se haya
/// ejecutado (por ejemplo, mientras todavía no existe
/// android/app/google-services.json): en ese caso simplemente informan
/// que el inicio de sesión no está disponible todavía, en vez de tronar.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  bool _googleInicializado = false;

  /// True una vez que Firebase.initializeApp() ya corrió correctamente.
  bool get firebaseListo => Firebase.apps.isNotEmpty;

  FirebaseAuth get _auth => FirebaseAuth.instance;

  Stream<User?> get cambiosDeUsuario {
    if (!firebaseListo) return const Stream<User?>.empty();
    return _auth.authStateChanges();
  }

  User? get usuarioActual => firebaseListo ? _auth.currentUser : null;

  Future<UserCredential> iniciarSesionConCorreo({
    required String correo,
    required String contrasena,
  }) {
    _asegurarFirebaseListo();
    return _auth.signInWithEmailAndPassword(
      email: correo,
      password: contrasena,
    );
  }

  Future<UserCredential> registrarConCorreo({
    required String nombre,
    required String correo,
    required String contrasena,
  }) async {
    _asegurarFirebaseListo();
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: correo,
      password: contrasena,
    );
    await credencial.user?.updateDisplayName(nombre);
    return credencial;
  }

  Future<UserCredential> iniciarSesionConGoogle() async {
    _asegurarFirebaseListo();
    if (!_googleInicializado) {
      await GoogleSignIn.instance.initialize();
      _googleInicializado = true;
    }

    final cuenta = await GoogleSignIn.instance.authenticate();
    final idToken = cuenta.authentication.idToken;
    final credencial = GoogleAuthProvider.credential(idToken: idToken);
    return _auth.signInWithCredential(credencial);
  }

  Future<void> actualizarNombre(String nombre) async {
    _asegurarFirebaseListo();
    await _auth.currentUser?.updateDisplayName(nombre);
    await _auth.currentUser?.reload();
  }

  Future<void> cerrarSesion() async {
    if (!firebaseListo) return;
    await _auth.signOut();
    if (_googleInicializado) {
      await GoogleSignIn.instance.signOut();
    }
  }

  void _asegurarFirebaseListo() {
    if (!firebaseListo) {
      throw StateError('firebase-no-listo');
    }
  }

  /// Traduce los códigos de error de Firebase a mensajes en español
  /// entendibles para mostrar en la UI.
  String mensajeError(Object error) {
    if (error is StateError) {
      return 'El inicio de sesión todavía no está disponible en esta '
          'versión de la app.';
    }
    if (error is! FirebaseAuthException) {
      return 'Ocurrió un error inesperado. Intenta de nuevo.';
    }
    switch (error.code) {
      case 'invalid-email':
        return 'El correo no es válido.';
      case 'user-disabled':
        return 'Esta cuenta fue deshabilitada.';
      case 'user-not-found':
        return 'No existe una cuenta con ese correo.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Correo o contraseña incorrectos.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con ese correo.';
      case 'weak-password':
        return 'La contraseña es muy débil (mínimo 6 caracteres).';
      default:
        return 'No se pudo completar la operación. Intenta de nuevo.';
    }
  }
}
