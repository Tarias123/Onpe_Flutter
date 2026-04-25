import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../data/firestore_service.dart';

class ParticipacionPage extends StatefulWidget {
  const ParticipacionPage({super.key});

  @override
  State<ParticipacionPage> createState() => _ParticipacionPageState();
}

class _ParticipacionPageState extends State<ParticipacionPage> {
  // null = vista general, 'extranjero' o 'nacional'
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sub-header fijo
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('Participacion Ciudadana',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
            SizedBox(height: 2),
            Row(children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey),
              SizedBox(width: 4),
              Text('ACTUALIZADO: 20/06/2016 19:16 H',
                  style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
            ]),
          ]),
        ),
        Expanded(
          child: _selected == null
              ? _VistaGeneral(onSelect: (v) => setState(() => _selected = v))
              : _VistaDetalle(
                  selected: _selected!,
                  onSelect: (v) => setState(() => _selected = v),
                ),
        ),
      ],
    );
  }
}

// ─── Vista General (pantalla inicial) ─────────────────────────────────────────

class _VistaGeneral extends StatelessWidget {
  final ValueChanged<String> onSelect;
  const _VistaGeneral({required this.onSelect});

  int _parseNum(String s) => int.tryParse(s.replaceAll(',', '')) ?? 0;
  double _parsePct(String s) => double.tryParse(s.replaceAll('%', '')) ?? 0.0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RegionalStats?>(
      stream: FirestoreService.stats('peru'),
      builder: (context, snap) {
        final s = snap.data ?? statsPeru;
        final pct       = _parsePct(s.porcentajeFinal);
        final electores = _parseNum(s.electoresHabiles);
        final particip  = _parseNum(s.participantes);
        final ausentes  = electores - particip;
        final pctAus    = _parsePct(s.ausentismo);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Electores hábiles
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('ELECTORES HÁBILES',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(s.electoresHabiles,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
                ]),
                const Icon(Icons.person_outline, size: 40, color: Colors.grey),
              ]),
            ),
            const SizedBox(height: 16),
            // Gráfico donut
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
              ),
              child: Column(children: [
                _DonutChart(porcentaje: pct),
                const SizedBox(height: 20),
                const Divider(),
                const SizedBox(height: 12),
                _statRow(Icons.circle, Colors.green, 'Participación', s.participantes, s.porcentajeFinal),
                const SizedBox(height: 10),
                _statRow(Icons.remove_circle_outline, Colors.grey, 'Ausentismo',
                    _fmt(ausentes), '${pctAus.toStringAsFixed(3)}%'),
              ]),
            ),
            const SizedBox(height: 20),
            // Accesos por región
            const Text('ACCESOS POR REGIÓN',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.5)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _AccesoBtn(
                label: 'Voto Extranjero',
                icon: Icons.public,
                active: false,
                onTap: () => onSelect('extranjero'),
              )),
              const SizedBox(width: 12),
              Expanded(child: _AccesoBtn(
                label: 'Voto Nacional',
                icon: Icons.account_balance,
                active: false,
                onTap: () => onSelect('nacional'),
              )),
            ]),
            const SizedBox(height: 16),
            // Nota
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Los datos presentados corresponden a las actas procesadas por el sistema oficial. Las cifras se actualizan en tiempo real conforme avanza el escrutinio.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  String _fmt(int n) => n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  Widget _statRow(IconData icon, Color color, String label, String value, String pct) {
    return Row(children: [
      Icon(icon, size: 12, color: color),
      const SizedBox(width: 8),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87))),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
      const SizedBox(width: 8),
      Text(pct, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    ]);
  }
}

// ─── Vista Detalle (Extranjero o Nacional) ─────────────────────────────────────

