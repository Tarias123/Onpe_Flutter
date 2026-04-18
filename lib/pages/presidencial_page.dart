import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../data/geographic_data.dart';

class PresidencialPage extends StatefulWidget {
  const PresidencialPage({super.key});

  @override
  State<PresidencialPage> createState() => _PresidencialPageState();
}

class _PresidencialPageState extends State<PresidencialPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SubHeader(controller: _tabController),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              _ResumenGeneral(),
              _ResultadosPresidenciales(),
              _ResultadoPorTipo(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SubHeader extends StatelessWidget {
  final TabController controller;
  const _SubHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('REPORTE OFICIAL',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.5)),
          const SizedBox(height: 2),
          const Text('Resultados de Elecciones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
          const SizedBox(height: 8),
          TabBar(
            controller: controller,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicator: const BoxDecoration(),
            labelPadding: EdgeInsets.zero,
            dividerColor: Colors.transparent,
            tabs: [
              _buildTab('Resumen general', 0),
              _buildTab('Resultado Presidenciales', 1),
              _buildTab('Resultado Por Tipo', 2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final selected = controller.index == index;
        return GestureDetector(
          onTap: () => controller.animateTo(index),
          child: Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? AppColors.navyDark : Colors.transparent,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : Colors.grey,
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── TAB 1: Resumen General ───────────────────────────────────────────────────

class _ResumenGeneral extends StatelessWidget {
  const _ResumenGeneral();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Estado actual
        _CardEstado(),
        const SizedBox(height: 12),
        // Participación ciudadana
        _CardParticipacion(),
        const SizedBox(height: 12),
        // Desglose candidaturas
        _CardDesglose(),
        const SizedBox(height: 12),
        // Progreso escrutinio
        _CardProgreso(),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _CardEstado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.goldLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('ESTADO ACTUAL',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF7A5000), letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('100% Procesados',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
              Container(
                width: 28, height: 28,
                decoration: const BoxDecoration(color: AppColors.navyDark, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Actos contabilizados', style: TextStyle(fontSize: 11, color: Color(0xFF5A3A00))),
              Text('100.000%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF5A3A00))),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 1.0,
              backgroundColor: const Color(0xFFD4891A),
              valueColor: const AlwaysStoppedAnimation(AppColors.navyDark),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          const Text('ULTIMA ACTUALIZACIÓN: OCT 24 2023 – 14:30:00',
              style: TextStyle(fontSize: 9, color: Color(0xFF7A5000), letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _CardParticipacion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PARTICIPACIÓN CIUDADANA',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.2)),
          const SizedBox(height: 6),
          Row(
            children: const [
              Text('80.093%',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
              SizedBox(width: 8),
              Icon(Icons.person, color: Colors.grey, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem('VOTANTES ELEGIBLES', '22,901,954'),
              _statItem('CIUDADANOS QUE VOTARON', '18,342,896', align: TextAlign.right),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, {TextAlign align = TextAlign.left}) {
    return Column(
      crossAxisAlignment: align == TextAlign.right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 0.5)),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
      ],
    );
  }
}

class _CardDesglose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('Desglose de candidaturas',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
              Icon(Icons.filter_list, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),
          ...candidatos.asMap().entries.map((e) {
            final c = e.value;
            final isLast = e.key == candidatos.length - 1;
            return Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 22, backgroundColor: Colors.grey[200],
                        child: Text(c.nombre[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navyDark))),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.partido.toUpperCase(),
                              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.gold, letterSpacing: 0.5)),
                          Text(c.nombre,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${c.porcentaje.toStringAsFixed(3)}%',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
                        Text('${_fmt(c.votos)} votos',
                            style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                if (!isLast) ...[
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  const SizedBox(height: 8),
                ],
              ],
            );
          }),
          const Divider(height: 20),
          const Text('VIEW FULL TABLE ›',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.navyDark, letterSpacing: 1)),
        ],
      ),
    );
  }

  String _fmt(int n) {
    return n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}

class _CardProgreso extends StatelessWidget {
  final items = const [
    ('Total Actas (77,307)', '100.000%', 1.0),
    ('Actas Procesadas', '100.000%', 1.0),
    ('Actas Contabilizadas', '100.000%', 1.0),
    ('Para envío al JEE', '0.000%', 0.0),
    ('Por procesar', '0.000%', 0.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Detalle del progreso del escrutinio',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
          const SizedBox(height: 12),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(item.$1, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  Text(item.$2, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
                ]),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.$3,
                    backgroundColor: Colors.grey[100],
                    valueColor: const AlwaysStoppedAnimation(AppColors.navyDark),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// ─── TAB 2: Resultados Presidenciales ────────────────────────────────────────

class _ResultadosPresidenciales extends StatefulWidget {
  const _ResultadosPresidenciales();

  @override
  State<_ResultadosPresidenciales> createState() => _ResultadosPresidencialesState();
}

class _ResultadosPresidencialesState extends State<_ResultadosPresidenciales> {
  bool _peru = true;
  bool _glosario = false;

  @override
  Widget build(BuildContext context) {
    final lista = _peru ? candidatosPeru : candidatosExtranjero;
    final stats = _peru ? statsPeru : statsExtranjero;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('ACTUALIZADO EL 20/08/2016 A LAS 19:16 H',
            style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        const SizedBox(height: 12),
        _Toggle(value: _peru, onChanged: (v) => setState(() => _peru = v)),
        const SizedBox(height: 12),
        // Candidatos
        ...lista.asMap().entries.map((e) {
          final c = e.value;
          final isWinner = e.key == 0;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border(left: BorderSide(color: isWinner ? AppColors.gold : Colors.grey[200]!, width: 4)),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(radius: 26, backgroundColor: Colors.grey[200],
                    child: Text(c.nombre[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navyDark, fontSize: 18))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(c.partido.toUpperCase(),
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.gold, letterSpacing: 0.5)),
                  Text(c.nombre,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
                  Text('${_fmt(c.votos)} votos',
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ])),
                Text('${c.porcentaje.toStringAsFixed(3)}%',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
              ],
            ),
          );
        }),
        // Avance escrutinio
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.navyDark, borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('AVANCE DE ESCRUTINIO',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.2)),
              const SizedBox(height: 12),
              Row(children: [
                _escrutinioItem('TOTAL ACTAS', stats.totalActas, '100%'),
                _escrutinioItem('PROCESADAS', stats.procesadas, '100%'),
                _escrutinioItem('CONTABILIZADAS', stats.contabilizadas, '100%'),
              ]),
              const Divider(color: Color(0xFF2D4070), height: 24),
              const Text('PARTICIPACIÓN CIUDADANA',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1)),
              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('ELECTORES HÁBILES', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  Text(stats.electoresHabiles, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
                Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  const Text('PARTICIPANTES', style: TextStyle(fontSize: 9, color: Colors.grey)),
                  Text(stats.participantes, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white)),
                ]),
              ]),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('PORCENTAJE FINAL', style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text(stats.porcentajeFinal,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.gold)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Grid votos
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.5,
          children: [
            _VotoCard('Votos Válidos', stats.votosValidos, '${stats.pctValidos.toStringAsFixed(3)}% del total', true),
            _VotoCard('Votos Blancos', stats.votosBlancos, '${stats.pctBlancos.toStringAsFixed(3)}% del total', false),
            _VotoCard('Votos Nulos', stats.votosNulos, '${stats.pctNulos.toStringAsFixed(3)}% del total', false),
            _VotoCard('Total Emitidos', stats.totalEmitidos, '${stats.porcentajeFinal} part.', false),
          ],
        ),
        const SizedBox(height: 12),
        // Glosario
        _GlosarioCard(open: _glosario, onTap: () => setState(() => _glosario = !_glosario)),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _escrutinioItem(String label, String value, String pct) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(right: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: AppColors.navyMed, borderRadius: BorderRadius.circular(8)),
        child: Column(children: [
          Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white)),
          Text(pct, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.gold)),
        ]),
      ),
    );
  }

  String _fmt(int n) => n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

