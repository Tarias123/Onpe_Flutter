import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/geographic_data.dart';
import '../data/mock_data.dart';
import '../data/firestore_service.dart';

class ActasPage extends StatefulWidget {
  const ActasPage({super.key});

  @override
  State<ActasPage> createState() => _ActasPageState();
}

class _ActasPageState extends State<ActasPage> {
  bool _porUbigeo = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sub-header
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('MÓDULO DE CONSULTA',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1.5)),
            SizedBox(height: 2),
            Text('Búsqueda de Actas',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.navyDark)),
          ]),
        ),
        Expanded(
          child: _porUbigeo ? _UbigeoTab(onSwitch: _switchTab) : _NumeroTab(onSwitch: _switchTab),
        ),
      ],
    );
  }

  void _switchTab(bool ubigeo) => setState(() => _porUbigeo = ubigeo);
}

// ─── Toggle compartido ────────────────────────────────────────────────────────

class _TabToggle extends StatelessWidget {
  final bool porUbigeo;
  final ValueChanged<bool> onSwitch;

  const _TabToggle({required this.porUbigeo, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _btn('Por Ubigeo', porUbigeo, () => onSwitch(true)),
        _btn('Por Número', !porUbigeo, () => onSwitch(false)),
      ],
    );
  }

  Widget _btn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.navyDark : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: active ? null : Border.all(color: Colors.grey[300]!),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : Colors.grey[600],
            )),
      ),
    );
  }
}

// ─── TAB 1: Por Ubigeo ───────────────────────────────────────────────────────

class _UbigeoTab extends StatefulWidget {
  final ValueChanged<bool> onSwitch;
  const _UbigeoTab({required this.onSwitch});

  @override
  State<_UbigeoTab> createState() => _UbigeoTabState();
}

class _UbigeoTabState extends State<_UbigeoTab> {
  String _ambito = 'Perú';
  String? _departamento;
  String? _provincia;
  String? _distrito;
  bool _buscado = false;

  List<String> get _departamentos =>
      _ambito == 'Perú' ? peruGeo.keys.toList() : extranjeroGeo.keys.toList();

  List<String> get _provincias {
    if (_departamento == null) return [];
    if (_ambito == 'Perú') return peruGeo[_departamento]?.keys.toList() ?? [];
    return extranjeroGeo[_departamento]?.keys.toList() ?? [];
  }

  List<String> get _distritos {
    if (_departamento == null || _provincia == null) return [];
    if (_ambito == 'Perú') return peruGeo[_departamento]?[_provincia] ?? [];
    return extranjeroGeo[_departamento]?[_provincia] ?? [];
  }

  String get _label1 => _ambito == 'Perú' ? 'DEPARTAMENTO' : 'CONTINENTE';
  String get _label2 => _ambito == 'Perú' ? 'PROVINCIA' : 'PAÍS';
  String get _label3 => _ambito == 'Perú' ? 'DISTRITO' : 'CIUDAD';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _EstadoCard(),
        const SizedBox(height: 16),
        _TabToggle(porUbigeo: true, onSwitch: widget.onSwitch),
        const SizedBox(height: 16),
        _formCard(),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => setState(() => _buscado = true),
            icon: const Icon(Icons.search, size: 18),
            label: const Text('BUSCAR ACTAS',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 1)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navyDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_buscado) ...[
          _ResultadosUbigeoCard(
            departamento: _departamento ?? _ambito,
            provincia: _provincia,
            distrito: _distrito,
          ),
          const SizedBox(height: 16),
        ],
        _InfoCard('Información de Consulta',
            'Seleccione los filtros para visualizar el detalle de las actas procesadas por la Oficina Nacional de Procesos Electorales.'),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _formCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        _dropdown('ÁMBITO', _ambito, ['Perú', 'Extranjero'],
            (v) => setState(() { _ambito = v!; _departamento = null; _provincia = null; _distrito = null; _buscado = false; })),
        const SizedBox(height: 14),
        _dropdown(_label1, _departamento, _departamentos,
            (v) => setState(() { _departamento = v; _provincia = null; _distrito = null; _buscado = false; }),
            hint: 'Seleccionar $_label1'),
        const SizedBox(height: 14),
        _dropdown(_label2, _provincia, _provincias,
            _departamento == null ? null : (v) => setState(() { _provincia = v; _distrito = null; _buscado = false; }),
            hint: 'Seleccionar $_label2'),
        const SizedBox(height: 14),
        _dropdown(_label3, _distrito, _distritos,
            _provincia == null ? null : (v) => setState(() { _distrito = v; _buscado = false; }),
            hint: 'Seleccionar $_label3'),
      ]),
    );
  }

  Widget _dropdown(String label, String? value, List<String> items, ValueChanged<String?>? onChanged, {String? hint}) {
    final disabled = onChanged == null || items.isEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700,
              color: disabled ? Colors.grey[400] : Colors.grey, letterSpacing: 1)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: disabled ? Colors.grey[200]! : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: disabled ? Colors.grey[50] : Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            hint: Text(hint ?? '', style: TextStyle(fontSize: 13, color: disabled ? Colors.grey[400] : Colors.black54)),
            icon: Icon(Icons.keyboard_arrow_down, color: disabled ? Colors.grey[400] : AppColors.navyDark),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: disabled ? null : onChanged,
          ),
        ),
      ),
    ]);
  }
}

