import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../models/models.dart';
import '../services/ai/gemini_recommendation_service.dart';
import 'quotation_request_screen.dart';

/// Pantalla de Chat interactivo B2B con Asistente Inteligente Gemini y Mensajería con Proveedores.
class ChatScreen extends StatefulWidget {
  final ProviderModel? initialProvider;

  const ChatScreen({super.key, this.initialProvider});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _messageController = TextEditingController();
  final _geminiService = GeminiService();

  // Conversación con Gemini AI
  final List<Map<String, dynamic>> _aiMessages = [
    {
      'isUser': false,
      'text': '¡Hola! Soy el Asistente Inteligente de PROVEO potenciado por Gemini AI. 🤖\n\n¿En qué puedo asesorar a tu negocio hoy? Puedo ayudarte a cotizar materias primas, comparar capacidades técnicas de proveedores o resolver dudas sobre suministros industriales en Nicaragua.',
      'time': 'Ahora',
    }
  ];

  // Conversación con Proveedor
  late final List<Map<String, dynamic>> _providerMessages;
  late final String _providerName;
  late final String _providerCategory;
  late final String _providerLocation;
  late final String _providerResponseTime;

  bool _isAiTyping = false;
  bool _isProviderTyping = false;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProvider;
    _providerName = p?.name ?? 'PlastiPack Nicaragua';
    _providerCategory = p?.category ?? 'Empaques Industriales';
    _providerLocation = p?.location ?? 'Managua, Nicaragua';
    _providerResponseTime = p?.responseTime ?? '~2 horas';

    _providerMessages = [
      {
        'isUser': false,
        'text': '¡Hola! Gracias por contactar a $_providerName. Somos especialistas en $_providerCategory. ¿En qué producto o volumen de compra podemos ayudarte hoy?',
        'time': '10:00 AM',
      },
    ];

    // Si viene desde un proveedor específico, arrancamos en la pestaña del proveedor
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialProvider != null ? 1 : 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Envía mensaje a Gemini AI
  Future<void> _sendAiMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    setState(() {
      _aiMessages.add({
        'isUser': true,
        'text': query,
        'time': 'Ahora',
      });
      _isAiTyping = true;
    });
    _messageController.clear();

