import 'package:flutter/material.dart';

/// Logo oficial encapsulado para poder sustituir el asset sin tocar pantallas.
class ProveoLogo extends StatelessWidget {
	final double height;
	const ProveoLogo({super.key, this.height = 48});
	@override
	Widget build(BuildContext context) => Semantics(label: 'Logo PROVEO', image: true, child: Image.asset('assets/logo/proveo_logo.png', height: height));
}
