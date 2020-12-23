import 'package:chat_app/services/messageDatabase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String searchUsername;

  ConversationScreen({this.chatRoomId, this.searchUsername});

  static const String id = 'conversationScreen';
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  TextEditingController messageTextController = new TextEditingController();

  MessageDatabase messageDatabase = new MessageDatabase();
  String currentUserName;
  Stream<QuerySnapshot> chatMessageStream;
  Widget chatMessageList() {
    currentUserName = FirebaseAuth.instance.currentUser.displayName;
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  return MessageBubble(
                      message: snapshot.data.documents[index].get("message"),
                      isMe: snapshot.data.documents[index].get("sender") ==
                          currentUserName);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() async {
    if (messageTextController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "message": messageTextController.text,
        "sender": currentUserName,
        "timestamp": FieldValue.serverTimestamp(),
      };
      messageDatabase.saveConversationMessage(widget.chatRoomId, messageMap);
      messageTextController.clear();
    }
  }

  @override
  void initState() {
    print(widget.searchUsername);
    messageDatabase.getConversationMessage(widget.chatRoomId).then((val) {
      setState(() {
        chatMessageStream = val;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.searchUsername,
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Color(0xFF009688),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 80.0),
            child: Container(
              child: chatMessageList(),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: messageTextController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: sendMessage,
                    icon: Icon(
                      Icons.send,
                      color: Color(0xFF009688),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30.0),
                    ),
                  ),
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  MessageBubble({this.message, this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 8.0,
            color: isMe ? Color(0xFFDCF8C6) : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Text(
                message,
                style: TextStyle(
                    fontSize: 15.0, color: isMe ? Colors.black : Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// #DCF8C6
