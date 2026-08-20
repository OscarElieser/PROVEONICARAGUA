import 'package:flutter/material.dart';

class ProviderDashboardScreen extends StatelessWidget {
	const ProviderDashboardScreen({super.key});
	@override
	Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Panel del proveedor')), body: const Center(child: Text('Resumen de tu empresa')));
}
