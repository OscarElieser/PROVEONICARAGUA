import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'comparison_screen.dart';
class QuotationsScreen extends StatelessWidget { const QuotationsScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Mis cotizaciones'), actions: [TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComparisonScreen())), child: const Text('Comparar'))]), body: ListView(padding: const EdgeInsets.all(24), children: [...MockData.quotations.map((q) => Card(child: ListTile(title: Text(q.provider), subtitle: Text('${q.deliveryDays} días  •  ${q.rating} ★  •  ${q.distance} km'), trailing: Text('C\$${q.price.toStringAsFixed(0)}'))))])); }