class _VistaDetalle extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelect;
  const _VistaDetalle({required this.selected, required this.onSelect});

  bool get esExtranjero => selected == 'extranjero';

  int _parseNum(String s) => int.tryParse(s.replaceAll(',', '')) ?? 0;
  double _parsePct(String s) => double.tryParse(s.replaceAll('%', '')) ?? 0.0;
  String _fmt(int n) => n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

  @override
  Widget build(BuildContext context) {
    final ambito   = esExtranjero ? 'extranjero' : 'peru';
    final mockStat = esExtranjero ? statsExtranjero : statsPeru;

    return StreamBuilder<RegionalStats?>(
      stream: FirestoreService.stats(ambito),
      builder: (context, snap) {
        final s        = snap.data ?? mockStat;
        final pct      = _parsePct(s.porcentajeFinal);
        final electores = _parseNum(s.electoresHabiles);
        final particip  = _parseNum(s.participantes);
        final ausentes  = electores - particip;
        final pctAus   = _parsePct(s.ausentismo);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Botones de selección
            Row(children: [
              Expanded(child: _AccesoBtn(
                label: 'Voto Extranjero',
                icon: Icons.public,
                active: esExtranjero,
                onTap: () => onSelect('extranjero'),
              )),
              const SizedBox(width: 12),
              Expanded(child: _AccesoBtn(
                label: 'Voto Nacional',
                icon: Icons.account_balance,
                active: !esExtranjero,
                onTap: () => onSelect('nacional'),
              )),
            ]),
            const SizedBox(height: 16),

            // Última actualización
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFDE7),
                border: Border.all(color: AppColors.goldLight),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(children: [
                const Icon(Icons.table_chart_outlined, color: AppColors.gold, size: 20),
                const SizedBox(width: 10),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text('ULTIMA ACTUALIZACIÓN',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
                  Text('Actas Contabilizadas',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
                  Text('20 de Junio de 2016 - 19:16 hrs',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                ])),
              ]),
            ),
            const SizedBox(height: 10),

            // Porcentaje actas
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('100.000%',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
                Text(
                  '${s.totalActas} de ${s.totalActas} ACTAS',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                  textAlign: TextAlign.right,
                ),
              ]),
            ),
            const SizedBox(height: 16),

            // Resumen de participación
            const Text('RESUMEN DE PARTICIPACIÓN',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.5)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
              ),
              child: Column(children: [
                _DonutChart(porcentaje: pct),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: _miniStat('ASISTENTES',
                      s.participantes, s.porcentajeFinal, Colors.green)),
                  Expanded(child: _miniStat('AUSENTISMO',
                      _fmt(ausentes), '${pctAus.toStringAsFixed(3)}%', Colors.grey)),
                ]),
              ]),
            ),
            const SizedBox(height: 16),

            // Población electoral
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.navyDark, borderRadius: BorderRadius.circular(12)),
              child: Stack(children: [
                Positioned(right: 0, bottom: 0,
                  child: Icon(Icons.person_outline, size: 70, color: Colors.white.withAlpha(20))),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('POBLACIÓN ELECTORAL',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.2)),
                  const SizedBox(height: 6),
                  Text(
                    s.electoresHabiles,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                  const Text('Total de Electores Hábiles',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                ]),
              ]),
            ),
            const SizedBox(height: 16),

            // Lista por continente o departamento
            esExtranjero ? _ListaContinentes() : _ListaDepartamentos(),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _miniStat(String label, String value, String pct, Color dotColor) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: dotColor)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
        Text(pct, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ]),
    );
  }
}

// ─── Lista Continentes (Extranjero) ───────────────────────────────────────────

class _ListaContinentes extends StatelessWidget {
  final _data = const [
    ('América', Icons.public, 596128, 285422, 47.8, 310706, 52.2),
    ('Europa', Icons.public, 249321, 92442, 37.1, 156879, 62.9),
    ('Asia', Icons.public, 33965, 10885, 32.1, 23080, 67.9),
    ('Oceanía', Icons.public, 4812, 725, 15.1, 4087, 84.9),
    ('África', Icons.public, 698, 48, 6.9, 650, 93.1),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
          Text('Resultados por Continente',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
        ]),
        const SizedBox(height: 10),
        ..._data.map((c) => _ContinenteCard(
          nombre: c.$1,
          icon: c.$2,
          electores: c.$3,
          asistentes: c.$4,
          pctAsis: c.$5,
          ausentes: c.$6,
          pctAus: c.$7,
        )),
      ],
    );
  }
}

class _ContinenteCard extends StatelessWidget {
  final String nombre;
  final IconData icon;
  final int electores, asistentes, ausentes;
  final double pctAsis, pctAus;