// ─── TAB 3: Resultado Por Tipo (con filtros en cascada) ──────────────────────

class _ResultadoPorTipo extends StatefulWidget {
  const _ResultadoPorTipo();

  @override
  State<_ResultadoPorTipo> createState() => _ResultadoPorTipoState();
}

class _ResultadoPorTipoState extends State<_ResultadoPorTipo> {
  bool _peru = true;
  bool _glosario = false;

  // Filtros Perú
  String? _departamento;
  String? _provincia;
  String? _distrito;

  // Filtros Extranjero
  String? _continente;
  String? _pais;
  String? _ciudad;

  // ── Cálculo de datos proporcionales ────────────────────────────────────────
  // Perú total oficial: Válidos 16,802,878 | Blancos 147,185 | Nulos 1,003,304 | Total 17,953,367
  static const _peruTotalValidos = 16802878;
  static const _peruTotalBlancos = 147185;
  static const _peruTotalNulos = 1003304;

  // Extranjero total: Válidos 362,162 | Blancos 15,820 | Nulos 11,547
  static const _extTotalValidos = 362162;
  static const _extTotalBlancos = 15820;
  static const _extTotalNulos = 11547;

  _VotoStats _calcStats() {
    if (_peru) {
      double peso = 1.0;
      if (_departamento != null) {
        peso = pesoDepartamento[_departamento] ?? 0.04;
        if (_provincia != null) peso *= 0.25;
        if (_distrito != null) peso *= 0.20;
      }
      final v = (_peruTotalValidos * peso).round();
      final b = (_peruTotalBlancos * peso).round();
      final n = (_peruTotalNulos * peso).round();
      final t = v + b + n;
      return _VotoStats(v, b, n, t);
    } else {
      final totalElectores = electoresContinente.values.fold(0, (a, b) => a + b);
      double peso = 1.0;
      if (_continente != null) {
        final electCont = electoresContinente[_continente] ?? 1;
        peso = electCont / totalElectores;
        if (_pais != null) {
          final paises = extranjeroGeo[_continente]!.keys.toList();
          peso *= 1 / paises.length;
        }
        if (_ciudad != null) {
          final ciudades = extranjeroGeo[_continente]![_pais]!;
          peso *= 1 / ciudades.length;
        }
      }
      final v = (_extTotalValidos * peso).round();
      final b = (_extTotalBlancos * peso).round();
      final n = (_extTotalNulos * peso).round();
      final t = v + b + n;
      return _VotoStats(v, b, n, t);
    }
  }

