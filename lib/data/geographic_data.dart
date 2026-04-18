// Datos geográficos para filtros en cascada
// Perú: Departamento → Provincia → Distrito
// Extranjero: Continente → País → Ciudad

// ── PERÚ ─────────────────────────────────────────────────────────────────────
// Estructura: { departamento: { provincia: [distritos] } }
const Map<String, Map<String, List<String>>> peruGeo = {
  'Lima': {
    'Lima': ['Miraflores', 'San Isidro', 'Surco', 'La Molina', 'Barranco', 'Lince', 'Jesús María', 'San Borja'],
    'Lima Norte': ['Comas', 'Los Olivos', 'Independencia', 'San Martín de Porres', 'Carabayllo'],
    'Lima Este': ['San Juan de Lurigancho', 'Ate', 'El Agustino', 'Santa Anita', 'Lurigancho'],
    'Lima Sur': ['Villa El Salvador', 'Villa María del Triunfo', 'San Juan de Miraflores', 'Chorrillos'],
    'Callao': ['Callao', 'Bellavista', 'La Perla', 'La Punta', 'Carmen de La Legua', 'Ventanilla'],
    'Huaral': ['Huaral', 'Chancay', 'Aucallama', 'Ihuarí'],
    'Cañete': ['San Vicente de Cañete', 'Imperial', 'Mala', 'San Luis'],
  },
  'Arequipa': {
    'Arequipa': ['Arequipa', 'Cayma', 'Cerro Colorado', 'Paucarpata', 'Mariano Melgar', 'Miraflores', 'Alto Selva Alegre'],
    'Camaná': ['Camaná', 'Samuel Pastor', 'Mariscal Cáceres'],
    'Islay': ['Mollendo', 'Islay', 'Deán Valdivia'],
    'Caravelí': ['Caravelí', 'Atico', 'Cháparra'],
  },
  'La Libertad': {
    'Trujillo': ['Trujillo', 'El Porvenir', 'Florencia de Mora', 'Huanchaco', 'La Esperanza', 'Laredo'],
    'Ascope': ['Ascope', 'Casa Grande', 'Chocope', 'Paiján'],
    'Pacasmayo': ['San Pedro de Lloc', 'Guadalupe', 'Jequetepeque'],
    'Virú': ['Virú', 'Chao', 'Guadalupito'],
  },
  'Piura': {
    'Piura': ['Piura', 'Castilla', 'Catacaos', 'La Arena', 'La Unión', 'Las Lomas'],
    'Sullana': ['Sullana', 'Bellavista', 'Ignacio Escudero', 'Lancones'],
    'Talara': ['Pariñas', 'El Alto', 'La Brea', 'Lobitos'],
    'Paita': ['Paita', 'Amotape', 'Colán', 'La Huaca'],
  },
  'Cusco': {
    'Cusco': ['Cusco', 'San Sebastián', 'Santiago', 'Wanchaq', 'San Jerónimo'],
    'La Convención': ['Santa Ana', 'Huayopata', 'Echarate', 'Vilcabamba'],
    'Urubamba': ['Urubamba', 'Machu Picchu', 'Ollantaytambo', 'Chinchero'],
    'Anta': ['Anta', 'Chinchaypugio', 'Huarocondo', 'Limatambo'],
  },
  'Puno': {
    'Puno': ['Puno', 'Acora', 'Amantani', 'Atuncolla', 'Capachica'],
    'Juliaca': ['San Román', 'Juliaca', 'Caracoto', 'Caminaca'],
    'Azángaro': ['Azángaro', 'Achaya', 'Arapa', 'Asillo'],
    'Melgar': ['Ayaviri', 'Antauta', 'Cupi', 'Llalli'],
  },
  'Junín': {
    'Huancayo': ['Huancayo', 'El Tambo', 'Chilca', 'Concepción', 'Jauja'],
    'Chanchamayo': ['La Merced', 'San Ramón', 'Perené', 'Pichanaqui'],
    'Satipo': ['Satipo', 'Coviriali', 'Llaylla', 'Mazamari'],
    'Tarma': ['Tarma', 'Acobamba', 'Huaricolca', 'La Unión'],
  },
  'Cajamarca': {
    'Cajamarca': ['Cajamarca', 'Baños del Inca', 'Llacanora', 'Namora', 'Magdalena'],
    'Jaén': ['Jaén', 'Bellavista', 'Colasay', 'Huabal'],
    'San Ignacio': ['San Ignacio', 'Chirinos', 'Huarango', 'Namballe'],
    'Chota': ['Chota', 'Anguía', 'Chadin', 'Lajas'],
  },
  'Lambayeque': {
    'Chiclayo': ['Chiclayo', 'José Leonardo Ortiz', 'La Victoria', 'Pimentel', 'Reque'],
    'Lambayeque': ['Lambayeque', 'Jayanca', 'Mochumí', 'Olmos'],
    'Ferreñafe': ['Ferreñafe', 'Cañaris', 'Incahuasi', 'Manuel Mesones Muro'],
  },
  'Áncash': {
    'Huaraz': ['Huaraz', 'Independencia', 'Jangas', 'La Libertad', 'Olleros'],
    'Santa': ['Chimbote', 'Coishco', 'Nuevo Chimbote', 'Santa', 'Nepeña'],
    'Huari': ['Huari', 'Anra', 'Cajay', 'Chavin de Huantar'],
    'Recuay': ['Recuay', 'Catac', 'Cotaparaco', 'Llacllin'],
  },
  'Loreto': {
    'Maynas': ['Iquitos', 'Alto Nanay', 'Fernando Lores', 'Indiana', 'Las Amazonas'],
    'Requena': ['Requena', 'Alto Tapiche', 'Capelo', 'Emilio San Martín'],
    'Ucayali': ['Contamana', 'Inahuaya', 'Padre Márquez', 'Pampa Hermosa'],
  },
  'San Martín': {
    'San Martín': ['Tarapoto', 'La Banda de Shilcayo', 'Morales', 'Alberto Leveau'],
    'Moyobamba': ['Moyobamba', 'Calzada', 'Habana', 'Jepelacio'],
    'Rioja': ['Rioja', 'Awajún', 'Elías Soplín Vargas', 'Nueva Cajamarca'],
  },
  'Ica': {
    'Ica': ['Ica', 'La Tinguiña', 'Los Aquijes', 'Parcona', 'Pueblo Nuevo'],
    'Chincha': ['Chincha Alta', 'Alto Larán', 'Chavín', 'El Carmen'],
    'Nazca': ['Nazca', 'Changuillo', 'El Ingenio', 'Marcona'],
  },
  'Huánuco': {
    'Huánuco': ['Huánuco', 'Amarilis', 'Chinchao', 'Churubamba', 'Pillco Marca'],
    'Leoncio Prado': ['Rupa-Rupa', 'Daniel Alomía Robles', 'Hermilio Valdizán', 'José Crespo y Castillo'],
    'Puerto Inca': ['Puerto Inca', 'Codo del Pozuzo', 'Honoria', 'Tournavista'],
  },
  'Ayacucho': {
    'Huamanga': ['Ayacucho', 'Acos Vinchos', 'Carmen Alto', 'Jesús Nazareno', 'San Juan Bautista'],
    'Huanta': ['Huanta', 'Ayahuanco', 'Huamanguilla', 'Iguaín', 'Luricocha'],
    'La Mar': ['San Miguel', 'Anco', 'Ayna', 'Chilcas'],
  },
  'Apurímac': {
    'Abancay': ['Abancay', 'Chacoche', 'Circa', 'Curahuasi', 'Huanipaca'],
    'Andahuaylas': ['Andahuaylas', 'Andarapa', 'Chiara', 'Huancarama', 'Kaquiabamba'],
    'Cotabambas': ['Tambobamba', 'Challhuahuacho', 'Cotabambas', 'Coyllurqui'],
  },
  'Moquegua': {
    'Mariscal Nieto': ['Moquegua', 'Carumas', 'Cuchumbaya', 'Samegua', 'San Cristóbal'],
    'Ilo': ['Ilo', 'El Algarrobal', 'Pacocha'],
    'General Sánchez Cerro': ['Omate', 'Chojata', 'Coalaque', 'Ichuña'],
  },
  'Tacna': {
    'Tacna': ['Tacna', 'Alto de la Alianza', 'Ciudad Nueva', 'Inclán', 'Pocollay'],
    'Tarata': ['Tarata', 'Héroes Albarracín', 'Susapaya', 'Ticaco'],
    'Candarave': ['Candarave', 'Cairani', 'Camilaca', 'Curibaya'],
  },
  'Tumbes': {
    'Tumbes': ['Tumbes', 'Corrales', 'La Cruz', 'Pampas de Hospital', 'San Jacinto'],
    'Contralmirante Villar': ['Zorritos', 'Casitas', 'Canoas de Punta Sal'],
    'Zarumilla': ['Zarumilla', 'Aguas Verdes', 'Matapalo', 'Papayal'],
  },
  'Ucayali': {
    'Coronel Portillo': ['Callería', 'Campo Verde', 'Iparía', 'Masisea', 'Nueva Requena', 'Yarinacocha'],
    'Atalaya': ['Raymondi', 'Sepahua', 'Tahuanía', 'Yurúa'],
    'Padre Abad': ['Padre Abad', 'Irazola', 'Curimaná', 'Neshuya'],
  },
  'Madre de Dios': {
    'Tambopata': ['Tambopata', 'Inambari', 'Las Piedras', 'Laberinto'],
    'Manu': ['Manu', 'Fitzcarrald', 'Madre de Dios', 'Huepetuhe'],
    'Tahuamanu': ['Iñapari', 'Iberia', 'Tahuamanu'],
  },
  'Pasco': {
    'Pasco': ['Chaupimarca', 'Huachón', 'Huariaca', 'Huayllay', 'Ninacaca', 'Pallanchacra'],
    'Oxapampa': ['Oxapampa', 'Chontabamba', 'Huancabamba', 'Palcazu', 'Pozuzo', 'Puerto Bermúdez'],
    'Daniel Alcides Carrión': ['Yanahuanca', 'Chacayán', 'Goyllarisquizga', 'Paucar'],
  },
  'Huancavelica': {
    'Huancavelica': ['Huancavelica', 'Acobambilla', 'Acoria', 'Conayca', 'Cuenca'],
    'Churcampa': ['Churcampa', 'Anco', 'Chinchihuasi', 'El Carmen', 'La Merced'],
    'Tayacaja': ['Pampas', 'Acostambo', 'Acraquia', 'Ahuaycha', 'Colcabamba'],
  },
  'Amazonas': {
    'Chachapoyas': ['Chachapoyas', 'Asunción', 'Balsas', 'Cheto', 'Chiliquín'],
    'Bagua': ['Bagua', 'Aramango', 'Copallin', 'El Parco', 'Imaza'],
    'Utcubamba': ['Bagua Grande', 'Cajaruro', 'Cumba', 'El Milagro', 'Jamalca'],
  },
};

