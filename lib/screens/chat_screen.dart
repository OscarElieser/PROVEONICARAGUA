import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../services/ai/gemini_recommendation_service.dart';

/// Pantalla de Chat interactivo con Asistente Inteligente Gemini y Mensajería B2B.
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  // Controlador de pestañas (Asistente IA vs Proveedores)
  late final TabController _tabController;
  
  // Controlador de texto para el campo de entrada
  final _messageController = TextEditingController();
  
  // Servicio Gemini
  final _geminiService = GeminiService();
  
  // Lista de mensajes en la conversación con Gemini
  final List<Map<String, dynamic>> _aiMessages = [
    {
      'isUser': false,
      'text': '¡Hola! Soy el Asistente Inteligente de PROVEO potenciado por Gemini AI. 🤖\n\n¿En qué te puedo ayudar hoy? Puedes consultarme sobre especificaciones de empaques, comparación de proveedores en Nicaragua o consejos para solicitar cotizaciones.',
      'time': 'Ahora',
    }
  ];

  // Lista de mensajes con proveedor de ejemplo
  final List<Map<String, dynamic>> _providerMessages = [
    {'isUser': false, 'text': 'Hola Carlos, recibimos tu solicitud de cotización para 2,000 unidades de envases.', 'time': '10:15 AM'},
    {'isUser': true, 'text': 'Excelente. ¿Tienen disponibilidad para entrega en Managua esta semana?', 'time': '10:18 AM'},
    {'isUser': false, 'text': 'Sí, tenemos stock listo para despacho en 3 a 4 días hábiles.', 'time': '10:20 AM'},
  ];

  // Estado de carga mientras Gemini genera respuesta
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  /// Envía la consulta del usuario a Gemini AI y agrega la respuesta a la conversación.
  Future<void> _sendAiMessage(String text) async {
    final query = text.trim();
    if (query.isEmpty) return;

    setState(() {
      _aiMessages.add({
        'isUser': true,
        'text': query,
        'time': 'Ahora',
      });
      _isTyping = true;
    });
    _messageController.clear();

    try {
      final prompt = '''Eres el Asistente Inteligente B2B oficial de la plataforma PROVEO Nicaragua.
Ayuda al usuario con su consulta de forma profesional, clara y precisa en español.
Enfócate en compras empresariales, proveedores, materiales (plásticos, envases, etiquetas, materias primas) y negocios en Nicaragua.

Consulta del usuario: "$query"''';

      final response = await _geminiService.generarRespuesta(prompt);

      if (mounted) {
        setState(() {
          _aiMessages.add({
            'isUser': false,
            'text': response,
            'time': 'Ahora',
          });
          _isTyping = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _aiMessages.add({
            'isUser': false,
            'text': 'Te recomiendo PlastiPack Nicaragua y Evanplast S.A. para suministros de alta calidad y entrega rápida.',
            'time': 'Ahora',
          });
          _isTyping = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de Comunicación'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: AppColors.trustGreen,
          tabs: const [
            Tab(icon: Icon(Icons.auto_awesome), text: 'Asistente IA (Gemini)'),
            Tab(icon: Icon(Icons.chat_bubble_outline), text: 'PlastiPack Nicaragua'),
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

  /// Pestaña interactiva de chat con Gemini AI
  Widget _buildAiChatTab() {
    return Column(
      children: [
        // Banner informativo sobre Gemini
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: AppColors.paleGreen,
          child: const Row(
            children: [
              Icon(Icons.auto_awesome, color: AppColors.trustGreen, size: 20),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Consultas impulsadas por Google Gemini AI — Respuestas B2B en tiempo real.',
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),

        // Sugerencias rápidas para el cliente
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              _quickPromptChip('¿Quién entrega más rápido en Managua?'),
              const SizedBox(width: 8),
              _quickPromptChip('Recomiéndame empaques biodegradables'),
              const SizedBox(width: 8),
              _quickPromptChip('¿Cómo solicitar una cotización formal?'),
            ],
          ),
        ),

        // Lista de mensajes
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _aiMessages.length + (_isTyping ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == _aiMessages.length && _isTyping) {
                return _buildTypingIndicator();
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
        _buildInputBar(onSend: _sendAiMessage, hint: 'Pregúntale a Gemini sobre proveedores o productos...'),
      ],
    );
  }

  /// Pestaña de chat con proveedor
  Widget _buildProviderChatTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: AppColors.navy,
                child: Text('PP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PlastiPack Nicaragua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('En línea • Tiempo de respuesta: ~2 horas', style: TextStyle(color: AppColors.trustGreen, fontSize: 11)),
                  ],
                ),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.description_outlined, size: 16),
                label: const Text('Ver Cotización'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _providerMessages.length,
            itemBuilder: (context, index) {
              final msg = _providerMessages[index];
              return _buildMessageBubble(
                text: msg['text'] as String,
                isUser: msg['isUser'] as bool,
                time: msg['time'] as String,
              );
            },
          ),
        ),
        _buildInputBar(
          onSend: (text) {
            if (text.trim().isEmpty) return;
            setState(() {
              _providerMessages.add({'isUser': true, 'text': text.trim(), 'time': 'Ahora'});
            });
            _messageController.clear();
          },
          hint: 'Escribe un mensaje al proveedor...',
        ),
      ],
    );
  }

  /// Chip de pregunta sugerida
  Widget _quickPromptChip(String prompt) {
    return ActionChip(
      backgroundColor: AppColors.paleBlue,
      label: Text(prompt, style: const TextStyle(fontSize: 11, color: AppColors.navy, fontWeight: FontWeight.w600)),
      onPressed: () => _sendAiMessage(prompt),
    );
  }

  /// Burbuja de mensaje estilizada
  Widget _buildMessageBubble({required String text, required bool isUser, required String time}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: const BoxConstraints(maxWidth: 520),
        decoration: BoxDecoration(
          color: isUser ? AppColors.navy : AppColors.surface,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(16),
            bottomLeft: !isUser ? const Radius.circular(0) : const Radius.circular(16),
          ),
          border: isUser ? null : Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isUser) ...[
              const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 14, color: AppColors.trustGreen),
                  SizedBox(width: 4),
                  Text('PROVEO AI', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.trustGreen)),
                ],
              ),
              const SizedBox(height: 4),
            ],
            Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : AppColors.textPrimary,
                fontSize: 14,
                height: 1.4,
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

  /// Indicador de escritura animado
  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.paleBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.navy),
            ),
            SizedBox(width: 8),
            Text('Gemini está analizando tu consulta...', style: TextStyle(fontSize: 12, color: AppColors.navy, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  /// Barra de entrada inferior
  Widget _buildInputBar({required Function(String) onSend, required String hint}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: hint,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: const BorderSide(color: AppColors.border)),
                filled: true,
                fillColor: AppColors.background,
              ),
              onSubmitted: onSend,
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: AppColors.navy),
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () => onSend(_messageController.text),
          ),
        ],
      ),
    );
  }
}