  const _ContinenteCard({
    required this.nombre, required this.icon,
    required this.electores, required this.asistentes,
    required this.pctAsis, required this.ausentes, required this.pctAus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Icon(icon, size: 20, color: AppColors.navyDark),
            const SizedBox(width: 8),
            Text(nombre, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('ELECTORES', style: TextStyle(fontSize: 9, color: Colors.grey, letterSpacing: 0.5)),
            Text(_fmt(electores), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
          ]),
        ]),
        const SizedBox(height: 8),
        const Divider(height: 1),
        const SizedBox(height: 8),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('ASISTENTES', style: TextStyle(fontSize: 9, color: Colors.grey, letterSpacing: 0.5)),
            Text(_fmt(asistentes), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
            Text('${pctAsis.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ])),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('AUSENTES', style: TextStyle(fontSize: 9, color: Colors.grey, letterSpacing: 0.5)),
            Text(_fmt(ausentes), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
            Text('${pctAus.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 11, color: Colors.grey)),
          ])),
        ]),
      ]),
    );
  }

  String _fmt(int n) => n.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

// ─── Lista Departamentos (Nacional) ───────────────────────────────────────────

class _ListaDepartamentos extends StatelessWidget {
  final _data = const [
    ('LIM', 'Lima', 86.305),
    ('AQP', 'Arequipa', 85.791),
    ('ANC', 'Ancash', 77.302),
    ('APU', 'Apurímac', 72.300),
    ('AMA', 'Amazonas', 71.540),
    ('AYA', 'Ayacucho', 70.892),
    ('CAJ', 'Cajamarca', 69.430),
    ('CUS', 'Cusco', 68.210),
    ('HUC', 'Huánuco', 67.890),
    ('ICA', 'Ica', 66.540),
    ('JUN', 'Junín', 65.320),
    ('LAL', 'La Libertad', 64.780),
    ('LAM', 'Lambayeque', 63.210),
    ('LOR', 'Loreto', 60.100),
    ('MDD', 'Madre de Dios', 58.430),
    ('MOQ', 'Moquegua', 88.120),
    ('PAS', 'Pasco', 62.340),
    ('PIU', 'Piura', 71.230),
    ('PUN', 'Puno', 69.870),
    ('SAM', 'San Martín', 66.210),
    ('TAC', 'Tacna', 82.560),
    ('TUM', 'Tumbes', 74.320),
    ('UCA', 'Ucayali', 59.870),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: const [
          Text('PARTICIPACIÓN POR DEPARTAMENTO',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1)),
          Icon(Icons.filter_list, color: Colors.grey, size: 20),
        ]),
        const SizedBox(height: 10),
        ..._data.map((d) => _DeptoRow(codigo: d.$1, nombre: d.$2, pct: d.$3)),
      ],
    );
  }
}

class _DeptoRow extends StatelessWidget {
  final String codigo, nombre;
  final double pct;
  const _DeptoRow({required this.codigo, required this.nombre, required this.pct});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 6)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(4)),
              child: Text(codigo, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
            ),
            const SizedBox(width: 8),
            Text(nombre, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
          ]),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('PARTICIPACIÓN', style: TextStyle(fontSize: 9, color: Colors.grey, letterSpacing: 0.5)),
            Text('${pct.toStringAsFixed(3)}%',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
          ]),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: pct / 100,
            minHeight: 4,
            backgroundColor: Colors.grey[100],
            valueColor: const AlwaysStoppedAnimation(AppColors.gold),
          ),
        ),
      ]),
    );
  }
}

// ─── Botón de acceso ──────────────────────────────────────────────────────────

class _AccesoBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  const _AccesoBtn({required this.label, required this.icon, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.navyDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: active ? AppColors.navyDark : Colors.grey[300]!),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 6)],
        ),
        child: Column(children: [
          const Text('ESCRUTINIO',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 6),
          Icon(icon, size: 22, color: active ? Colors.white : AppColors.navyDark),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w800,
                color: active ? Colors.white : AppColors.navyDark,
              ),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ─── Donut Chart ──────────────────────────────────────────────────────────────

class _DonutChart extends StatelessWidget {
  final double porcentaje;
  const _DonutChart({required this.porcentaje});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(alignment: Alignment.center, children: [
        CustomPaint(size: const Size(160, 160), painter: _DonutPainter(porcentaje / 100)),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text('${porcentaje.toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
          const Text('PARTICIPACIÓN',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1)),
        ]),
      ]),
    );
  }
}

class _DonutPainter extends CustomPainter {
  final double value;
  const _DonutPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = size.width / 2 - 10;
    const strokeWidth = 18.0;

    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final fgPaint = Paint()
      ..color = AppColors.gold
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);
    canvas.drawArc(rect, -pi / 2, 2 * pi, false, bgPaint);
    canvas.drawArc(rect, -pi / 2, 2 * pi * value, false, fgPaint);
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.value != value;
}
