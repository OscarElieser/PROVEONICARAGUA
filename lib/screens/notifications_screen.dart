// ==============================================================================
// PROVEO NICARAGUA - Centro de Notificaciones y Alertas B2B (lib/screens/notifications_screen.dart)
// ¿Qué hace?: Presenta las alertas transaccionales (cotizaciones aceptadas, mensajes de chat y promociones) y su estado de lectura.
// ¿Por qué se utiliza?: Mantiene a los compradores y proveedores al tanto de los eventos clave en tiempo real.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa el encabezado y pie de página globales
import '../core/widgets/premium_header.dart';
import '../core/widgets/premium_footer.dart';

/// Pantalla del centro de notificaciones para eventos transaccionales y mensajes B2B.
class NotificationsScreen extends StatefulWidget {
  /// Constructor constante
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  /// Lista local de notificaciones de prueba para simular eventos en la plataforma
  final List<Map<String, dynamic>> _mockNotifications = [
    {
      'id': '1',
      'title': 'Cotización Aceptada',
      'message':
          'El proveedor Disagro S.A. ha aceptado tu solicitud de cotización para "Semillas de Maíz".',
      'time': 'Hace 5 min',
      'icon': Icons.check_circle_outline,
      'color': AppColors.trustGreen,
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'Nuevo Mensaje',
      'message':
          'Tienes un nuevo mensaje B2B de Macesa respecto a tu pedido reciente.',
      'time': 'Hace 2 horas',
      'icon': Icons.chat_bubble_outline,
      'color': AppColors.blue,
      'isRead': false,
    },
    {
      'id': '3',
      'title': 'Promoción Exclusiva',
      'message':
          'Descubre nuevos proveedores de maquinaria agrícola con un 10% de descuento este mes.',
      'time': 'Ayer',
      'icon': Icons.local_offer_outlined,
      'color': AppColors.teal,
      'isRead': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Notificaciones'),
      body: CustomScrollView(
        slivers: [
          // ------------------------------------------------------------------
          // 1. SECCIÓN PRINCIPAL: Título y Lista de Notificaciones
          // ------------------------------------------------------------------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notificaciones',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.navy,
                          letterSpacing: -0.5,
                        ),
                      ),
                      // Botón para marcar todas las notificaciones como leídas
                      TextButton.icon(
                        onPressed: () {
                          setState(() {
                            for (var notif in _mockNotifications) {
                              notif['isRead'] = true;
                            }
                          });
                        },
                        icon: const Icon(Icons.done_all_rounded, color: AppColors.trustGreen, size: 20),
                        label: const Text(
                          'Marcar todas leídas',
                          style: TextStyle(
                            color: AppColors.trustGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mantente al tanto de tus cotizaciones y conexiones B2B.',
                    style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  // Si no hay notificaciones muestra estado vacío, de lo contrario lista las tarjetas
                  if (_mockNotifications.isEmpty)
                    _buildEmptyState()
                  else
                    ..._mockNotifications.map((notif) => _buildNotificationCard(notif)),
                ],
              ),
            ),
          ),

          // ------------------------------------------------------------------
          // 2. PIE DE PÁGINA UNIVERSAL
          // ------------------------------------------------------------------
          const SliverToBoxAdapter(child: PremiumFooter()),
        ],
      ),
    );
  }

  /// Construye el estado vacío cuando no existen notificaciones en la bandeja
  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tienes notificaciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.navy),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aquí aparecerán alertas importantes sobre tus proveedores y cotizaciones.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  /// Construye una tarjeta interactiva para cada notificación
  Widget _buildNotificationCard(Map<String, dynamic> notif) {
    final bool isRead = notif['isRead'];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : notif['color'].withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRead ? AppColors.border : notif['color'].withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: isRead
            ? null
            : [
                BoxShadow(
                  color: notif['color'].withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            setState(() {
              notif['isRead'] = true; // Marca como leída al pulsar
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icono circular con color temático
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: notif['color'].withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(notif['icon'], color: notif['color'], size: 24),
                ),
                const SizedBox(width: 16),
                // Contenido textual de la notificación
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notif['title'],
                            style: TextStyle(
                              fontWeight: isRead ? FontWeight.w600 : FontWeight.w800,
                              fontSize: 15,
                              color: AppColors.navy,
                            ),
                          ),
                          Text(
                            notif['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: isRead ? AppColors.textSecondary : notif['color'],
                              fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notif['message'],
                        style: TextStyle(
                          fontSize: 13,
                          color: isRead ? AppColors.textSecondary : AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                // Indicador circular de no leído
                if (!isRead) ...[
                  const SizedBox(width: 12),
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: notif['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}