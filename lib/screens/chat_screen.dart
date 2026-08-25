// ==============================================================================
// PROVEO NICARAGUA - Sala de Negociación y Asistente IA B2B (lib/screens/chat_screen.dart)
// ¿Qué hace?: Combina dos canales: 1) Asistente inteligente Gemini para consultas y auditoría en redes sociales, y 2) Canal directo de chat con proveedores para cotizar y negociar pedidos.
// ¿Por qué se utiliza?: Permite cerrar acuerdos comerciales rápidamente, resolver dudas técnicas de materiales y auditar la reputación digital del fabricante en vivo.
// ==============================================================================

// Importa los componentes visuales de Flutter
import 'package:flutter/material.dart';

// Importa los tokens de color corporativos
import '../core/theme/app_colors.dart';

// Importa el encabezado global
import '../core/widgets/premium_header.dart';

// Importa los modelos del dominio de datos
import '../models/models.dart';

// Importa los datos de prueba
import '../data/mock_data.dart';

// Importa los servicios de inteligencia artificial y auditoría de empresas
import '../services/ai/company_intelligence_service.dart';

// Importa las pantallas de navegación
import 'quotation_request_screen.dart';
import 'provider_profile_screen.dart';

/// Pantalla de Chat interactivo con Asistente Inteligente Gemini y Mensajería B2B Multi-Empresa.
class ChatScreen extends StatefulWidget {
  /// Proveedor inicial con el que se inicia la conversación (opcional)
  final ProviderModel? initialProvider;

  /// Constructor constante
  const ChatScreen({super.key, this.initialProvider});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  /// Controlador de pestañas (Asistente IA vs Proveedor Directo)
  late final TabController _tabController;

  /// Controlador para la entrada de texto del mensaje
  final _messageController = TextEditingController();

  /// Servicio para compilar auditorías digitales y reputación de empresas
  final _intelService = CompanyIntelligenceService();

  /// Proveedor activo con el que se está conversando en la segunda pestaña
  late ProviderModel _currentProvider;
  
  /// Lista de mensajes en la conversación con Gemini AI
  final List<Map<String, dynamic>> _aiMessages = [
    {
      'isUser': false,
      'text':
          '¡Hola! Soy el **Asistente Inteligente B2B de PROVEO** potenciado por Google Gemini e Inteligencia Digital Multiplataforma. 🤖🌐\n\nEstoy conectado para auditar en tiempo real **Google, Facebook, Instagram, TikTok, YouTube y solvencia fiscal en Nicaragua** de cualquier empresa o proveedor que desees cotizar.\n\n¿Qué empresa o material deseas analizar hoy?',
      'time': 'Ahora',
    }
  ];

  /// Mapa de mensajes por cada proveedor para persistencia durante la sesión de usuario
  final Map<String, List<Map<String, dynamic>>> _messagesByProvider = {};

  /// Bandera de estado de generación del asistente Gemini
  bool _isTypingAi = false;

  /// Bandera de estado de respuesta del ejecutivo del proveedor
  bool _isProviderTyping = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _currentProvider = widget.initialProvider ?? MockData.providers.first;

