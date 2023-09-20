import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/chat/chat_service.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  String message = '';
  final messageController = TextEditingController();

  Future<void> sendMessage() async {
    final user = AuthService().currentUser;

    if (user != null) {
      ChatService().save(message, user);
    }
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            onChanged: (msg) => setState(() => message = msg),
            decoration: const InputDecoration(labelText: 'Enviar mensagem...'),
            onSubmitted: (_) {
              if (message.trim().isNotEmpty) {
                sendMessage();
              }
            },
          ),
        ),
        IconButton(
          onPressed: () => message.trim().isEmpty ? null : sendMessage(),
          icon: const Icon(Icons.send),
        )
      ],
    );
  }
}
