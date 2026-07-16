import '../models/pueblo.dart';
import '../models/mision.dart';
import '../models/insignia.dart';

/// Misiones de Izamal con contenido real, investigado a partir del
/// documento "Contenido cultural ruta mágica" compartido por el equipo.
final List<Mision> misionesIzamal = [
  Mision(
    id: 'izamal_mision_1',
    titulo: 'Visita el Convento de San Antonio de Padua',
    descripcion: 'Uno de los conventos coloniales más grandes del mundo, '
        'construido en el siglo XVI sobre una pirámide maya. Su atrio es '
        'el segundo más grande después del Vaticano.',
    lugarFisico: 'Convento de San Antonio de Padua',
    latitud: 20.9342,
    longitud: -89.0166,
    tipo: TipoMision.ubicacion,
    xpRecompensa: 50,
    contenidoDescubrimiento: '¿Sabías que el Papa Juan Pablo II visitó '
        'este convento en 1993 y coronó a la Virgen de Izamal? Fue la '
        'única visita papal a Yucatán en la historia. Todas las paredes '
        'del convento y del pueblo están pintadas de amarillo ocre, el '
        'color que le dio a Izamal el apodo de "Ciudad Amarilla".',
  ),
  Mision(
    id: 'izamal_mision_2',
    titulo: 'Trivia: Cerro Kinich Kakmó',
    descripcion: 'Pirámide maya dedicada al dios solar, una de las más '
        'grandes de Yucatán por su volumen. Desde su cima se ve todo el '
        'pueblo pintado de amarillo.',
    lugarFisico: 'Cerro Kinich Kakmó',
    latitud: 20.9366,
    longitud: -89.0154,
    tipo: TipoMision.trivia,
    xpRecompensa: 30,
    preguntaTrivia: '¿A qué dios maya estaba dedicada la pirámide '
        'Kinich Kakmó?',
    respuestaTrivia: 'Al dios solar Kinich Kakmó',
    contenidoDescubrimiento: 'Su nombre en maya significa "el que absorbe '
        'el sol con fuego de guacamaya". Los mayas creían que el dios '
        'Kinich Kakmó descendía en forma de guacamaya de fuego al '
        'mediodía para consumir las ofrendas dejadas en la cima. Es una '
        'de las pocas pirámides de Yucatán que se puede subir libremente '
        'y de forma gratuita.',
  ),
  Mision(
    id: 'izamal_mision_3',
    titulo: 'Prueba la comida típica en el Mercado',
    descripcion: 'El corazón social de Izamal: aquí conviven comida '
        'tradicional yucateca, artesanías y hierberos que mantienen '
        'vivas las costumbres del pueblo.',
    lugarFisico: 'Mercado Municipal de Izamal',
    latitud: 20.9351,
    longitud: -89.0171,
    tipo: TipoMision.gastronomica,
    xpRecompensa: 40,
    contenidoDescubrimiento: '¿Sabías que aquí se vende henequén '
        'artesanal, la fibra que fue la base económica de Yucatán y se '
        'conocía como "el oro verde"? Prueba también los tamales de '
        'chipilín, envueltos en hoja de plátano — una especialidad casi '
        'exclusiva de Izamal.',
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