    // Mensajes iniciales por defecto para PlastiPack
    _messagesByProvider['PlastiPack Nicaragua'] = [
      {
        'isUser': false,
        'text':
            'Estimado cliente, bienvenido al canal directo B2B de **PlastiPack Nicaragua**. Contamos con stock listo de galoneras HDPE, frascos PET y empaques grado alimenticio con entrega inmediata.',
        'time': '10:15 AM'
      },
      {
        'isUser': true,
        'text': 'Hola, ¿tienen disponibilidad para despacho de 2,500 unidades en Managua esta semana?',
        'time': '10:18 AM'
      },
      {
        'isUser': false,
        'text':
            '¡Sí con gusto! Tenemos despacho programado en 48 a 72 horas con flete bonificado dentro de Managua. ¿Deseas que generemos la cotización formal?',
        'time': '10:20 AM'
      },
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Recupera o inicializa la lista de mensajes correspondiente al proveedor activo
  List<Map<String, dynamic>> get _currentProviderMessages {
    return _messagesByProvider.putIfAbsent(_currentProvider.name, () => [
      {
        'isUser': false,
        'text':
            'Hola, te comunicas con el equipo de ventas de **${_currentProvider.name}** (${_currentProvider.location}). ¿En qué producto o cotización podemos ayudarte?',
        'time': 'Ahora',
      }
    ]);
  }

  /// Envía la consulta a Gemini con integración de auditoría digital de empresas
  /// Envía la consulta al Motor de Inteligencia y Razonamiento B2B de PROVEO
  Future<void> _sendAiMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    setState(() {
      _aiMessages.add({
        'isUser': true,
        'text': query,
        'time': 'Ahora',
      });
      _isTypingAi = true;
    });
    _messageController.clear();

    try {
      final response = await _intelService.processIntelligentAiQuery(
        query,
        currentCompany: _currentProvider.name,
      );

      if (mounted) {
        setState(() {
          _aiMessages.add({
            'isUser': false,
            'text': response,
            'time': 'Ahora',
          });
          _isTypingAi = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _aiMessages.add({
            'isUser': false,
            'text': _intelService.generateNegotiationStrategy(query, targetCompany: _currentProvider.name),
            'time': 'Ahora',
          });
          _isTypingAi = false;
        });
      }
    }
  }

  /// Envía mensaje al proveedor y genera una respuesta realista inteligente
  Future<void> _sendProviderMessage(String text) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    setState(() {
      _currentProviderMessages.add({
        'isUser': true,
        'text': cleanText,
        'time': 'Ahora',
      });
      _isProviderTyping = true;
    });
    _messageController.clear();

    // Simula tiempo de respuesta realista del ejecutivo comercial del proveedor
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    String reply;
    final lower = cleanText.toLowerCase();

    if (lower.contains('precio') || lower.contains('cuanto') || lower.contains('cuesta') || lower.contains('cotiz')) {
      reply =
          'Con gusto. Para darte nuestro mejor precio por escala de volumen en **${_currentProvider.name}**, ¿podrías indicarnos la cantidad estimada y si requieres entrega en Managua o departamentos?';
    } else if (lower.contains('tiempo') || lower.contains('entrega') || lower.contains('demora') || lower.contains('cuando')) {
      reply =
          'Nuestro tiempo promedio de entrega es de **${_currentProvider.responseTime}** para atención y despacho en **${_currentProvider.name.contains('PlastiPack') ? '3 a 4 días hábiles' : '4 a 6 días'}**. Contamos con flota propia.';
    } else if (lower.contains('muestra') || lower.contains('ver') || lower.contains('ficha') || lower.contains('catalogo')) {
      reply =
          'Podemos enviarte muestras físicas a tu oficina o puedes consultar nuestra ficha técnica y catálogo completo directamente en nuestro perfil verificado.';
    } else if (lower.contains('pago') || lower.contains('credito') || lower.contains('transferencia')) {
      reply =
          'Aceptamos transferencias BAC/LAFISE/Banpro, pago contra entrega para pedidos iniciales y línea de crédito comercial a 30 días para compras recurrentes.';
    } else {
      reply =
          'Recibido. Un asesor corporativo de **${_currentProvider.name}** está revisando tu requerimiento para darte respuesta inmediata.';
    }

