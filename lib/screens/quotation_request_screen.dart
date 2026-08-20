import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_widgets.dart';

/// Flujo de solicitud con progreso visible y campos preparados para Firestore.
class QuotationRequestScreen extends StatefulWidget {
  const QuotationRequestScreen({super.key});
  @override
  State<QuotationRequestScreen> createState() => _QuotationRequestScreenState();
}

class _QuotationRequestScreenState extends State<QuotationRequestScreen> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    final title = step == 0 ? 'Cuéntanos qué necesitas' : step == 1 ? 'Selecciona proveedores' : 'Cotizaciones recibidas';
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva solicitud de cotización')),
      body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900), child: ListView(padding: const EdgeInsets.all(24), children: [
        _Progress(step: step),
        const SizedBox(height: 24),
        PremiumCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          const Text('Mientras más detalles compartas, mejores serán las recomendaciones.', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          if (step == 0) ..._detailsFields(),
          if (step == 1) ..._providerChoices(),
          if (step == 2) ..._quotationSummary(),
          const SizedBox(height: 24),
          Align(alignment: Alignment.centerRight, child: FilledButton.icon(onPressed: _continue, icon: Icon(step == 2 ? Icons.check : Icons.arrow_forward), label: Text(step == 2 ? 'Finalizar solicitud' : 'Continuar'))),
        ])),
      ]))),
    );
  }

  void _continue() {
    if (step < 2) {
      setState(() => step++);
    } else {
      Navigator.pop(context);
    }
  }

  List<Widget> _detailsFields() => const [
        TextField(decoration: InputDecoration(labelText: '¿Qué producto o servicio necesitas?', hintText: 'Ej. Empaque plástico para alimentos')),
        SizedBox(height: 14),
        TextField(maxLines: 4, decoration: InputDecoration(labelText: 'Descripción detallada', hintText: 'Comparte características, materiales o requisitos')),
        SizedBox(height: 14),
        Row(children: [Expanded(child: TextField(decoration: InputDecoration(labelText: 'Cantidad aproximada'))), SizedBox(width: 12), Expanded(child: TextField(decoration: InputDecoration(labelText: 'Presupuesto estimado')))]),
        SizedBox(height: 14),
        TextField(decoration: InputDecoration(labelText: 'Ubicación de entrega', prefixIcon: Icon(Icons.location_on_outlined))),
        SizedBox(height: 14),
        Text('Características adicionales', style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(height: 8),
        Wrap(spacing: 8, children: [Chip(label: Text('Apto para alimentos')), Chip(label: Text('Transparente')), Chip(label: Text('Con tapa')), Chip(label: Text('Resistente'))]),
      ];

  List<Widget> _providerChoices() => const [
        CheckboxListTile(value: true, onChanged: null, title: Text('PlastiPack Nicaragua'), subtitle: Text('4.8 ★  •  Responde en 2 horas')),
        CheckboxListTile(value: true, onChanged: null, title: Text('Evanplast S.A.'), subtitle: Text('4.6 ★  •  Responde en 3 horas')),
        CheckboxListTile(value: true, onChanged: null, title: Text('Innoplast'), subtitle: Text('4.5 ★  •  Responde en 3 horas')),
      ];

  List<Widget> _quotationSummary() => const [
        ListTile(leading: Icon(Icons.check_circle, color: AppColors.trustGreen), title: Text('Solicitud lista para enviar'), subtitle: Text('3 proveedores seleccionados')),
        Divider(),
        Text('Recibirás las cotizaciones en esta sección y en tus notificaciones.', style: TextStyle(color: AppColors.textSecondary)),
      ];
}

class _Progress extends StatelessWidget {
  final int step;
  const _Progress({required this.step});
  @override
  Widget build(BuildContext context) => Row(children: [_node('1', 'Detalles', step >= 0), _line(step >= 1), _node('2', 'Proveedores', step >= 1), _line(step >= 2), _node('3', 'Cotizaciones', step >= 2)]);
  Widget _node(String number, String label, bool active) => Expanded(child: Column(children: [CircleAvatar(radius: 16, backgroundColor: active ? AppColors.navy : AppColors.border, child: Text(number, style: TextStyle(color: active ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.w800))), const SizedBox(height: 6), Text(label, style: TextStyle(fontSize: 12, color: active ? AppColors.navy : AppColors.textSecondary, fontWeight: active ? FontWeight.w700 : FontWeight.w400))]));
  Widget _line(bool active) => Expanded(child: Container(height: 2, color: active ? AppColors.trustGreen : AppColors.border));
}
