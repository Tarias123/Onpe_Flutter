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

class _ResumenGeneral extends StatefulWidget {
  const _ResumenGeneral();

  @override
  State<_ResumenGeneral> createState() => _ResumenGeneralState();
}

class _ResumenGeneralState extends State<_ResumenGeneral> {
  bool _esExtranjero = false;

  @override
  Widget build(BuildContext context) {
    final stats = _esExtranjero ? statsExtranjero : statsPeru;
    final lista = _esExtranjero ? candidatosExtranjero : candidatosPeru;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Toggle Perú / Extranjero
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 6)],
          ),
          padding: const EdgeInsets.all(4),
          child: Row(children: [
            _toggleBtn('PERÚ', !_esExtranjero, () => setState(() => _esExtranjero = false)),
            _toggleBtn('EXTRANJERO', _esExtranjero, () => setState(() => _esExtranjero = true)),
          ]),
        ),
        const SizedBox(height: 12),
        // Estado actual
        _CardEstado(stats: stats),
        const SizedBox(height: 12),
        // Participación ciudadana
        _CardParticipacion(stats: stats),
        const SizedBox(height: 12),
        // Desglose candidaturas
        _CardDesglose(candidatos: lista, stats: stats),
        const SizedBox(height: 12),
        // Progreso escrutinio
        _CardProgreso(stats: stats),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _toggleBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? AppColors.navyDark : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: active ? Colors.white : Colors.grey,
                letterSpacing: 0.5,
              )),
        ),
      ),
    );
  }
}

class _CardEstado extends StatelessWidget {
  final RegionalStats stats;
  const _CardEstado({required this.stats});

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
            children: [
              const Text('Actos contabilizados', style: TextStyle(fontSize: 11, color: Color(0xFF5A3A00))),
              Text('${stats.contabilizadas} / ${stats.totalActas}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF5A3A00))),
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
          const Text('ULTIMA ACTUALIZACIÓN: 20/06/2016 – 19:16:00',
              style: TextStyle(fontSize: 9, color: Color(0xFF7A5000), letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _CardParticipacion extends StatelessWidget {
  final RegionalStats stats;
  const _CardParticipacion({required this.stats});

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
            children: [
              Text(stats.porcentajeFinal,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
              const SizedBox(width: 8),
              const Icon(Icons.person, color: Colors.grey, size: 24),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statItem('VOTANTES ELEGIBLES', stats.electoresHabiles),
              _statItem('CIUDADANOS QUE VOTARON', stats.participantes, align: TextAlign.right),
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
  final List<Candidato> candidatos;
  final RegionalStats stats;
  const _CardDesglose({required this.candidatos, required this.stats});

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
                    CircleAvatar(radius: 22, backgroundImage: AssetImage(c.foto)),
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
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const _FullTableSheet(),
            ),
            child: const Text('VIEW FULL TABLE ›',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.navyDark, letterSpacing: 1)),
          ),
        ],
      ),
    );
  }

  String _fmt(int n) {
    return n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}

// ─── Full Table Sheet ─────────────────────────────────────────────────────────

class _FullTableSheet extends StatelessWidget {
  const _FullTableSheet();

