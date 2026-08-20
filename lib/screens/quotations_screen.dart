import 'package:flutter/material.dart';
import '../services/firebase/firestore_repository.dart';
import 'comparison_screen.dart';

class QuotationsScreen extends StatelessWidget {
  const QuotationsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mis cotizaciones'), actions: [TextButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComparisonScreen())), child: const Text('Comparar'))]),
        body: FutureBuilder(
          future: FirestoreRepository().getQuotations(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Center(child: Text('No pudimos cargar tus cotizaciones.'));
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            final quotations = snapshot.data!;
            if (quotations.isEmpty) return const Center(child: Text('Aún no tienes cotizaciones.'));
            return ListView(padding: const EdgeInsets.all(24), children: quotations.map((quotation) => Card(child: ListTile(title: Text(quotation.provider), subtitle: Text('${quotation.deliveryDays} días  •  ${quotation.rating} ★  •  ${quotation.distance} km'), trailing: Text('C\$${quotation.price.toStringAsFixed(0)}')))).toList());
          },
        ),
      );
}
