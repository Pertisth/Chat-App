import 'package:chat_app/services/UserDatabase.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/utilities/roundedButton.dart';
import 'package:chat_app/views/forgetPassword.dart';
import 'package:chat_app/views/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'chatRoomScreen.dart';
import 'forgetPassword.dart';

class SignIn extends StatefulWidget {
  static const String id = 'signInPage';
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();
  AuthMethods authMethods = new AuthMethods();
  UserDatabase userDatabase = new UserDatabase();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // loginIn() {
  //   if (true) {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     authMethods
  //         .signInUsingEmailAndPassword(emailTextEditingController.text,
  //             passwordTextEditingController.text)
  //         .then((value) {
  //       if (value != null) {
  //         SharedPreference.saveUserLoggedInSharedPreference(true);
  //         SharedPreference.saveUserEmailSharedPreference(
  //             emailTextEditingController.text);
  //         QuerySnapshot snapshotUserInfo =
  //             userDatabase.getUserByEmail(emailTextEditingController.text);
  //
  //         Navigator.pushReplacementNamed(context, ChatScreen.id);
  //       }
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      body: isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Padding(
                    padding: EdgeInsets.all(35.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            validator: (value) {
                              return value.isEmpty ? 'Enter username' : null;
                            },
                            controller: emailTextEditingController,
                            decoration: InputDecoration(
                              hintText: 'Enter your email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                          ),
                          TextFormField(
                            validator: (value) {
                              return value.isEmpty ? 'Enter email' : null;
                            },
                            controller: passwordTextEditingController,
                            decoration: InputDecoration(
                              hintText: "Enter your password",
                            ),
                            obscureText: true,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 225.0),
                            child: GestureDetector(
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    decoration: TextDecoration.underline),
                              ),
                              onTap: () {
                                Navigator.pushNamed(context, ForgotPassword.id);
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RoundedButton(
                                buttonType: 'Login',
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    UserCredential user = await authMethods
                                        .signInUsingEmailAndPassword(
                                            emailTextEditingController.text,
                                            passwordTextEditingController.text);
                                    if (user != null) {
                                      Navigator.pushReplacementNamed(
                                          context, ChatScreen.id);
                                    }
                                  }
                                }),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? "),
                              GestureDetector(
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, RegisterPage.id);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