  String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            // Título
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Tabla de Resultados',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text('Segunda Elección Presidencial 2016 – Resultados Oficiales ONPE',
                  style: TextStyle(fontSize: 11, color: Colors.grey)),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(20),
                children: [
                  // Tabla candidatos
                  _seccionTitulo('RESULTADOS POR CANDIDATO'),
                  const SizedBox(height: 10),
                  _tablaHeader(['Candidato', '% Válidos', '% Emitidos', 'Votos']),
                  ...candidatos.map((c) => _tablaFila(
                    candidato: c,
                    porcentaje: '${c.porcentaje.toStringAsFixed(3)}%',
                    pctEmitidos: '${c.porcentajeEmitidos.toStringAsFixed(3)}%',
                    votos: _fmt(c.votos),
                    ganador: c.porcentaje > 50,
                  )),
                  const SizedBox(height: 24),
                  // Tabla resumen votos
                  _seccionTitulo('RESUMEN DE VOTOS'),
                  const SizedBox(height: 10),
                  _resumenCard([
                    ('Total Electores Hábiles', statsPeru.electoresHabiles, null),
                    ('Ciudadanos que Votaron', statsPeru.participantes, statsPeru.porcentajeFinal),
                    ('Ausentismo', '4,559,058', statsPeru.ausentismo),
                  ]),
                  const SizedBox(height: 16),
                  _seccionTitulo('TIPO DE VOTO'),
                  const SizedBox(height: 10),
                  _resumenCard([
                    ('Votos Válidos', statsPeru.votosValidos, '${statsPeru.pctValidos}%'),
                    ('Votos Blancos', statsPeru.votosBlancos, '${statsPeru.pctBlancos}%'),
                    ('Votos Nulos', statsPeru.votosNulos, '${statsPeru.pctNulos}%'),
                    ('Total Emitidos', statsPeru.totalEmitidos, '100.000%'),
                  ]),
                  const SizedBox(height: 24),
                  // Tabla actas
                  _seccionTitulo('ESTADO DE ACTAS'),
                  const SizedBox(height: 10),
                  _resumenCard([
                    ('Total Actas', statsPeru.totalActas, '100.000%'),
                    ('Actas Procesadas', statsPeru.procesadas, '100.000%'),
                    ('Actas Contabilizadas', statsPeru.contabilizadas, '100.000%'),
                    ('Para envío al JEE', '0', '0.000%'),
                    ('Por procesar', '0', '0.000%'),
                  ]),
                  const SizedBox(height: 16),
                  const Text('Fuente: ONPE – web.onpe.gob.pe | Actualizado: 20/06/2016 a las 19:16 h',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccionTitulo(String titulo) {
    return Text(titulo,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1));
  }

  Widget _tablaHeader(List<String> cols) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppColors.navyDark, borderRadius: BorderRadius.circular(8)),
      child: Row(children: [
        Expanded(flex: 3, child: Text(cols[0], style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))),
        Expanded(child: Text(cols[1], textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))),
        Expanded(child: Text(cols[2], textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))),
        Expanded(child: Text(cols[3], textAlign: TextAlign.right, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white))),
      ]),
    );
  }

  Widget _tablaFila({required Candidato candidato, required String porcentaje, required String pctEmitidos, required String votos, bool ganador = false}) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: ganador ? const Color(0xFFFFF8E1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: ganador ? Border.all(color: AppColors.goldLight) : null,
      ),
      child: Row(children: [
        Expanded(flex: 3, child: Row(children: [
          CircleAvatar(radius: 14, backgroundImage: AssetImage(candidato.foto)),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(candidato.nombre, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
            if (ganador) const Text('GANADOR', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.gold, letterSpacing: 0.5)),
          ])),
        ])),
        Expanded(child: Text(porcentaje, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.navyDark))),
        Expanded(child: Text(pctEmitidos, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, color: Colors.grey))),
        Expanded(child: Text(votos, textAlign: TextAlign.right, style: const TextStyle(fontSize: 10, color: Colors.grey))),
      ]),
    );
  }

  Widget _resumenCard(List<(String, String, String?)> filas) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: filas.asMap().entries.map((e) {
          final fila = e.value;
          final isLast = e.key == filas.length - 1;
          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Text(fila.$1, style: const TextStyle(fontSize: 12, color: Colors.grey))),
                Text(fila.$2, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
                if (fila.$3 != null) ...[
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 64,
                    child: Text(fila.$3!, textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w600)),
                  ),
                ],
              ]),
            ),
            if (!isLast) Divider(height: 1, color: Colors.grey[200]),
          ]);
        }).toList(),
      ),
    );
  }
}

class _CardProgreso extends StatelessWidget {
  final RegionalStats stats;
  const _CardProgreso({required this.stats});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Total Actas (${stats.totalActas})', '100.000%', 1.0),
      ('Actas Procesadas', '100.000%', 1.0),
      ('Actas Contabilizadas', '100.000%', 1.0),
      ('Para envío al JEE', '0.000%', 0.0),
      ('Por procesar', '0.000%', 0.0),
    ];
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
                CircleAvatar(radius: 26, backgroundImage: AssetImage(c.foto)),
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