// ─── TAB 2: Por Número ───────────────────────────────────────────────────────

class _NumeroTab extends StatefulWidget {
  final ValueChanged<bool> onSwitch;
  const _NumeroTab({required this.onSwitch});

  @override
  State<_NumeroTab> createState() => _NumeroTabState();
}

class _NumeroTabState extends State<_NumeroTab> {
  final _controller = TextEditingController();
  bool _buscado = false;
  String _error = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _buscar() {
    final numero = _controller.text.trim();
    if (numero.length < 6) {
      setState(() { _error = 'Ingrese los 6 dígitos del número de acta.'; _buscado = false; });
      return;
    }
    setState(() { _error = ''; _buscado = true; });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Sub-título
        const Text('Búsqueda de Actas por Número',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
        const SizedBox(height: 14),
        // Toggle
        _TabToggle(porUbigeo: false, onSwitch: widget.onSwitch),
        const SizedBox(height: 16),
        // Estado del sistema
        _EstadoCard(label: 'SISTEMA EN VIVO'),
        const SizedBox(height: 16),
        // Input número
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('INGRESE EL NÚMERO DE ACTA',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1)),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.navyDark, letterSpacing: 8),
              decoration: InputDecoration(
                counterText: '',
                hintText: '000000',
                hintStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.grey[300], letterSpacing: 8),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey[300]!)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.navyDark, width: 2)),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            if (_error.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(_error, style: const TextStyle(fontSize: 12, color: Colors.red)),
            ],
          ]),
        ),
        const SizedBox(height: 12),
        // Botón buscar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _buscar,
            icon: const Icon(Icons.search, size: 18),
            label: const Text('Buscar Acta',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.navyDark,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
          ),
        ),
        if (_buscado) ...[
          const SizedBox(height: 16),
          _ResultadoActaCard(numero: _controller.text.trim()),
        ],
        const SizedBox(height: 12),
        // Nota dígitos
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8E1),
            border: Border.all(color: AppColors.goldLight),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Icon(Icons.info_outline, color: AppColors.gold, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'El número de acta consta de 6 dígitos y se encuentra en la parte superior derecha del documento físico.',
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
          ]),
        ),
        const SizedBox(height: 16),
        // Imagen edificio ONPE
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Image.asset(
                'assets/images/onpe_edificio.jpg',
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  color: Colors.black54,
                  child: const Text(
                    'Oficina Nacional de Procesos Electorales – Transparencia 2016',
                    style: TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Contacto institucional
        Column(children: [
          const Icon(Icons.account_balance, size: 36, color: AppColors.navyDark),
          const SizedBox(height: 8),
          const Text('CONTACTO INSTITUCIONAL',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.navyDark, letterSpacing: 0.5)),
          const SizedBox(height: 8),
          const Text('Central Telefónica: (01) 417-0630',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const Text('Jr. Washington 1894, Cercado de Lima',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 4),
          const Text('www.onpe.gob.pe',
              style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 16),
      ],
    );
  }
}

// ─── Resultado Por Ubigeo ─────────────────────────────────────────────────────

class _ResultadosUbigeoCard extends StatelessWidget {
  final String departamento;
  final String? provincia;
  final String? distrito;
  const _ResultadosUbigeoCard({required this.departamento, this.provincia, this.distrito});