    setState(() {
      _currentProviderMessages.add({
        'isUser': false,
        'text': reply,
        'time': 'Ahora',
      });
      _isProviderTyping = false;
    });
  }

  /// Abre el modal de Dossier de Inteligencia Digital IA
  void _openCompanyDossier(BuildContext context, String companyName) {
    final intel = _intelService.getCompanyIntelligence(companyName);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CompanyIntelligenceModal(intel: intel),
    );
  }

  /// Selector de empresa para el chat de proveedores
  void _showProviderSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront_rounded, color: AppColors.navy, size: 24),
                const SizedBox(width: 10),
                const Text(
                  'Seleccionar Empresa Proveedora',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.navy),
                ),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Elige con qué proveedor deseas chatear y cotizar al 100% con respaldo de IA:',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: MockData.providers.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final p = MockData.providers[index];
                  final isSelected = p.id == _currentProvider.id;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: isSelected ? AppColors.trustGreen : AppColors.navy,
                      child: Text(p.logo, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    title: Text(p.name, style: TextStyle(fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700, fontSize: 14)),
                    subtitle: Text('${p.category} • ${p.location} • ${p.rating}★', style: const TextStyle(fontSize: 11)),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.trustGreen)
                        : const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                    onTap: () {
                      setState(() {
                        _currentProvider = p;
                      });
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const PremiumHeader(currentPage: 'Chat B2B'),
      body: Column(
        children: [
          // Barra de Pestañas (Asistente IA vs Proveedor Directo)
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.navy,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.trustGreen,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5),
              tabs: [
                const Tab(icon: Icon(Icons.auto_awesome, size: 20), text: 'Asistente IA (Gemini & Redes)'),
                Tab(icon: const Icon(Icons.chat_bubble_outline, size: 20), text: _currentProvider.name),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAiChatTab(),
                _buildProviderChatTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Pestaña interactiva de chat con Gemini AI + Auditoría Digital
  Widget _buildAiChatTab() {
    return Column(
      children: [
        // Banner con estado de conexión a Internet y Redes Sociales
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.navy, AppColors.teal],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.navy.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.trustGreen.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.public_rounded, color: AppColors.trustGreen, size: 16),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'IA Conectada • Auditoría en tiempo real: Google Search, Facebook, Instagram, TikTok y YouTube.',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),

        // Sugerencias de auditoría rápida
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _quickPromptChip('🔍 Auditar redes de PlastiPack (FB, IG, TikTok, YT)', color: AppColors.trustGreen),
              const SizedBox(width: 8),
              _quickPromptChip('📊 Verificar RUC y Solvencia Fiscal DGI'),
              const SizedBox(width: 8),
              _quickPromptChip('💡 Estrategia de negociación de precios'),
              const SizedBox(width: 8),
              _quickPromptChip('🏢 Comparar PlastiPack vs Evanplast'),
            ],
          ),
        ),

        // Lista de mensajes
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _aiMessages.length + (_isTypingAi ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _aiMessages.length && _isTypingAi) {
                return _buildTypingIndicator(title: 'Gemini está auditando redes y datos en Google...');
              }
              final msg = _aiMessages[index];
              return _buildMessageBubble(
                text: msg['text'] as String,
                isUser: msg['isUser'] as bool,
                time: msg['time'] as String,
              );
            },
          ),
        ),

        // Barra de entrada de texto
        _buildInputBar(
          onSend: _sendAiMessage,
          hint: 'Pregunta a Gemini o pide auditar cualquier empresa en redes...',
        ),
      ],
    );
  }

  /// Pestaña de chat con proveedor (100% interactivo)
  Widget _buildProviderChatTab() {
    return Column(
      children: [
        // Header de la empresa con botón de Dossier IA y Cambio de Proveedor
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ProviderProfileScreen(provider: _currentProvider)),
                  );
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.navy,
                  radius: 20,
                  child: Text(
                    _currentProvider.logo,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _currentProvider.name,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.navy),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_rounded, color: AppColors.trustGreen, size: 16),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'En línea • Respuesta habitual: ${_currentProvider.responseTime} • ${_currentProvider.location}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Botón Dossier Inteligencia IA
              FilledButton.tonalIcon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.paleGreen,
                  foregroundColor: AppColors.navy,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => _openCompanyDossier(context, _currentProvider.name),
                icon: const Icon(Icons.auto_awesome, size: 15, color: AppColors.trustGreen),
                label: const Text('Dossier IA', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
              ),
              const SizedBox(width: 6),

              // Botón Cambiar Empresa
              IconButton(
                tooltip: 'Cambiar de Empresa',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.paleBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.swap_horiz_rounded, color: AppColors.navy, size: 20),
                onPressed: () => _showProviderSelector(context),
              ),
            ],
          ),
        ),

        // Lista de mensajes con el proveedor
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _currentProviderMessages.length + (_isProviderTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _currentProviderMessages.length && _isProviderTyping) {
                return _buildTypingIndicator(title: '${_currentProvider.name} está redactando una respuesta...');
              }
              final msg = _currentProviderMessages[index];
              return _buildMessageBubble(
                text: msg['text'] as String,
                isUser: msg['isUser'] as bool,
                time: msg['time'] as String,
                providerName: _currentProvider.name,
              );
            },
          ),
        ),

        // Barra de entrada al proveedor
        _buildInputBar(
          onSend: _sendProviderMessage,
          hint: 'Escribe a ${_currentProvider.name} (precios, stock, entrega)...',
          extraAction: IconButton(
            tooltip: 'Solicitar Cotización Formal',
            icon: const Icon(Icons.request_quote_rounded, color: AppColors.trustGreen),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuotationRequestScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Chip de pregunta sugerida para análisis rápido
  Widget _quickPromptChip(String prompt, {Color? color}) {
    return ActionChip(
      backgroundColor: color != null ? color.withValues(alpha: 0.12) : AppColors.paleBlue,
      side: BorderSide(color: color?.withValues(alpha: 0.3) ?? AppColors.border),
      label: Text(
        prompt,
        style: TextStyle(
          fontSize: 11.5,
          color: color ?? AppColors.navy,
          fontWeight: FontWeight.w700,
        ),
      ),
      onPressed: () => _sendAiMessage(prompt),
    );
  }

  /// Burbuja de mensaje estilizada con soporte para encabezados y viñetas
  Widget _buildMessageBubble({
    required String text,
    required bool isUser,
    required String time,
    String? providerName,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 620),
        decoration: BoxDecoration(
          color: isUser ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: isUser ? const Radius.circular(2) : const Radius.circular(18),
            bottomLeft: !isUser ? const Radius.circular(2) : const Radius.circular(18),
          ),
          border: isUser ? null : Border.all(color: AppColors.border, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    providerName != null ? Icons.business_center_rounded : Icons.auto_awesome,
                    size: 14,
                    color: providerName != null ? AppColors.teal : AppColors.trustGreen,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    providerName != null ? providerName.toUpperCase() : 'PROVEO AI INTEL',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                      color: providerName != null ? AppColors.teal : AppColors.trustGreen,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
            ],
            Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : AppColors.textPrimary,
                fontSize: 13.5,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: TextStyle(
                color: isUser ? Colors.white70 : AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Indicador de escritura animado cuando la IA o el proveedor están respondiendo
  Widget _buildTypingIndicator({required String title}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.paleBlue,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: AppColors.navy, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  /// Barra inferior con campo de texto y botón de envío
  Widget _buildInputBar({
    required Function(String) onSend,
    required String hint,
    Widget? extraAction,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (extraAction != null) ...[
            extraAction,
            const SizedBox(width: 4),
          ],
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.border)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: AppColors.navy, width: 1.5)),
                filled: true,
                fillColor: AppColors.background,
              ),
              onSubmitted: onSend,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: AppColors.navy),
            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            onPressed: () => onSend(_messageController.text),
          ),
        ],
      ),
    );
  }
}

