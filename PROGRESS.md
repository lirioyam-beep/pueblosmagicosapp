# Ruta Mágica — Progreso del proyecto

## Estado actual
Última actualización: 16 de julio 2026

MVP de Izamal funcional de principio a fin, verificado en celular real
(Android V2430). Login real con Firebase Authentication conectado.

## Completado ✅
- Entorno Flutter + Android Studio configurados, repo conectado a GitHub
- Estructura completa de lib/ (screens, models, data, widgets, services, utils)
- Modelos de datos: Pueblo, Mision, Insignia, Usuario
- Datos locales de Izamal: 3 pueblos, 3 misiones, 8 insignias (4 Izamal + 4 generales)
- **Pantallas**: splash, map_screen (selector estilo videojuego), pueblo_detail_screen
  (4 pestañas), pueblo_mapa_screen (mapa real con flutter_map + OpenStreetMap),
  retos_screen, insignias_screen (perfil completo), descubrimiento_screen,
  login_screen, register_screen
- **Geolocalización real**: LocationService (geolocator), misiones que se
  desbloquean solo al estar cerca físicamente, fallback "Estoy aquí"
- **Notificaciones de llegada**: ExploracionController + NotificationService
  (flutter_local_notifications) — avisa al llegar a un lugar y abre una
  tarjeta de descubrimiento con contenido cultural
- **Sistema de XP/nivel/insignias**: desbloqueo automático de insignias según
  misiones completadas, XP total consistente en toda la app
- **Arte real integrado**: 4 insignias de Izamal + 3 avatares (ilustraciones
  de la compañera de diseño)
- **Contenido cultural real de Izamal**: historia, 2 leyendas completas,
  cultura/platillos, 3 restaurantes recomendados — en las 4 pestañas y en
  los datos curiosos de cada misión
- **Firebase Authentication real**: registro y login por correo, Google
  Sign-In, cerrar sesión, perfil mostrando nombre/correo reales, sección
  "Tu ruta" con progreso por pueblo
- google-services.json configurado, plugin de Gradle aplicado

## Pendiente ⏳
- **Firestore**: el progreso (XP, misiones completadas, insignias) sigue
  viviendo solo en memoria local — se pierde al cerrar la app y no está
  ligado a la cuenta todavía. Es el siguiente paso lógico ahora que el
  login ya funciona.
- Contenido real de Valladolid y Maní (siguen bloqueados/con placeholders)
- Insignias generales (Gran Explorador, Viajero Completo, etc.) — sin
  requisitos de desbloqueo definidos todavía
- "Rutas" — recomendaciones de recorrido para explorar cada pueblo
  (mencionado por el equipo, sin definir alcance todavía)
- Aviso in-app sobre desactivar optimización de batería (para que las
  notificaciones de llegada funcionen de forma confiable con la app en
  segundo plano)
- Ícono personalizado de la app (sigue con el ícono default de Flutter)
- Revisar si el flujo de contenido cultural (todo visible de una vez en
  las pestañas vs. descubrir mientras caminas) se queda así o se ajusta
- Optimizar tamaño de las imágenes de insignias/avatares (~1MB cada una,
  sin comprimir)

## Equipo
- **Lily** — líder técnica, desarrollo, toma de decisiones
- **Compañera 1** — contenido cultural de Izamal
- **Compañera 2** — misiones, retos e insignias
- **Compañera 3** — imágenes y assets visuales
- **Compañera 4** — documentación y presentación
