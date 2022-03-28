import 'package:chat_app/chatting/chat/message.dart';
import 'package:chat_app/chatting/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _authentification = FirebaseAuth.instance;
  User? loggedUser;
  bool showSpinner = false;

  void getCurrentUser() {
    try {
      final user = _authentification.currentUser;
      if (user != null) {
        loggedUser = user;
      }
    } catch (e) {
      print('user is null');
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Text(loggedUser!.email!),
          title: const Text('Chat Screen'),
          actions: [
            IconButton(
                onPressed: () {
                  _authentification.signOut();
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.exit_to_app_sharp,
                  color: Colors.white,
                )),
          ],
        ),
        body: Container(
          child: Column(
            children: const [
              Expanded(child: Messages()),
              NewMessage(),
            ],
          ),
        ));
  }
}
