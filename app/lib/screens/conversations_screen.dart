import 'dart:async';

import 'package:flutter/material.dart';

import '../models/conversacion_model.dart';
import '../services/chat_service.dart';
import '../services/api_service.dart';
import 'chat_screen.dart';

class ConversationsScreen extends StatefulWidget {
  final ApiService apiService;

  const ConversationsScreen({super.key, required this.apiService});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  late final ChatService _chatService;

  bool _loading = true;
  String? _error;
  List<Conversacion> _conversaciones = [];

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(widget.apiService);
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final data = await _chatService.getConversations();
      setState(() {
        _conversaciones = data;
      });
    } catch (e, stackTrace) {
      debugPrint('ERROR CONVERSACIONES: $e');
      debugPrint('STACK TRACE: $stackTrace');
      setState(() {
        _error = 'No se pudieron cargar las conversaciones: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Conversaciones')),
      body: RefreshIndicator(
        onRefresh: _fetch,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? ListView(
                children: [
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(_error!, style: theme.textTheme.bodyMedium),
                  ),
                ],
              )
            : _conversaciones.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 40),
                  Center(child: Text('No tienes conversaciones aún')),
                ],
              )
            : ListView.builder(
                itemCount: _conversaciones.length,
                itemBuilder: (context, index) {
                  final c = _conversaciones[index];
                  final ultimo =
                      c.ultimoMensaje?.contenido ?? 'Sin mensajes aún';
                  final tieneNoLeidos = c.tieneNoLeidos;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        c.otherParticipant.nombre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${c.producto.nombre}\n$ultimo',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      isThreeLine: true,
                      onTap: () {
                        Navigator.of(context)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  idConversacion: c.idConversacion,
                                  conversacion: c,
                                ),
                              ),
                            )
                            .then((_) => _fetch());
                      },
                      trailing: tieneNoLeidos
                          ? Container(
                              width: 12,
                              height: 12,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            )
                          : null,
                    ),
                  );
                },
              ),
      ),
    );
  }
}