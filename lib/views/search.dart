import 'package:chat_app/services/UserDatabase.dart';
import 'package:chat_app/views/conversationScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  static const String id = 'SearchPage';
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchEditingController = new TextEditingController();
  UserDatabase userDatabase = new UserDatabase();

  QuerySnapshot searchSnapShot;
  initiateSearch() async {
    await userDatabase.getUserByName(searchEditingController.text).then((val) {
      setState(() {
        searchSnapShot = val;
      });
    });
  }

  Widget searchList() {
    if (searchSnapShot != null) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapShot.docs.length,
        itemBuilder: (context, index) {
          return searchTile(
            userName: searchSnapShot.docs[index].get('name'),
            email: searchSnapShot.docs[index].get('email'),
          );
        },
      );
    } else {
      return Container();
    }
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  createChatRoomAndStartConversation(String userName) async {
    await FirebaseAuth.instance.currentUser.reload();
    String currentUserName = FirebaseAuth.instance.currentUser.displayName;
    print(currentUserName);
    String chatRoomId = getChatRoomId(currentUserName, userName);

    List<String> users = [currentUserName, userName];
    Map<String, dynamic> chatRoomMap = {
      "users": users,
      "chatroomId": chatRoomId,
    };
    await UserDatabase().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConversationScreen(
                  chatRoomId: chatRoomId,
                  searchUsername: userName,
                )));
  }

  Widget searchTile({String userName, String email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: TextStyle(color: Colors.black),
              ),
              Text(
                email,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatRoomAndStartConversation(userName);
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Chat',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(fontSize: 20.0),
        ),
        backgroundColor: Color(0xFF009688),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: searchEditingController,
                        decoration: InputDecoration(
                          hintText: 'Search User',
                          hintStyle: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        size: 30.0,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        initiateSearch();
                      },
                    ),
                  ],
                ),
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}
