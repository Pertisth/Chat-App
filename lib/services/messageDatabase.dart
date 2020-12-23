import 'package:cloud_firestore/cloud_firestore.dart';

class MessageDatabase {
  saveConversationMessage(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap);
  }

  getConversationMessage(String chatRoomId) async {
    return await FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('timestamp')
        .snapshots();
  }
}
