import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';
import '../services/firebase/firestore_repository.dart';

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
    if (step >= questions.length) return _results();
    return Scaffold(
      appBar: AppBar(title: const Text('PROVEO Match')),
      body: ListView(padding: const EdgeInsets.all(24), children: [
        Text('Encuentra tu proveedor ideal', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 12),
        Text(questions[step], style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        ...['Precio', 'Calidad', 'Rapidez', 'Cercanía'].map((option) => Padding(padding: const EdgeInsets.only(bottom: 10), child: OutlinedButton(onPressed: () => setState(() => step++), child: Align(alignment: Alignment.centerLeft, child: Text(option))))),
      ]),
    );
  }

  Widget _results() => Scaffold(
        appBar: AppBar(title: const Text('Resultados PROVEO Match')),
        body: FutureBuilder<List<ProviderModel>>(
          future: FirestoreRepository().getProviders(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Center(child: Text('No pudimos cargar los proveedores.'));
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            if (snapshot.data!.isEmpty) return const Center(child: Text('Aún no hay proveedores publicados.'));
            return ListView(padding: const EdgeInsets.all(24), children: snapshot.data!.take(5).toList().asMap().entries.map((entry) => Card(child: ListTile(leading: CircleAvatar(backgroundColor: AppColors.paleGreen, child: Text('${(entry.value.rating * 20).round()}%')), title: Text(entry.value.name), subtitle: Text('Recomendado por reputación, experiencia y ubicación.')))).toList());
          },
        ),
      );
}