  String _fmt(int n) => n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    final data = _calcStats();
    final pctV = data.total > 0 ? (data.validos / data.total * 100) : 0.0;
    final pctB = data.total > 0 ? (data.blancos / data.total * 100) : 0.0;
    final pctN = data.total > 0 ? (data.nulos / data.total * 100) : 0.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Estado actas
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)]),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Actas Procesadas', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(children: [
                const Text('100%', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: const Color(0xFFE8F0FE), borderRadius: BorderRadius.circular(4)),
                  child: const Text('PROCESADO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.navyDark, letterSpacing: 0.5)),
                ),
              ]),
            ]),
            const Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('Actualizado', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey)),
              Text('20/06/2016 19:16 h', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ]),
          ]),
        ),
        const SizedBox(height: 12),

        // Toggle Perú / Extranjero
        _Toggle(value: _peru, onChanged: (v) => setState(() {
          _peru = v;
          _departamento = _provincia = _distrito = null;
          _continente = _pais = _ciudad = null;
        })),
        const SizedBox(height: 12),

        // Filtros en cascada
        _FilterCard(
          peru: _peru,
          departamento: _departamento,
          provincia: _provincia,
          distrito: _distrito,
          continente: _continente,
          pais: _pais,
          ciudad: _ciudad,
          onDepartamento: (v) => setState(() { _departamento = v; _provincia = null; _distrito = null; }),
          onProvincia: (v) => setState(() { _provincia = v; _distrito = null; }),
          onDistrito: (v) => setState(() => _distrito = v),
          onContinente: (v) => setState(() { _continente = v; _pais = null; _ciudad = null; }),
          onPais: (v) => setState(() { _pais = v; _ciudad = null; }),
          onCiudad: (v) => setState(() => _ciudad = v),
        ),
        const SizedBox(height: 12),

        // Composición de votos
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
              Text('Composición de Votos', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
              Icon(Icons.info_outline, color: AppColors.gold, size: 18),
            ]),
            const Text('Distribución porcentual total', style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 14),
            _barraVotos('Votos Válidos', pctV, AppColors.navyDark),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _barraVotos('Nulos', pctN, Colors.grey)),
              const SizedBox(width: 12),
              Expanded(child: _barraVotos('Blancos', pctB, Colors.grey[300]!)),
            ]),
          ]),
        ),
        const SizedBox(height: 12),

        // Card votos válidos
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.navyDark, borderRadius: BorderRadius.circular(12)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(children: const [
                Icon(Icons.check_circle, color: AppColors.gold, size: 18),
                SizedBox(width: 6),
                Text('Votos Válidos', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(4)),
                child: const Text('PRIMARY', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
              ),
            ]),
            const SizedBox(height: 10),
            Text(_fmt(data.validos), style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.white)),
            Text('${pctV.toStringAsFixed(3)}% del total',
                style: const TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(_locationLabel(), style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ]),
        ),
        const SizedBox(height: 12),

        // Blancos y nulos
        Row(children: [
          Expanded(child: _MiniCard('Blancos', _fmt(data.blancos), '${pctB.toStringAsFixed(3)}% del total')),
          const SizedBox(width: 12),
          Expanded(child: _MiniCard('Nulos', _fmt(data.nulos), '${pctN.toStringAsFixed(3)}% del total')),
        ]),
        const SizedBox(height: 12),

        // Total emitidos
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)]),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('TOTAL VOTOS EMITIDOS',
                style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
            Text(_fmt(data.total),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
          ]),
        ),
        const SizedBox(height: 12),

        // Nota
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            border: Border.all(color: AppColors.goldLight),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('ℹ', style: TextStyle(fontSize: 18, color: AppColors.gold)),
            SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Nota sobre Escrutinio', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
              SizedBox(height: 4),
              Text('Los votos válidos incluyen los votos emitidos por cada una de las organizaciones políticas participantes.',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
            ])),
          ]),
        ),
        const SizedBox(height: 12),
        _GlosarioCard(open: _glosario, onTap: () => setState(() => _glosario = !_glosario)),
        const SizedBox(height: 12),
      ],
    );
  }

  String _locationLabel() {
    if (_peru) {
      if (_distrito != null) return 'Distrito: $_distrito';
      if (_provincia != null) return 'Provincia: $_provincia';
      if (_departamento != null) return 'Departamento: $_departamento';
      return 'Total reportado en todos los distritos del país.';
    } else {
      if (_ciudad != null) return 'Ciudad: $_ciudad';
      if (_pais != null) return 'País: $_pais';
      if (_continente != null) return 'Continente: $_continente';
      return 'Total reportado en todas las sedes en el exterior.';
    }
  }

  Widget _barraVotos(String label, double pct, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.navyDark)),
        Text('${pct.toStringAsFixed(3)}%', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
      ]),
      const SizedBox(height: 4),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: (pct / 100).clamp(0.0, 1.0),
          backgroundColor: Colors.grey[100],
          valueColor: AlwaysStoppedAnimation(color),
          minHeight: 8,
        ),
      ),
    ]);
  }
}

