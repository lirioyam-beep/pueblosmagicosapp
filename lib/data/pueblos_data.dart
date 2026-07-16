import '../models/pueblo.dart';
import '../models/mision.dart';
import '../models/insignia.dart';

/// Misiones placeholder de Izamal.
/// TODO: reemplazar con contenido real (ubicaciones, preguntas, textos).
final List<Mision> misionesIzamal = [
  Mision(
    id: 'izamal_mision_1',
    titulo: 'Visita el Convento de San Antonio',
    descripcion: 'Descripción placeholder de la misión 1.',
    lugarFisico: 'Convento de San Antonio de Padua',
    latitud: 20.9342,
    longitud: -89.0166,
    tipo: TipoMision.ubicacion,
    xpRecompensa: 50,
    contenidoDescubrimiento: '¿Sabías que este convento fue construido en '
        'el siglo XVI sobre una antigua pirámide maya? Contenido '
        'placeholder — aquí irá la historia real y curiosidades del lugar.',
  ),
  Mision(
    id: 'izamal_mision_2',
    titulo: 'Trivia: Historia de Izamal',
    descripcion: 'Descripción placeholder de la misión 2.',
    lugarFisico: 'Kinich Kakmó',
    latitud: 20.9366,
    longitud: -89.0154,
    tipo: TipoMision.trivia,
    xpRecompensa: 30,
    preguntaTrivia: '¿Pregunta placeholder?',
    respuestaTrivia: 'Respuesta placeholder',
    contenidoDescubrimiento: 'Existe una leyenda sobre Kinich Kakmó, el '
        'dios sol maya... Contenido placeholder — aquí irá la leyenda real.',
  ),
  Mision(
    id: 'izamal_mision_3',
    titulo: 'Prueba la comida típica',
    descripcion: 'Descripción placeholder de la misión 3.',
    lugarFisico: 'Mercado de Izamal',
    latitud: 20.9351,
    longitud: -89.0171,
    tipo: TipoMision.gastronomica,
    xpRecompensa: 40,
    contenidoDescubrimiento: 'El mercado de Izamal reúne la gastronomía '
        'tradicional yucateca desde hace generaciones. Contenido '
        'placeholder — aquí irán datos curiosos reales del lugar.',
  ),
];

/// Insignias placeholder de Izamal.
final List<Insignia> insigniasIzamal = [
  Insignia(
    id: 'izamal_insignia_1',
    nombre: 'Explorador de Izamal',
    descripcion: 'Visita 3 lugares del pueblo.',
    imagenUrl: 'assets/insignias/insignia_explorador_izamal.png',
    puebloId: 'izamal',
    requisitos: ['izamal_mision_1', 'izamal_mision_2', 'izamal_mision_3'],
  ),
  Insignia(
    id: 'izamal_insignia_2',
    nombre: 'Conocedor de Leyendas',
    descripcion: 'Lee todas las leyendas de Izamal.',
    imagenUrl: 'assets/insignias/insignia_conocedor_leyendas.png',
    puebloId: 'izamal',
    requisitos: [],
  ),
  Insignia(
    id: 'izamal_insignia_3',
    nombre: 'Guardián del Convento',
    descripcion: 'Completa la misión en el convento.',
    imagenUrl: 'assets/insignias/insignia_guardian_convento.png',
    puebloId: 'izamal',
    requisitos: ['izamal_mision_1'],
  ),
  Insignia(
    id: 'izamal_insignia_4',
    nombre: 'Descubridor Maya',
    descripcion: 'Visita las pirámides de Kinich Kakmó.',
    imagenUrl: 'assets/insignias/insignia_descubridor_maya.png',
    puebloId: 'izamal',
    requisitos: ['izamal_mision_2'],
  ),
];

/// Insignias generales de la app (no atadas a un pueblo específico).
final List<Insignia> insigniasGenerales = [
  Insignia(
    id: 'general_insignia_1',
    nombre: 'Gran Explorador',
    descripcion: 'Visita los 3 pueblos.',
    imagenUrl: '',
    puebloId: null,
    requisitos: [],
  ),
  Insignia(
    id: 'general_insignia_2',
    nombre: 'Viajero Completo',
    descripcion: 'Completa todas las misiones de un pueblo.',
    imagenUrl: '',
    puebloId: null,
    requisitos: [],
  ),
  Insignia(
    id: 'general_insignia_3',
    nombre: 'Gourmet Yucateco',
    descripcion: 'Completa todos los retos gastronómicos.',
    imagenUrl: '',
    puebloId: null,
    requisitos: [],
  ),
  Insignia(
    id: 'general_insignia_4',
    nombre: 'Guardián del Patrimonio',
    descripcion: 'Completa el 100% de la app.',
    imagenUrl: '',
    puebloId: null,
    requisitos: [],
  ),
];

/// Los 3 pueblos del MVP. Solo Izamal está activo; los demás bloqueados.
final List<Pueblo> pueblosData = [
  Pueblo(
    id: 'izamal',
    nombre: 'Izamal',
    descripcion: 'La ciudad amarilla. Descripción placeholder.',
    colorHex: '#D4A017',
    latitud: 20.9342,
    longitud: -89.0166,
    estado: EstadoPueblo.activo,
    misiones: misionesIzamal,
    insignias: insigniasIzamal,
  ),
  Pueblo(
    id: 'valladolid',
    nombre: 'Valladolid',
    descripcion: 'Tierra de cenotes. Descripción placeholder.',
    colorHex: '#2A9D8F',
    latitud: 20.6896,
    longitud: -88.2016,
    estado: EstadoPueblo.bloqueado,
    misiones: [],
    insignias: [],
  ),
  Pueblo(
    id: 'mani',
    nombre: 'Maní',
    descripcion: 'Tierra y tradición. Descripción placeholder.',
    colorHex: '#C1440E',
    latitud: 20.3897,
    longitud: -89.3878,
    estado: EstadoPueblo.bloqueado,
    misiones: [],
    insignias: [],
  ),
];
