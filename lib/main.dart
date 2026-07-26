import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'data/pueblos_data.dart';
import 'models/mision.dart';
import 'models/pueblo.dart';
import 'screens/descubrimiento_screen.dart';
import 'screens/splash_screen.dart';
import 'services/notification_service.dart';

// Paleta general de la app — ver DESIGN.md
const Color _colorFondoCrema = Color(0xFFFBF3E6);
const Color _colorSuperficie = Color(0xFFFFFFFF);
const Color _colorTextoPrincipal = Color(0xFF3A2A1E);
const Color _colorDoradoXP = Color(0xFFD9A441);

/// Navigator global: permite abrir DescubrimientoScreen desde el callback
/// de la notificación local, que no tiene un BuildContext propio.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // Si Firebase no está configurado todavía, AuthService lo detecta
    // (firebaseListo) y la app sigue funcionando sin login real.
  }
  await NotificationService.instance.inicializar(
    onTocarNotificacion: _abrirDescubrimiento,
  );
  runApp(const MyApp());
}

void _abrirDescubrimiento(String? payload) {
  if (payload == null) return;
  final partes = payload.split('|');
  if (partes.length != 2) return;

  Pueblo? pueblo;
  for (final p in pueblosData) {
    if (p.id == partes[0]) pueblo = p;
  }
  if (pueblo == null) return;

  Mision? mision;
  for (final m in pueblo.misiones) {
    if (m.id == partes[1]) mision = m;
  }
  if (mision == null) return;

  navigatorKey.currentState?.push(
    MaterialPageRoute(
      builder: (_) => DescubrimientoScreen(pueblo: pueblo!, mision: mision!),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      displayMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      displaySmall: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      headlineLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      headlineMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      headlineSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      titleLarge: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppins(fontWeight: FontWeight.w600),
    );

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Xíimbal Yucatán',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _colorFondoCrema,
        colorScheme: ColorScheme.fromSeed(
          seedColor: _colorDoradoXP,
          primary: _colorDoradoXP,
          surface: _colorSuperficie,
        ),
        textTheme: textTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: _colorFondoCrema,
          foregroundColor: _colorTextoPrincipal,
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
