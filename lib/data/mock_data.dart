class Candidato {
  final String nombre;
  final String partido;
  final double porcentaje;
  final double porcentajeEmitidos;
  final int votos;

  const Candidato({
    required this.nombre,
    required this.partido,
    required this.porcentaje,
    required this.porcentajeEmitidos,
    required this.votos,
  });
}

// ── PERÚ – DATOS OFICIALES ONPE (Segunda Elección Presidencial 2016) ──────────
// Fuente: web.onpe.gob.pe  |  Actualizado: 20/06/2016 a las 19:16 h
// Total emitidos: 18,342,896  |  Electores: 22,901,954  |  Participación: 80.093%
// Válidos: 17,152,817 (93.512%) | Blancos: 149,577 (0.815%) | Nulos: 1,040,502 (5.673%)
// Verificación: 17,152,817 + 149,577 + 1,040,502 = 18,342,896 ✓
const candidatosPeru = [
  Candidato(
    nombre: 'Pedro Pablo Kuczynski',
    partido: 'Peruanos por el Kambio',
    porcentaje: 50.120,
    porcentajeEmitidos: 46.868,
    votos: 8596937,
  ),
  Candidato(
    nombre: 'Keiko Fujimori',
    partido: 'Fuerza Popular',
    porcentaje: 49.880,
    porcentajeEmitidos: 46.644,
    votos: 8555880,
  ),
];

const candidatos = candidatosPeru;

class RegionalStats {
  final String totalActas;
  final String procesadas;
  final String contabilizadas;
  final String electoresHabiles;
  final String participantes;
  final String porcentajeFinal;
  final String ausentismo;
  final String votosValidos;
  final double pctValidos;
  final String votosBlancos;
  final double pctBlancos;
  final String votosNulos;
  final double pctNulos;
  final String totalEmitidos;

  const RegionalStats({
    required this.totalActas,
    required this.procesadas,
    required this.contabilizadas,
    required this.electoresHabiles,
    required this.participantes,
    required this.porcentajeFinal,
    required this.ausentismo,
    required this.votosValidos,
    required this.pctValidos,
    required this.votosBlancos,
    required this.pctBlancos,
    required this.votosNulos,
    required this.pctNulos,
    required this.totalEmitidos,
  });
}

const statsPeru = RegionalStats(
  totalActas: '77,307',
  procesadas: '77,307',
  contabilizadas: '77,307',
  electoresHabiles: '22,901,954',
  participantes: '18,342,896',
  porcentajeFinal: '80.093%',
  ausentismo: '19.907%',
  votosValidos: '17,152,817',
  pctValidos: 93.512,
  votosBlancos: '149,577',
  pctBlancos: 0.815,
  votosNulos: '1,040,502',
  pctNulos: 5.673,
  totalEmitidos: '18,342,896',
);

// ── EXTRANJERO – Datos estimados (pendiente datos oficiales) ──────────────────
// Electores: 884,924  |  Participantes: 389,529  |  Participación: 44.018%
// Válidos: 362,162 (92.975%) | Blancos: 15,820 (4.062%) | Nulos: 11,547 (2.965%)
// Verificación: 362,162 + 15,820 + 11,547 = 389,529 ✓
const candidatosExtranjero = [
  Candidato(
    nombre: 'Pedro Pablo Kuczynski',
    partido: 'Peruanos por el Kambio',
    porcentaje: 52.180,
    porcentajeEmitidos: 48.524,
    votos: 189016,
  ),
  Candidato(
    nombre: 'Keiko Fujimori',
    partido: 'Fuerza Popular',
    porcentaje: 47.820,
    porcentajeEmitidos: 44.451,
    votos: 173146,
  ),
];

const statsExtranjero = RegionalStats(
  totalActas: '5,847',
  procesadas: '5,847',
  contabilizadas: '5,847',
  electoresHabiles: '884,924',
  participantes: '389,529',
  porcentajeFinal: '44.018%',
  ausentismo: '55.982%',
  votosValidos: '362,162',
  pctValidos: 92.975,
  votosBlancos: '15,820',
  pctBlancos: 4.062,
  votosNulos: '11,547',
  pctNulos: 2.965,
  totalEmitidos: '389,529',
);

// ── GLOSARIO OFICIAL (fuente: ONPE) ──────────────────────────────────────────
const glosarioTerminos = [
  (
    'ACTA CON VOTOS IMPUGNADOS',
    'Acta con votos impugnados.',
  ),
  (
    'ACTA CON ERROR MATERIAL',
    'Con inconsistencias en los datos numéricos consignados.',
  ),
  (
    'ACTA CON ILEGIBILIDAD',
    'Es aquella que contiene datos ilegibles.',
  ),
  (
    'ACTA INCOMPLETA',
    'No consigna el total de ciudadanos que votaron.',
  ),
  (
    'ACTA CON SOLICITUD DE NULIDAD',
    'Acta con solicitud de nulidad de la mesa, realizada de manera expresa en el espacio de observadores.',
  ),
  (
    'ACTA SIN DATOS',
    'No se registran votos.',
  ),
  (
    'ACTA EXTRAVIADA',
    'La que no llega a la ODPE y es declarada como tal por el Jefe de la ODPE.',
  ),
  (
    'ACTA SINIESTRADA',
    'Acta que corresponde a una mesa de sufragio que, debido a hecho de violencia y/o atentado contra el Derecho al Sufragio, no pudo ser entregada a la ODPE o ingresada al sistema de cómputo electoral.',
  ),
  (
    'ACTA SIN FIRMAS',
    'No se considera observada cuando cuenta con al menos las firmas, nombre y DNI de los tres miembros de mesa, o en su defecto, datos y firmas de al menos dos miembros.',
  ),
  (
    'CON MÁS DE UNA OBSERVACIÓN',
    'Aquella que presenta alguna combinación de las observaciones anteriormente mencionadas.',
  ),
];
