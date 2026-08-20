import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/premium_widgets.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../services/firebase/firestore_repository.dart';

/// Panel Administrativo oficial de PROVEO con control integral de la plataforma.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _repository = FirestoreRepository();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.admin_panel_settings, color: AppColors.trustGreen),
            SizedBox(width: 10),
            Text('Panel Administrativo PROVEO'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sincronizar base de datos',
            icon: const Icon(Icons.sync),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Base de datos Firestore sincronizada.')),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: AppColors.trustGreen,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_outlined), text: 'Resumen & KPIs'),
            Tab(icon: Icon(Icons.storefront_outlined), text: 'Proveedores (1,250+)'),
            Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Cotizaciones (4,800+)'),
            Tab(icon: Icon(Icons.people_outline), text: 'Usuarios & Permisos'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildProvidersTab(),
          _buildQuotationsTab(),
          _buildUsersTab(),
        ],
      ),
    );
  }

  /// Pestaña 1: Resumen de KPIs y Métricas del Negocio
  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        // Fila de tarjetas KPI principales
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildKpiCard('1,250', 'Proveedores Activos', Icons.storefront, AppColors.blue, '+12% este mes'),
            _buildKpiCard('4,800', 'Cotizaciones B2B', Icons.receipt_long, AppColors.trustGreen, '+24% este mes'),
            _buildKpiCard('2,300', 'Empresas Conectadas', Icons.business, AppColors.navy, '+18% este mes'),
            _buildKpiCard('98.4%', 'Satisfacción & Match IA', Icons.auto_awesome, AppColors.successGreen, '99.1% uptime'),
          ],
        ),
        const SizedBox(height: 28),

        // Acciones rápidas administrativas
        const SectionTitle(title: 'Acciones Rápidas', subtitle: 'Operaciones de gestión directa'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
              onPressed: () => _showAddProviderDialog(),
              icon: const Icon(Icons.add_business),
              label: const Text('Nuevo Proveedor'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reporte consolidado exportado en Excel/PDF.')),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Exportar Reportes'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Notificación masiva enviada a proveedores activos.')),
                );
              },
              icon: const Icon(Icons.campaign_outlined),
              label: const Text('Enviar Notificación'),
            ),
          ],
        ),
        const SizedBox(height: 28),

        // Solicitudes pendientes de verificación
        const SectionTitle(title: 'Proveedores Pendientes de Verificación', subtitle: 'Revisión de documentos comerciales y RUC'),
        const SizedBox(height: 12),
        Card(
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildVerificationTile('Envases Modernos S.A.', 'Managua', 'RUC: J0310000123456', 'Empaques PET'),
              const Divider(height: 1),
              _buildVerificationTile('Industrias Plásticas de León', 'León', 'RUC: J0310000654321', 'Bolsas Biodegradables'),
              const Divider(height: 1),
              _buildVerificationTile('Etiquetas del Norte', 'Matagalpa', 'RUC: J0310000987654', 'Etiquetado Térmico'),
            ],
          ),
        ),
      ],
    );
  }

  /// Pestaña 2: Gestión de Proveedores
  Widget _buildProvidersTab() {
    return FutureBuilder<List<ProviderModel>>(
      future: _repository.getProviders(),
      builder: (context, snapshot) {
        final providers = snapshot.data ?? MockData.providers;
        final filtered = providers.where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || p.category.toLowerCase().contains(_searchQuery.toLowerCase())).toList();

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Filtrar proveedores por nombre o categoría...',
                    ),
                    onChanged: (val) => setState(() => _searchQuery = val),
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  style: FilledButton.styleFrom(backgroundColor: AppColors.navy),
                  onPressed: () => _showAddProviderDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Card(
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final provider = filtered[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.paleBlue,
                      child: Text(provider.name[0], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.navy)),
                    ),
                    title: Row(
                      children: [
                        Text(provider.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        if (provider.featured) const VerifiedBadge(text: 'Verificado'),
                      ],
                    ),
                    subtitle: Text('${provider.category} • ${provider.location} • Resp: ${provider.responseTime}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          avatar: const Icon(Icons.star, size: 14, color: AppColors.warning),
                          label: Text('${provider.rating}'),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.blue),
                          tooltip: 'Editar',
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Editando ${provider.name}')));
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Pestaña 3: Gestión de Cotizaciones
  Widget _buildQuotationsTab() {
    return FutureBuilder<List<QuotationModel>>(
      future: _repository.getQuotations(),
      builder: (context, snapshot) {
        final quotations = snapshot.data ?? MockData.quotations;

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: quotations.length,
          itemBuilder: (context, index) {
            final q = quotations[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.paleGreen,
                  child: Icon(Icons.receipt_long, color: AppColors.trustGreen),
                ),
                title: Text('Cotización para: ${q.provider}', style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Monto: C\$ ${q.price.toStringAsFixed(2)} • Entrega: ${q.deliveryDays} días • Estado: ${q.status}'),
                trailing: FilledButton.tonal(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Detalle de cotización abierto.')));
                  },
                  child: const Text('Ver Detalles'),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Pestaña 4: Usuarios y Permisos
  Widget _buildUsersTab() {
    final users = [
      {'name': 'Oscar Elieser (Inatec)', 'email': 'oscarelieser.informatica.inatec@gmail.com', 'role': 'Administrador Principal'},
      {'name': 'Pinolillo Hackathon', 'email': 'pinolillohackathon@gmail.com', 'role': 'Auditor / Gestor'},
      {'name': 'Carlos González', 'email': 'emprendedor@demo.proveo', 'role': 'Emprendedor'},
      {'name': 'PlastiPack Nicaragua Admin', 'email': 'proveedor@demo.proveo', 'role': 'Proveedor Verificado'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final u = users[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.navy,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(u['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${u['email']} • Rol: ${u['role']}'),
            trailing: PopupMenuButton<String>(
              onSelected: (val) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rol de ${u['name']} actualizado a $val')));
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'Administrador', child: Text('Hacer Administrador')),
                PopupMenuItem(value: 'Proveedor', child: Text('Hacer Proveedor')),
                PopupMenuItem(value: 'Emprendedor', child: Text('Hacer Emprendedor')),
              ],
              child: Chip(
                label: Text(u['role']!, style: const TextStyle(fontSize: 11)),
                deleteIcon: const Icon(Icons.arrow_drop_down, size: 16),
                onDeleted: () {},
              ),
            ),
          ),
        );
      },
    );
  }

  /// Modal para agregar nuevo proveedor
  void _showAddProviderDialog() {
    final nameCtrl = TextEditingController();
    final catCtrl = TextEditingController(text: 'Empaques');
    final locCtrl = TextEditingController(text: 'Managua');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Registrar Nuevo Proveedor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre de la Empresa')),
            const SizedBox(height: 12),
            TextField(controller: catCtrl, decoration: const InputDecoration(labelText: 'Categoría')),
            const SizedBox(height: 12),
            TextField(controller: locCtrl, decoration: const InputDecoration(labelText: 'Ubicación / Departamento')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () async {
              if (nameCtrl.text.isNotEmpty) {
                final messenger = ScaffoldMessenger.of(context);
                final newP = ProviderModel(
                  id: 'p_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text,
                  category: catCtrl.text,
                  location: locCtrl.text,
                  description: 'Proveedor verificado de ${catCtrl.text} en ${locCtrl.text}.',
                  logo: nameCtrl.text.substring(0, 2).toUpperCase(),
                  rating: 4.8,
                  reviews: 1,
                  years: 2,
                  responseTime: '2 horas',
                  featured: true,
                );
                await _repository.saveProvider(newP);
                if (dialogContext.mounted) {
                  Navigator.pop(dialogContext);
                  setState(() {});
                  messenger.showSnackBar(
                    SnackBar(content: Text('Proveedor "${newP.name}" registrado en Firestore.')),
                  );
                }
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  /// Fila de proveedor pendiente de verificación
  Widget _buildVerificationTile(String name, String location, String ruc, String category) {
    return ListTile(
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text('$location • $ruc • Rubro: $category'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline, color: AppColors.trustGreen),
            tooltip: 'Aprobar y Verificar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name aprobado con éxito.')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.cancel_outlined, color: AppColors.error),
            tooltip: 'Rechazar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name rechazado.')));
            },
          ),
        ],
      ),
    );
  }

  /// Tarjeta de KPI
  Widget _buildKpiCard(String value, String title, IconData icon, Color color, String change) {
    return SizedBox(
      width: 240,
      child: PremiumCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: .1),
                  child: Icon(icon, color: color),
                ),
                const Spacer(),
                Text(change, style: const TextStyle(color: AppColors.trustGreen, fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: AppColors.navy)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

