import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/mock_data.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  int step = 0;
  @override
  Widget build(BuildContext context) {
    const questions = ['¿Qué producto necesitas?', '¿En qué departamento estás?', '¿Qué priorizas?'];
    if (step >= questions.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Resultados PROVEO Match')),
        body: ListView(padding: const EdgeInsets.all(24), children: MockData.providers.take(3).toList().asMap().entries.map((entry) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: AppColors.paleGreen, child: Text('${94 - entry.key * 5}%')), title: Text(entry.value.name), subtitle: const Text('Buena reputación, cercanía y relación calidad-precio.')))).toList()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('PROVEO Match')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Text('Encuentra tu proveedor ideal', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(questions[step], style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        ...['Precio', 'Calidad', 'Rapidez', 'Cercanía'].map((option) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OutlinedButton(
              onPressed: () => setState(() => step++),
              child: Align(alignment: Alignment.centerLeft, child: Text(option)),
            ),
          );
        }),
      ]),
    );
  }
}