    try {
      final prompt = '''Eres el Asesor Senior de Compras B2B de PROVEO Nicaragua.
Responde de forma ejecutiva, concisa y profesional en español.
Enfócate en proveedores verificados, mejores prácticas de compra, logística e insumos en Nicaragua.

Pregunta del comprador: "$query"''';

      final response = await _geminiService.generarRespuesta(prompt);

      if (mounted) {
        setState(() {
          _aiMessages.add({
            'isUser': false,
            'text': response,
            'time': 'Ahora',
          });
          _isAiTyping = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _aiMessages.add({
            'isUser': false,
            'text': 'Te sugiero revisar a los proveedores verificados en nuestro directorio para recibir cotizaciones formales con precios por volumen.',
            'time': 'Ahora',
          });
          _isAiTyping = false;
        });
      }
    }
  }

  /// Envía mensaje al Proveedor con auto-respuesta simulada
  void _sendProviderMessage(String text) {
    final query = text.trim();
    if (query.isEmpty) return;

    setState(() {
      _providerMessages.add({
        'isUser': true,
        'text': query,
        'time': 'Ahora',
      });
      _isProviderTyping = true;
    });
    _messageController.clear();

    // Auto-respuesta corporativa
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isProviderTyping = false;
          _providerMessages.add({
            'isUser': false,
            'text': 'Recibido. Un ejecutivo de ventas corporativas de $_providerName está revisando tu solicitud sobre "$query". Te adjuntaremos ficha técnica y disponibilidad de inmediato.',
            'time': 'Ahora',
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sala de Negociación y Chat B2B'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.trustGreen,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
          tabs: [
            const Tab(icon: Icon(Icons.auto_awesome, size: 18), text: 'Asistente IA (Gemini)'),
            Tab(icon: const Icon(Icons.storefront_outlined, size: 18), text: _providerName),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAiChatTab(),
          _buildProviderChatTab(),
        ],
      ),
    );
  }

  // ── Tab 1: Chat con IA Gemini ─────────────────────────────────────────────
  Widget _buildAiChatTab() {
    return Column(
      children: [
        // Banner Inteligente
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: const BoxDecoration(
            color: AppColors.paleGreen,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.trustGreen, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Asistente PROVEO impulsado por Google Gemini — Recomendaciones B2B instantáneas.',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),

        // Sugerencias Rápidas
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              _quickPromptChip('¿Quién entrega más rápido en Managua?', onSelected: _sendAiMessage),
              const SizedBox(width: 8),
              _quickPromptChip('Recomiéndame empaques biodegradables', onSelected: _sendAiMessage),
              const SizedBox(width: 8),
              _quickPromptChip('¿Cómo negociar precios por volumen?', onSelected: _sendAiMessage),
            ],
          ),
        ),

        // Mensajes
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: _aiMessages.length + (_isAiTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _aiMessages.length && _isAiTyping) {
                return _buildTypingIndicator(label: 'Gemini AI está analizando el mercado...');
              }
              final msg = _aiMessages[index];
              return _buildMessageBubble(
                text: msg['text'] as String,
                isUser: msg['isUser'] as bool,
                time: msg['time'] as String,
                isAi: true,
              );
            },
          ),
        ),

        // Input
        _buildInputBar(
          onSend: _sendAiMessage,
          hint: 'Pregúntale a Gemini sobre proveedores, insumos o precios...',
        ),
      ],
    );
  }

  // ── Tab 2: Chat Directo con Proveedor ──────────────────────────────────────
  Widget _buildProviderChatTab() {
    return Column(
      children: [
        // Encabezado del Proveedor
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(bottom: BorderSide(color: AppColors.border)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.navy, AppColors.blue],
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    _providerName.length >= 2 ? _providerName.substring(0, 2).toUpperCase() : 'PR',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _providerName,
                            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppColors.navy),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.verified_rounded, size: 14, color: AppColors.trustGreen),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(color: AppColors.trustGreen, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'En línea • Resp. promedio: $_providerResponseTime • $_providerLocation',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.trustGreen,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuotationRequestScreen()),
                ),
                icon: const Icon(Icons.request_quote_rounded, size: 16),
                label: const Text('Cotizar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ),

        // Preguntas Rápidas de Negociación B2B
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              _quickPromptChip('📄 Solicitar catálogo formal (PDF)', onSelected: _sendProviderMessage),
              const SizedBox(width: 8),
              _quickPromptChip('📦 ¿Cuál es el pedido mínimo (MOQ)?', onSelected: _sendProviderMessage),
              const SizedBox(width: 8),
              _quickPromptChip('🚚 ¿Tienen cobertura de entrega en mi departamento?', onSelected: _sendProviderMessage),
              const SizedBox(width: 8),
              _quickPromptChip('💳 ¿Manejan crédito a 30 días con RUC?', onSelected: _sendProviderMessage),
            ],
          ),
        ),

        // Mensajes
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: _providerMessages.length + (_isProviderTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _providerMessages.length && _isProviderTyping) {
                return _buildTypingIndicator(label: '$_providerName está escribiendo...');
              }
              final msg = _providerMessages[index];
              return _buildMessageBubble(
                text: msg['text'] as String,
                isUser: msg['isUser'] as bool,
                time: msg['time'] as String,
                isAi: false,
              );
            },
          ),
        ),

        // Input
        _buildInputBar(
          onSend: _sendProviderMessage,
          hint: 'Escribe un mensaje directo a $_providerName...',
        ),
      ],
    );
  }

  // ── Widgets Reutilizables ──────────────────────────────────────────────────
  Widget _quickPromptChip(String prompt, {required Function(String) onSelected}) {
    return ActionChip(
      backgroundColor: Colors.white,
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      label: Text(
        prompt,
        style: const TextStyle(fontSize: 11.5, color: AppColors.navy, fontWeight: FontWeight.w700),
      ),
      onPressed: () => onSelected(prompt),
    );
  }

  Widget _buildMessageBubble({
    required String text,
    required bool isUser,
    required String time,
    required bool isAi,
  }) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 580),
        decoration: BoxDecoration(
          color: isUser ? AppColors.navy : Colors.white,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(18),
            bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(18),
          ),
          border: isUser ? null : Border.all(color: AppColors.border),
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
                    isAi ? Icons.auto_awesome : Icons.business_rounded,
                    size: 14,
                    color: isAi ? AppColors.trustGreen : AppColors.blue,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isAi ? 'PROVEO Gemini AI' : _providerName,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: isAi ? AppColors.trustGreen : AppColors.navy,
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
                fontSize: 14,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 4),
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

  Widget _buildTypingIndicator({required String label}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.paleBlue,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.navy, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar({required Function(String) onSend, required String hint}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file_rounded, color: AppColors.navy),
            tooltip: 'Adjuntar documento o imagen B2B',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Función para adjuntar especificaciones y fichas técnicas')),
              );
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.border)),
                filled: true,
                fillColor: AppColors.background,
              ),
              onSubmitted: onSend,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: AppColors.navy,
              padding: const EdgeInsets.all(12),
            ),
            icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            onPressed: () => onSend(_messageController.text),
          ),
        ],
      ),
    );
  }
}