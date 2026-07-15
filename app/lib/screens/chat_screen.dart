import 'dart:async';

import 'package:flutter/material.dart';

import '../models/mensaje_model.dart';
import '../models/conversacion_model.dart';
import '../services/chat_service.dart';
import '../services/api_service.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ChatScreen extends StatefulWidget {
  final int idConversacion;
  final Conversacion? conversacion; // opcional para mostrar título

  const ChatScreen({
    super.key,
    required this.idConversacion,
    this.conversacion,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatService _chatService;
  Timer? _timer;

  bool _loading = true;
  String? _error;

  List<Mensaje> _mensajes = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(ApiService());

    _marcarLeidosYCargar();
    _iniciarPolling();
  }

  Future<void> _marcarLeidosYCargar() async {
    try {
      setState(() {
        _loading = true;
        _error = null;
      });

      await _chatService.markConversationAsRead(widget.idConversacion);
      final mensajes = await _chatService.getConversationMessages(
        widget.idConversacion,
      );

      setState(() {
        _mensajes = mensajes;
      });
    } catch (e) {
      setState(() {
        _error = 'No se pudieron cargar los mensajes';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _iniciarPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        final mensajes = await _chatService.getConversationMessages(
          widget.idConversacion,
        );

        // Actualiza la UI solo si hay cambios
        if (mounted) {
          final currentCount = _mensajes.length;
          final newCount = mensajes.length;
          if (newCount != currentCount) {
            setState(() {
              _mensajes = mensajes;
            });
          } else if (newCount > 0) {
            // fallback: si es mismo largo, igual refrescamos si el último cambió
            if (_mensajes.last.idMensaje != mensajes.last.idMensaje) {
              setState(() {
                _mensajes = mensajes;
              });
            }
          }
        }
      } catch (_) {
        // silencioso en polling
      }
    });
  }

  Future<void> _enviar() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    // optimista: vaciar campo
    setState(() {
      _controller.clear();
    });

    try {
      await _chatService.sendMessage(widget.idConversacion, texto);
      // inmediatamente marcar como leídos y refrescar
      await _chatService.markConversationAsRead(widget.idConversacion);
      final mensajes = await _chatService.getConversationMessages(
        widget.idConversacion,
      );

      setState(() {
        _mensajes = mensajes;
      });
    } catch (e) {
      setState(() {
        _error = 'No se pudo enviar el mensaje';
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final currentUserId = authProvider.user?.idUsuario;

    final otherTitle = widget.conversacion?.otherParticipant.nombre;

    return Scaffold(
      appBar: AppBar(
        title: Text(otherTitle != null ? 'Chat con $otherTitle' : 'Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text(_error!))
                : _mensajes.isEmpty
                ? const Center(child: Text('Aún no hay mensajes'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 12,
                    ),
                    itemCount: _mensajes.length,
                    itemBuilder: (context, index) {
                      final m = _mensajes[index];

                      final isMe =
                          currentUserId != null && m.idEmisor == currentUserId;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          constraints: const BoxConstraints(maxWidth: 280),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.85)
                                : AppThemeColors.chatBubbleLeft,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            m.contenido,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Escribe un mensaje...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                        filled: true,
                        fillColor: AppThemeColors.inputBackground,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _enviar(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: _enviar,
                  ),
                ],
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(_error!, style: const TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }
}

class AppThemeColors {
  static const Color chatBubbleLeft = Color(0xFF2A2D34);
  static const Color inputBackground = Color(0xFF2A2D34);
}