  @override
  Widget build(BuildContext context) {
    final actas = [
      {'numero': '014521', 'mesa': '0145-A', 'estado': 'Contabilizada', 'local': 'I.E. San Martín'},
      {'numero': '014522', 'mesa': '0145-B', 'estado': 'Contabilizada', 'local': 'I.E. San Martín'},
      {'numero': '014523', 'mesa': '0146-A', 'estado': 'Observada',     'local': 'I.E. Gran Unidad'},
      {'numero': '014524', 'mesa': '0146-B', 'estado': 'Contabilizada', 'local': 'I.E. Gran Unidad'},
      {'numero': '014525', 'mesa': '0147-A', 'estado': 'Contabilizada', 'local': 'C.E. Los Andes'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.list_alt, color: AppColors.navyDark, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Actas en ${distrito ?? provincia ?? departamento}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.navyDark),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppColors.navyDark, borderRadius: BorderRadius.circular(20)),
            child: Text('${actas.length} actas',
                style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ]),
        const Divider(height: 20),
        ...actas.map((a) => _actaRow(a)),
      ]),
    );
  }

  Widget _actaRow(Map<String, String> acta) {
    final esObservada = acta['estado'] == 'Observada';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        Icon(
          esObservada ? Icons.warning_amber_rounded : Icons.check_circle_outline,
          color: esObservada ? Colors.orange : Colors.green,
          size: 18,
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Acta N° ${acta['numero']}  •  Mesa ${acta['mesa']}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
          Text(acta['local']!, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ])),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: esObservada ? const Color(0xFFFFF3E0) : const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(acta['estado']!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: esObservada ? Colors.orange : Colors.green,
              )),
        ),
      ]),
    );
  }
}

// ─── Resultado Acta por Número ────────────────────────────────────────────────

class _ResultadoActaCard extends StatelessWidget {
  final String numero;
  const _ResultadoActaCard({required this.numero});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          const Text('ACTA ENCONTRADA',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.green, letterSpacing: 1)),
        ]),
        const Divider(height: 20),
        _fila('Número de Acta', numero),
        _fila('Mesa de Sufragio', '${numero.substring(0, 4)}-A'),
        _fila('Local de Votación', 'I.E. Gran Unidad Escolar'),
        _fila('Distrito', 'Lima'),
        _fila('Provincia', 'Lima'),
        _fila('Departamento', 'Lima'),
        _fila('Estado', 'Contabilizada'),
        const Divider(height: 20),
        const Text('VOTOS REGISTRADOS',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
        const SizedBox(height: 10),
        _votoFila('Pedro Pablo Kuczynski', 'Peruanos por el Kambio', '152'),
        const SizedBox(height: 8),
        _votoFila('Keiko Fujimori', 'Fuerza Popular', '143'),
        const SizedBox(height: 8),
        _fila('Votos Blancos', '3'),
        _fila('Votos Nulos', '2'),
        _fila('Total Emitidos', '300'),
      ]),
    );
  }

  Widget _fila(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(valor, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
      ]),
    );
  }

  Widget _votoFila(String nombre, String partido, String votos) {
    return Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(partido, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.gold, letterSpacing: 0.5)),
        Text(nombre, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
      ])),
      Text('$votos votos', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
    ]);
  }
}

// ─── Widgets compartidos ──────────────────────────────────────────────────────

class _EstadoCard extends StatelessWidget {
  final String label;
  const _EstadoCard({this.label = 'ESTADO DEL SISTEMA'});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RegionalStats?>(
      stream: FirestoreService.stats('peru'),
      builder: (context, snap) {
        final s = snap.data ?? statsPeru;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Header
            Row(children: [
              const Icon(Icons.fact_check_outlined, color: AppColors.gold, size: 20),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label,
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
                const Text('ACTUALIZADO EL 20/06/2016 A LAS 19:16 h',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(20)),
                child: Row(children: const [
                  Icon(Icons.circle, color: Colors.green, size: 8),
                  SizedBox(width: 4),
                  Text('EN LÍNEA', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.green, letterSpacing: 0.5)),
                ]),
              ),
            ]),
            const Divider(height: 18),
            // Conteos de actas desde Firestore
            Row(children: [
              _actaStat('TOTAL ACTAS',         s.totalActas,     AppColors.navyDark),
              _divider(),
              _actaStat('PROCESADAS',          s.procesadas,     Colors.green),
              _divider(),
              _actaStat('CONTABILIZADAS',      s.contabilizadas, Colors.green),
            ]),
            const SizedBox(height: 10),
            // Barra de progreso 100%
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 1.0,
                minHeight: 5,
                backgroundColor: Colors.grey[100],
                valueColor: const AlwaysStoppedAnimation(Colors.green),
              ),
            ),
            const SizedBox(height: 6),
            const Text('100.000% de actas procesadas',
                style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600)),
          ]),
        );
      },
    );
  }

  Widget _actaStat(String label, String value, Color color) {
    return Expanded(
      child: Column(children: [
        Text(label, style: const TextStyle(fontSize: 8, color: Colors.grey, letterSpacing: 0.5), textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: color), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _divider() => Container(width: 1, height: 30, color: Colors.grey[200]);
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String body;
  const _InfoCard(this.title, this.body);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        border: Border.all(color: AppColors.goldLight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Icon(Icons.info_outline, color: AppColors.gold, size: 18),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.navyDark)),
          const SizedBox(height: 4),
          Text(body, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ])),
      ]),
    );
  }
}
