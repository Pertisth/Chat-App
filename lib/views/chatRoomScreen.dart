import 'package:chat_app/services/UserDatabase.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/sharedPreference.dart';
import 'package:chat_app/views/conversationScreen.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'chatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  AuthMethods authMethods = new AuthMethods();
  UserDatabase userDatabase = new UserDatabase();
  SharedPreference sharedPreference = new SharedPreference();

  // getUserInfo() async {
  //   Constants.myName = await SharedPreference.getUsernameSharedPreference();
  // }

  Stream chatRoomStream;

  Widget chatRoomList() {
    FirebaseAuth.instance.currentUser.reload();
    String currentUser = FirebaseAuth.instance.currentUser.displayName;
    return StreamBuilder(
        stream: chatRoomStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                      username: snapshot.data.documents[index]
                          .get("chatroomId")
                          .toString()
                          .replaceAll("_", "")
                          .replaceAll(currentUser, ""),
                      chatRoomId:
                          snapshot.data.documents[index].get("chatroomId"),
                    );
                  })
              : Container();
        });
  }

  @override
  void initState() {
    // getUserInfo();

    FirebaseAuth.instance.currentUser.reload();
    String userName = FirebaseAuth.instance.currentUser.displayName;
    print(userName);
    userDatabase.getChatRoom(userName).then((value) {
      setState(() {
        chatRoomStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app_outlined,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              authMethods.signOut();
              Navigator.pushReplacementNamed(context, SignIn.id);
            },
          ),
        ],
        title: Text(
          'Chat',
          style: TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Color(0xFF009688),
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.chat,
          color: Colors.white,
        ),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.pushNamed(context, Search.id);
        },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomId;
  ChatRoomTile({this.username, this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(
                      chatRoomId: chatRoomId,
                      searchUsername: username,
                    )));
      },
      child: Container(
        color: Colors.black12,
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
        child: Row(
          children: [
            Container(
              height: 40.0,
              width: 40.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Text("${username.substring(0, 1).toUpperCase()}"),
            ),
            SizedBox(
              width: 10.0,
            ),
            Text(
              username,
              style: TextStyle(
                fontSize: 19.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
