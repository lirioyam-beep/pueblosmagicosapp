# Ruta Mágica — App Gamificada Pueblos Mágicos de Yucatán

## Descripción general
App móvil gamificada de turismo cultural para los Pueblos Mágicos de Yucatán. 
Funciona similar a Pokémon Go: el GPS detecta dónde está el usuario y activa 
contenido cultural (leyendas, historia, misiones, recomendaciones) según su 
ubicación real. No fuerza al usuario a ir a un lugar — le recomienda y le 
cuenta cosas de lo que tiene cerca mientras camina por el pueblo.

## Nombre
**Ruta Mágica**

## Tecnología
- Flutter + Dart (desarrollo móvil)
- Geolocalización: paquete `geolocator` (GPS del celular, sin Google Maps API)
- Mapa: `flutter_map` + OpenStreetMap (gratuito, sin API key)
- Base de datos: Firebase (fase futura — Authentication + Firestore + Storage)
- Tipografía: Google Fonts (Poppins + Inter)

## Dispositivo de prueba
- Android V2430, Android 15 (API 35)
- Repositorio: github.com/lirioyam-beep/pueblosmagicosapp

## MVP — 3 Pueblos iniciales
| Pueblo | Color principal | Estado en MVP |
|--------|----------------|---------------|
| Izamal | Amarillo #D4A017 | Completamente desarrollado |
| Valladolid | Turquesa #2A9D8F | Visible pero bloqueado |
| Maní | Terracota #C1440E | Visible pero bloqueado |

## Estado actual del proyecto
- Flutter instalado y configurado en Windows 11
- Android Studio instalado con SDK completo
- Proyecto Flutter creado y corriendo en celular real
- Repositorio GitHub conectado con VS Code
- Código actual: solo el contador de ejemplo de Flutter (main.dart)
- Siguiente paso: generar pantallas base y navegación

## Estructura de archivos objetivo
```
lib/
  main.dart
  screens/
    splash_screen.dart
    map_screen.dart
    pueblo_detail_screen.dart
    retos_screen.dart
    insignias_screen.dart
  models/
    pueblo.dart
    mision.dart
    insignia.dart
    usuario.dart
  data/
    pueblos_data.dart
  widgets/
    pueblo_node.dart
    mision_card.dart
    insignia_badge.dart
```
