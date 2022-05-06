// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Chat'),
        actions: [
          DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: const [
                      Icon(Icons.exit_to_app, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Logout', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  value: 'logout',
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {
                  FirebaseAuth.instance.signOut();
                }
              })
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(),
          ),
          NewMessages(),
        ],
      ),
    );
  }
}
