import 'package:chat_app/views/chatRoomScreen.dart';
import 'package:chat_app/views/conversationScreen.dart';
import 'package:chat_app/views/forgetPassword.dart';
import 'package:chat_app/views/register.dart';
import 'package:chat_app/views/search.dart';
import 'package:chat_app/views/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SignIn.id,
      routes: {
        SignIn.id: (context) => SignIn(),
        RegisterPage.id: (context) => RegisterPage(),
        ChatScreen.id: (context) => ChatScreen(),
        Search.id: (context) => Search(),
        ConversationScreen.id: (context) => ConversationScreen(),
        ForgotPassword.id: (context) => ForgotPassword(),
      },
    );
  }
}