// ── ELECTORES POR DEPARTAMENTO (pesos para distribución proporcional) ─────────
// Basado en datos de participación ONPE 2016
const Map<String, double> pesoDepartamento = {
  'Lima': 0.350,
  'Piura': 0.065,
  'La Libertad': 0.062,
  'Cajamarca': 0.055,
  'Puno': 0.052,
  'Arequipa': 0.048,
  'Junín': 0.042,
  'Cusco': 0.040,
  'Lambayeque': 0.040,
  'Áncash': 0.038,
  'Loreto': 0.030,
  'San Martín': 0.028,
  'Ica': 0.026,
  'Huánuco': 0.022,
  'Ayacucho': 0.020,
  'Apurímac': 0.014,
  'Ucayali': 0.013,
  'Amazonas': 0.012,
  'Huancavelica': 0.012,
  'Moquegua': 0.010,
  'Tacna': 0.010,
  'Pasco': 0.009,
  'Tumbes': 0.008,
  'Madre de Dios': 0.006,
  'Callao': 0.028,
};

// ── EXTRANJERO ────────────────────────────────────────────────────────────────
// Continente → País → Ciudad
const Map<String, Map<String, List<String>>> extranjeroGeo = {
  'América': {
    'Argentina': ['Buenos Aires', 'Córdoba', 'Rosario', 'Mendoza'],
    'Bolivia': ['La Paz', 'Santa Cruz de la Sierra', 'Cochabamba'],
    'Brasil': ['São Paulo', 'Brasilia', 'Río de Janeiro'],
    'Canadá': ['Toronto', 'Montreal', 'Vancouver'],
    'Chile': ['Santiago', 'Valparaíso', 'Concepción', 'Antofagasta'],
    'Colombia': ['Bogotá', 'Medellín', 'Cali'],
    'Ecuador': ['Quito', 'Guayaquil', 'Cuenca'],
    'Estados Unidos': ['New York', 'Los Angeles', 'Miami', 'Chicago', 'Houston', 'Washington D.C.'],
    'México': ['Ciudad de México', 'Guadalajara', 'Monterrey'],
    'Panamá': ['Ciudad de Panamá'],
    'Paraguay': ['Asunción'],
    'Uruguay': ['Montevideo'],
    'Venezuela': ['Caracas', 'Maracaibo'],
  },
  'Europa': {
    'Alemania': ['Berlín', 'Múnich', 'Frankfurt', 'Hamburgo'],
    'Bélgica': ['Bruselas', 'Amberes'],
    'España': ['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao'],
    'Francia': ['París', 'Lyon', 'Marsella'],
    'Italia': ['Roma', 'Milán', 'Turín', 'Florencia'],
    'Países Bajos': ['Ámsterdam', 'La Haya', 'Rotterdam'],
    'Portugal': ['Lisboa', 'Oporto'],
    'Reino Unido': ['Londres', 'Manchester', 'Birmingham'],
    'Suecia': ['Estocolmo', 'Gotemburgo'],
    'Suiza': ['Ginebra', 'Zúrich', 'Berna'],
  },
  'Asia': {
    'China': ['Beijing', 'Shanghai', 'Guangzhou'],
    'Corea del Sur': ['Seúl', 'Busan'],
    'Emiratos Árabes': ['Dubái', 'Abu Dabi'],
    'Israel': ['Tel Aviv', 'Jerusalén'],
    'Japón': ['Tokio', 'Osaka', 'Nagoya'],
    'Qatar': ['Doha'],
  },
  'Oceanía': {
    'Australia': ['Sydney', 'Melbourne', 'Brisbane', 'Perth'],
    'Nueva Zelanda': ['Auckland', 'Wellington', 'Christchurch'],
  },
  'África': {
    'Nigeria': ['Lagos', 'Abuja'],
    'Senegal': ['Dakar'],
    'Sudáfrica': ['Johannesburgo', 'Ciudad del Cabo', 'Pretoria'],
  },
};

// ── ELECTORES POR CONTINENTE (datos oficiales ONPE Participación) ─────────────
const Map<String, int> electoresContinente = {
  'América': 596128,
  'Europa': 249321,
  'Asia': 33965,
  'Oceanía': 4812,
  'África': 698,
};
