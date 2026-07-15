# Ruta Mágica — Diseño Visual

## Paleta general de la app
Estos colores están presentes en TODAS las pantallas sin importar el pueblo activo.

| Nombre | Hex | Uso |
|--------|-----|-----|
| Fondo crema | #FBF3E6 | Fondo de todas las pantallas |
| Superficies | #FFFFFF | Tarjetas y contenedores |
| Borde suave | #EFE2C8 | Bordes de tarjetas |
| Texto principal | #3A2A1E | Títulos y texto importante |
| Texto secundario | #7A6353 | Subtítulos y descripciones |
| Dorado XP | #D9A441 | Puntos de experiencia, acentos |
| Verde completado | #3F6F52 | Estado completado en toda la app |
| Gris bloqueado | #E7E0D3 | Estado bloqueado en toda la app |
| Ícono bloqueado | #A89A85 | Íconos sobre fondo gris bloqueado |

## Paletas por pueblo
Cada pueblo tiene su propia paleta que domina su pantalla de detalle.

### Izamal — La ciudad amarilla
| Nombre | Hex | Uso |
|--------|-----|-----|
| Principal | #D4A017 | Color dominante, botones activos |
| Claro | #F5CC5A | Acentos, highlights |
| Oscuro | #7A5A0A | Texto sobre fondo amarillo |
| Fondo | #FEF9EC | Fondo de pantalla de Izamal |

### Valladolid — Tierra de cenotes
| Nombre | Hex | Uso |
|--------|-----|-----|
| Principal | #2A9D8F | Color dominante, botones activos |
| Claro | #5ECFC4 | Acentos, highlights |
| Oscuro | #1A5E56 | Texto sobre fondo turquesa |
| Fondo | #EBF8F7 | Fondo de pantalla de Valladolid |

### Maní — Tierra y tradición
| Nombre | Hex | Uso |
|--------|-----|-----|
| Principal | #C1440E | Color dominante, botones activos |
| Claro | #E8825A | Acentos, highlights |
| Oscuro | #6E2207 | Texto sobre fondo terracota |
| Fondo | #FDF0EB | Fondo de pantalla de Maní |

## Sistema de tres estados
Usar de forma consistente en TODA la app: mapa, retos, insignias, pueblos.

| Estado | Color fondo | Ícono | Animación |
|--------|-------------|-------|-----------|
| Completado | Verde #3F6F52 | check blanco | ninguna |
| Activo/disponible | Terracota #C1502E | pin o estrella | pulso suave (box-shadow, 2s infinito) |
| Bloqueado | Gris #E7E0D3 | candado #A89A85 | ninguna |

## Tipografía
- **Títulos y nombres:** Poppins, peso 600 (Google Fonts)
- **Cuerpo y descripciones:** Inter, peso 400 y 500 (Google Fonts)

## Estilo visual general
- Esquinas muy redondeadas: 16-20px en tarjetas, borderRadius circular en botones (pill)
- Un solo botón principal por pantalla, siempre en el color principal del pueblo activo
- Sombras suaves, sin bordes duros
- Sin imágenes reales por ahora — usar bloques de color como placeholder
- Íconos: Material Icons o paquete Iconsax para Flutter

## Mapa de exploración (pantalla 2)
- Estilo videojuego, NO lista de tarjetas
- Camino punteado curvo conectando los 3 nodos de pueblos
- Cada nodo es un círculo con el estado visual correspondiente
- Nodo activo (Izamal): terracota con animación de pulso
- Nodo completado: verde con check
- Nodo bloqueado: gris con candado
- Barra de progreso delgada arriba mostrando pueblos completados
- Botón principal abajo: "Continuar a [pueblo activo]"
