import 'package:chat_app/chatting/chat/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          try {
            final chatDocs = snapshot.data!.docs;

            return ListView.builder(
              reverse: true,
              itemCount: chatDocs.length,
              itemBuilder: (BuildContext context, int index) {
                return ChatBubbles(
                  message: chatDocs[index]['text'],
                  isMe: user!.uid == chatDocs[index]['userID'].toString(),
                  userName: chatDocs[index]['userName'],
                );
              },
            );
          } catch (e) {
            return const Center(child: Text('No data'));
          }
        });
  }
}
