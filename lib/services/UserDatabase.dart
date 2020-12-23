import 'package:cloud_firestore/cloud_firestore.dart';

class UserDatabase {
  getUserByName(String username) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: username)
        .get();
  }

  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
  }

  setUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap);
  }

  createChatRoom(chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .set(chatRoomMap);
  }

  getChatRoom(String username) async {
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: username)
        .snapshots();
  }
}
