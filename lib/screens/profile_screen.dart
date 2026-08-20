import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_widgets.dart';
import '../models/models.dart';

class ProfileScreen extends StatelessWidget {
  final AuthUser user;
  final Future<void> Function() onSignOut;

  const ProfileScreen({super.key, required this.user, required this.onSignOut});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Mi perfil')),
        body: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            PremiumCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppColors.paleBlue,
                    child: Text(
                      _initials,
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name,
                            style: Theme.of(context).textTheme.titleLarge),
                        Text('${user.role.name}  •  ${user.email}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Mi actividad'),
            const SizedBox(height: 12),
            const StatCard(
                value: '12', label: 'Búsquedas activas', icon: Icons.search),
            const SizedBox(height: 12),
            const StatCard(
              value: '8',
              label: 'Proveedores guardados',
              icon: Icons.bookmark_outline,
              accent: AppColors.trustGreen,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onSignOut,
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ],
        ),
      );

  String get _initials {
    final names = user.name.trim().split(RegExp(r'\s+'));
    if (names.length == 1) {
      return names.first
          .substring(0, names.first.length.clamp(0, 2))
          .toUpperCase();
    }
    return '${names.first[0]}${names.last[0]}'.toUpperCase();
  }
}
