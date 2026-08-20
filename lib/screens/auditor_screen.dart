import 'package:flutter/material.dart';

class AuditorScreen extends StatelessWidget {
	const AuditorScreen({super.key});
	@override
	Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Auditoría')), body: const Center(child: Text('Modo auditoría — Solo lectura')));
}
