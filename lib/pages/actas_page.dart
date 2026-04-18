import 'package:flutter/material.dart';
import '../theme.dart';

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
  String? _ambito = 'Perú';
  String? _departamento;
  String? _provincia;
  String? _distrito;
  String? _local;

  final _departamentos = ['Lima', 'Arequipa', 'Cusco', 'La Libertad', 'Piura', 'Puno', 'Junín'];
  final _provincias = ['Lima', 'Callao', 'Huaral', 'Cañete', 'Huarochirí'];
  final _distritos = ['Miraflores', 'San Isidro', 'Barranco', 'Surco', 'La Molina'];
  final _locales = ['Local A', 'Local B', 'Local C'];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Estado del sistema
        _EstadoCard(),
        const SizedBox(height: 16),
        // Toggle
        _TabToggle(porUbigeo: true, onSwitch: widget.onSwitch),
        const SizedBox(height: 16),
        // Formulario
        _formCard(),
        const SizedBox(height: 12),
        // Botón buscar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
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
        // Info
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
        _dropdown('ÁMBITO', _ambito, ['Perú', 'Extranjero'], (v) => setState(() => _ambito = v)),
        const SizedBox(height: 14),
        _dropdown('DEPARTAMENTO', _departamento, _departamentos,
            (v) => setState(() { _departamento = v; _provincia = null; _distrito = null; _local = null; }),
            hint: 'Seleccionar Departamento'),
        const SizedBox(height: 14),
        _dropdown('PROVINCIA', _provincia, _provincias,
            (v) => setState(() { _provincia = v; _distrito = null; _local = null; }),
            hint: 'Seleccionar Provincia'),
        const SizedBox(height: 14),
        _dropdown('DISTRITO', _distrito, _distritos,
            (v) => setState(() { _distrito = v; _local = null; }),
            hint: 'Seleccionar Distrito'),
        const SizedBox(height: 14),
        _dropdown('LOCAL DE VOTACIÓN', _local, _locales,
            (v) => setState(() => _local = v),
            hint: 'Seleccionar Local'),
      ]),
    );
  }

  Widget _dropdown(String label, String? value, List<String> items, ValueChanged<String?> onChanged, {String? hint}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.grey, letterSpacing: 1)),
      const SizedBox(height: 6),
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value,
            hint: Text(hint ?? value ?? '', style: const TextStyle(fontSize: 13, color: Colors.black87)),
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.navyDark),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
            onChanged: onChanged,
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          ]),
        ),
        const SizedBox(height: 12),
        // Botón buscar
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {},
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
        // Imagen edificio ONPE (placeholder — reemplazar con imagen real)
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.account_balance, size: 64, color: Colors.grey),
                ),
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

// ─── Widgets compartidos ──────────────────────────────────────────────────────

class _EstadoCard extends StatelessWidget {
  final String label;
  const _EstadoCard({this.label = 'ESTADO DEL SISTEMA'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        const Icon(Icons.access_time, color: AppColors.gold, size: 20),
        const SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1)),
          const Text('ACTUALIZADO EL 20/06/2016 A LAS 19:16 h',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navyDark)),
        ]),
      ]),
    );
  }
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