/// Modal Sheet para visualizar el Dossier de Inteligencia Digital Multiplataforma
class _CompanyIntelligenceModal extends StatelessWidget {
  final CompanyIntelligenceData intel;

  const _CompanyIntelligenceModal({required this.intel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Header del modal
          Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 20, 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.navy, AppColors.teal],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.trustGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: AppColors.trustGreen, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dossier de Inteligencia IA • ${intel.providerName}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Auditoría Multiplataforma: Google, Redes Sociales y Solvencia DGI',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Contenido scrollable con auditoría digital y fiscal
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Resumen de Scores
                  Row(
                    children: [
                      Expanded(
                        child: _ScoreBox(
                          title: 'Presencia Digital',
                          score: '${intel.digitalScore}/100',
                          subtitle: 'Google, FB, IG, TikTok, YT',
                          color: AppColors.blue,
                          icon: Icons.public_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _ScoreBox(
                          title: 'Confianza B2B',
                          score: '${intel.trustScore}/100',
                          subtitle: 'Fiscal & Trazabilidad',
                          color: AppColors.trustGreen,
                          icon: Icons.verified_user_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Auditoría de Redes Sociales
                  const Text('📱 Presencia en Redes Sociales & Web Oficial',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.navy)),
                  const SizedBox(height: 10),
                  _SocialCard(
                    icon: Icons.search_rounded,
                    network: 'Google Search & Maps',
                    handle: intel.website,
                    metric: '${intel.googleRating}★ (${intel.googleReviews} Reseñas)',
                    summary: intel.googleSearchSummary,
                    color: Colors.amber.shade800,
                  ),
                  const SizedBox(height: 8),
                  _SocialCard(
                    icon: Icons.facebook,
                    network: 'Facebook Business',
                    handle: intel.facebook['handle'] ?? '',
                    metric: intel.facebook['followers'] ?? '',
                    summary: intel.facebook['summary'] ?? '',
                    color: const Color(0xFF1877F2),
                  ),
                  const SizedBox(height: 8),
                  _SocialCard(
                    icon: Icons.camera_alt_outlined,
                    network: 'Instagram Corporativo',
                    handle: intel.instagram['handle'] ?? '',
                    metric: intel.instagram['followers'] ?? '',
                    summary: intel.instagram['summary'] ?? '',
                    color: const Color(0xFFE1306C),
                  ),
                  const SizedBox(height: 8),
                  _SocialCard(
                    icon: Icons.music_note_rounded,
                    network: 'TikTok Business',
                    handle: intel.tiktok['handle'] ?? '',
                    metric: intel.tiktok['followers'] ?? '',
                    summary: intel.tiktok['summary'] ?? '',
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  _SocialCard(
                    icon: Icons.play_circle_fill_rounded,
                    network: 'YouTube Channel',
                    handle: intel.youtube['handle'] ?? '',
                    metric: intel.youtube['followers'] ?? '',
                    summary: intel.youtube['summary'] ?? '',
                    color: const Color(0xFFFF0000),
                  ),

                  const SizedBox(height: 24),

                  // Verificación Legal y Fiscal
                  const Text('🏛️ Verificación Legal & Fiscal en Nicaragua',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.navy)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.paleGreen,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.trustGreen.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.shield_rounded, color: AppColors.trustGreen, size: 20),
                            const SizedBox(width: 8),
                            Text('RUC: ${intel.ruc}',
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.navy)),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(intel.fiscalStatus,
                            style: const TextStyle(fontSize: 12.5, color: AppColors.textPrimary)),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: intel.certifications
                              .map((cert) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.border),
                                    ),
                                    child: Text('✓ $cert',
                                        style: const TextStyle(
                                            fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.navy)),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Tips de Negociación de Precios con IA
                  const Text('💡 Estrategia de Negociación Sugerida por IA',
                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppColors.navy)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.paleBlue,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.blue.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: intel.aiNegotiationTips
                          .map((tip) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(tip,
                                    style: const TextStyle(
                                        fontSize: 12.5, height: 1.4, color: AppColors.navy, fontWeight: FontWeight.w600)),
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón para Cotizar Directamente
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.trustGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const QuotationRequestScreen()),
                        );
                      },
                      icon: const Icon(Icons.request_quote_rounded),
                      label: Text('Solicitar Cotización a ${intel.providerName}',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Caja métrica con puntaje digital o nivel de confianza B2B.
class _ScoreBox extends StatelessWidget {
  final String title;
  final String score;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _ScoreBox({
    required this.title,
    required this.score,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 6),
              Text(title, style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: color)),
            ],
          ),
          const SizedBox(height: 6),
          Text(score, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

/// Tarjeta de red social con métricas de seguidores, reseñas y resumen del canal corporativo.
class _SocialCard extends StatelessWidget {
  final IconData icon;
  final String network;
  final String handle;
  final String metric;
  final String summary;
  final Color color;

  const _SocialCard({
    required this.icon,
    required this.network,
    required this.handle,
    required this.metric,
    required this.summary,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(network, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppColors.navy)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.paleBlue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(metric,
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: AppColors.navy)),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(handle, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(summary, style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}