class _VotoStats {
  final int validos, blancos, nulos, total;
  const _VotoStats(this.validos, this.blancos, this.nulos, this.total);
}

// ─── Widget de filtros en cascada ─────────────────────────────────────────────

class _FilterCard extends StatelessWidget {
  final bool peru;
  final String? departamento, provincia, distrito;
  final String? continente, pais, ciudad;
  final ValueChanged<String?> onDepartamento, onProvincia, onDistrito;
  final ValueChanged<String?> onContinente, onPais, onCiudad;

  const _FilterCard({
    required this.peru,
    this.departamento, this.provincia, this.distrito,
    this.continente, this.pais, this.ciudad,
    required this.onDepartamento, required this.onProvincia, required this.onDistrito,
    required this.onContinente, required this.onPais, required this.onCiudad,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('FILTRAR POR UBICACIÓN',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 12),
          if (peru) ...[
            _drop('DEPARTAMENTO', departamento, ['TODOS', ...peruGeo.keys],
                (v) => onDepartamento(v == 'TODOS' ? null : v)),
            if (departamento != null) ...[
              const SizedBox(height: 10),
              _drop('PROVINCIA', provincia,
                  ['TODOS', ...peruGeo[departamento]!.keys],
                  (v) => onProvincia(v == 'TODOS' ? null : v)),
            ],
            if (provincia != null) ...[
              const SizedBox(height: 10),
              _drop('DISTRITO', distrito,
                  ['TODOS', ...(peruGeo[departamento]![provincia] ?? [])],
                  (v) => onDistrito(v == 'TODOS' ? null : v)),
            ],
          ] else ...[
            _drop('CONTINENTE', continente, ['TODOS', ...extranjeroGeo.keys],
                (v) => onContinente(v == 'TODOS' ? null : v)),
            if (continente != null) ...[
              const SizedBox(height: 10),
              _drop('PAÍS', pais,
                  ['TODOS', ...extranjeroGeo[continente]!.keys],
                  (v) => onPais(v == 'TODOS' ? null : v)),
            ],
            if (pais != null) ...[
              const SizedBox(height: 10),
              _drop('CIUDAD', ciudad,
                  ['TODOS', ...(extranjeroGeo[continente]![pais] ?? [])],
                  (v) => onCiudad(v == 'TODOS' ? null : v)),
            ],
          ],
        ],
      ),
    );
  }

  Widget _drop(String label, String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1)),
      const SizedBox(height: 5),
      Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey[300]!), borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value ?? 'TODOS',
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.navyDark, size: 18),
            style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: onChanged,
          ),
        ),
      ),
    ]);
  }
}

