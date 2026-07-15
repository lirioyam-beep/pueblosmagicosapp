# Ruta Mágica — Funcionalidades y Casos de Uso

## Pantallas definidas

### 1. splash_screen.dart — Bienvenida
- Nombre de la app "Ruta Mágica" con tipografía Poppins grande
- Ilustración o bloque de color representativo de Yucatán
- Botón principal: "Explorar pueblos"
- Botón secundario pequeño: "Iniciar sesión" (placeholder, sin funcionalidad real aún)
- Ícono circular de perfil en esquina superior derecha (placeholder)

### 2. map_screen.dart — Mapa de exploración
- Camino punteado curvo conectando 3 nodos (pueblos)
- Sistema de tres estados en cada nodo
- Estado inicial MVP: Izamal activo, Valladolid y Maní bloqueados
- Barra de progreso arriba: "1 de 3 pueblos"
- Contador de XP en esquina superior (ícono estrella + número)
- Al tocar nodo activo o completado → navega a detalle del pueblo
- Al tocar nodo bloqueado → muestra mensaje "Completa Izamal primero"
- Botón principal abajo: "Continuar a Izamal"

### 3. pueblo_detail_screen.dart — Detalle del pueblo
- Banner superior con color del pueblo y nombre
- Etiqueta "Pueblo Mágico" en verde
- Pestañas tipo segmented control:
  - Historia
  - Leyendas  
  - Cultura
  - Recomendaciones
- Texto cultural en cada pestaña (contenido real de Izamal)
- Fila de insignias del pueblo (sistema de tres estados)
- Botón principal: "Ver retos"
- Botón regreso arriba izquierda

### 4. retos_screen.dart — Retos y misiones
- Lista de misiones del pueblo en tarjetas
- Cada tarjeta muestra: nombre de la misión, lugar físico, XP que otorga
- Estado de la misión (pendiente/completada) con sistema de tres estados
- Botón "Completar reto" en cada tarjeta
- Al completar: animación suave, tarjeta cambia a verde, suma XP
- Las misiones se activan cuando el usuario está cerca del lugar (geolocalización)
- Botón regreso arriba izquierda

### 5. insignias_screen.dart — Insignias y perfil
- Avatar del usuario arriba (seleccionable entre 3 opciones)
- Nombre de usuario
- Contador de XP total con barra de nivel
- Sección "Insignias de Izamal" — cuadrícula de 4 badges
- Sección "Insignias generales" — cuadrícula de 4 badges
- Sistema de tres estados en cada insignia
- Botón regreso arriba izquierda

## Casos de uso principales

### CU-01: Explorar pueblo
**Actor:** Turista
**Flujo:** Abre app → ve mapa → selecciona Izamal → ve detalle → navega entre pestañas de contenido cultural

### CU-02: Completar misión por ubicación
**Actor:** Turista
**Flujo:** Se acerca físicamente al lugar → app detecta GPS → misión se activa → usuario completa reto → gana XP → puede desbloquear insignia

### CU-03: Desbloquear insignia
**Actor:** Turista
**Flujo:** Completa todas las misiones requeridas → insignia cambia de bloqueada a desbloqueada con animación → se suma al perfil

### CU-04: Ver contenido cultural
**Actor:** Turista
**Flujo:** Entra al detalle del pueblo → selecciona pestaña (Historia/Leyendas/Cultura/Recomendaciones) → lee contenido del lugar donde está

### CU-05: Ver perfil y progreso
**Actor:** Turista
**Flujo:** Entra a insignias → ve su avatar, XP total, insignias desbloqueadas y bloqueadas

## Sistema de gamificación

### Puntos de experiencia (XP)
- Completar misión de ubicación: 50 XP
- Completar reto de trivia: 30 XP
- Completar reto gastronómico: 40 XP
- Completar todas las misiones de un pueblo: 200 XP bonus

### Insignias por pueblo (Izamal)
1. Explorador de Izamal — visita 3 lugares del pueblo
2. Conocedor de Leyendas — lee todas las leyendas de Izamal
3. Guardián del Convento — completa misión en el convento
4. Descubridor Maya — visita las pirámides de Kinich Kakmó

### Insignias generales de la app
1. Gran Explorador — visita los 3 pueblos
2. Viajero Completo — completa todas las misiones de un pueblo
3. Gourmet Yucateco — completa todos los retos gastronómicos
4. Guardián del Patrimonio — completa 100% de la app

### Tipos de misiones
1. **Por ubicación:** el usuario debe estar físicamente en el lugar (GPS)
2. **Trivia cultural:** responder pregunta sobre historia o leyenda del lugar
3. **Gastronómica:** probar o visitar un lugar de comida típica

## Geolocalización
- Paquete: geolocator
- Radio de activación de misión: 100 metros del punto objetivo
- Si no hay GPS disponible: modo simulado con botón "Estoy aquí"
- Mapa visual: flutter_map + OpenStreetMap (sin costo, sin API key)
- Puntos de Izamal con coordenadas reales a implementar

## Navegación entre pantallas
splash → map → pueblo_detail → retos → insignias
Todas tienen botón de regreso excepto splash.
