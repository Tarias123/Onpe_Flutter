ONPE – Resultados Electorales 2016
Aplicativo móvil desarrollado en Flutter que presenta los resultados oficiales de la Segunda Elección Presidencial 2016 del Perú.

Requisitos previos
Antes de instalar, asegúrate de tener lo siguiente en tu computadora:

Flutter SDK — versión 3.0 o superior
Android Studio o VS Code
Git instalado
Un emulador Android configurado o un dispositivo físico con depuración USB activada
Instalación
1. Clonar el repositorio

git clone https://github.com/Tarias123/Onpe_Flutter.git
cd Onpe_Flutter
2. Instalar dependencias

flutter pub get
3. Verificar que Flutter esté correctamente instalado

flutter doctor
4. Ejecutar la aplicación

flutter run
Estructura del proyecto
lib/
├── main.dart                  # Punto de entrada y navegación principal
├── theme.dart                 # Colores y estilos globales
├── data/
│   ├── mock_data.dart         # Datos oficiales ONPE 2016
│   └── geographic_data.dart   # Jerarquía geográfica (departamentos, provincias, distritos)
├── pages/
│   ├── presidencial_page.dart # Resultados presidenciales (3 tabs)
│   ├── actas_page.dart        # Búsqueda de actas por ubigeo y número
│   └── participacion_page.dart# Participación ciudadana nacional y extranjero
└── widgets/
    └── app_header.dart        # Encabezado de la aplicación
Pantallas disponibles
Sección	Descripción
Presidencial	Resumen general, resultados por candidato y resultados por tipo de voto con filtros geográficos
Actas	Búsqueda de actas por ubigeo (departamento, provincia, distrito) o por número de acta
Participación	Participación ciudadana nacional y en el extranjero por continente
Datos oficiales utilizados
Fuente: ONPE – web.onpe.gob.pe
Segunda Elección Presidencial 2016 — actualizado al 20/06/2016 a las 19:16 h.

Candidato	Votos	% Válidos
Pedro Pablo Kuczynski	8,596,937	50.120%
Keiko Fujimori	8,555,880	49.880%
Indicador	Valor
Electores hábiles	22,901,954
Ciudadanos que votaron	18,342,896
Participación	80.093%
Votos válidos	17,152,817
Votos blancos	149,577
Votos nulos	1,040,502
Próximas funcionalidades
Integración con Firebase para datos en tiempo real
Búsqueda de actas conectada a base de datos
Participación por departamento con datos reales
Resultados por distrito y mesa de sufragio
