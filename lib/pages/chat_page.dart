import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/components/messages.dart';
import 'package:chat/components/new_message.dart';
import 'package:chat/core/models/chat_notification.dart';
import 'package:chat/core/services/auth/auth_service.dart';
import 'package:chat/core/services/notification/chat_notification_service.dart';
import 'package:chat/pages/notification_page.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Chat",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              onChanged: (value) {
                if (value == 'logout') {
                  AuthService().logout();
                }
              },
              icon: Icon(Icons.more_vert, color: Colors.white),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Container(
                    child: const Row(
                      children: [
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Sair",
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => NotificationPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.red.shade800,
                  maxRadius: 8,
                  child: Text(
                    '${Provider.of<ChatNotificationService>(context).itemCount}',
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   onPressed: () {
      //     Provider.of<ChatNotificationService>(context, listen: false).add(
      //       ChatNotification(
      //         title: 'Mais uma notificação',
      //         body: Random().nextDouble().toString(),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}