// ─── Widgets compartidos ──────────────────────────────────────────────────────

class _Toggle extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  const _Toggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(4),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        _btn('Perú', value, () => onChanged(true)),
        _btn('Extranjero', !value, () => onChanged(false)),
      ]),
    );
  }

  Widget _btn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.navyDark : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: active ? Colors.white : Colors.grey)),
      ),
    );
  }
}

class _VotoCard extends StatelessWidget {
  final String label;
  final String value;
  final String pct;
  final bool highlight;
  const _VotoCard(this.label, this.value, this.pct, this.highlight);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900,
                color: highlight ? AppColors.navyDark : Colors.grey[700])),
        Text(pct, style: const TextStyle(fontSize: 9, color: Colors.grey)),
      ]),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final String label;
  final String value;
  final String pct;
  const _MiniCard(this.label, this.value, this.pct);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
        Text(pct, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ]),
    );
  }
}

class _GlosarioCard extends StatelessWidget {
  final bool open;
  final VoidCallback onTap;
  const _GlosarioCard({required this.open, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
      ),
      child: Column(children: [
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Glosario Electoral',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
              Icon(open ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
            ]),
          ),
        ),
        if (open)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: glosarioTerminos.map((t) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _GlosItem(t.$1, t.$2),
              )).toList(),
            ),
          ),
      ]),
    );
  }
}

class _GlosItem extends StatelessWidget {
  final String title;
  final String body;
  const _GlosItem(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.gold, letterSpacing: 0.5)),
      const SizedBox(height: 2),
      Text(body, style: const TextStyle(fontSize: 11, color: Colors.grey)),
    ]);
  }
}
