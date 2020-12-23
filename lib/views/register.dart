import 'package:chat_app/services/UserDatabase.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/sharedPreference.dart';
import 'package:chat_app/views/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'file:///F:/Flutter/chat_app/lib/utilities/roundedButton.dart';

import 'chatRoomScreen.dart';

class RegisterPage extends StatefulWidget {
  static const String id = 'registerPage';
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  AuthMethods authMethods = new AuthMethods();
  UserDatabase uploadUserData = new UserDatabase();
  SharedPreference sharedPreference = new SharedPreference();

  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      body: isLoading
          ? Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: EdgeInsets.all(35.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (value) {
                                return value.isEmpty ? 'Enter username' : null;
                              },
                              controller: usernameTextEditingController,
                              decoration: InputDecoration(
                                hintText: 'Username',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            TextFormField(
                              validator: (value) {
                                return value.isEmpty ? 'Enter email' : null;
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
                                return value.isEmpty ? 'Enter password' : null;
                              },
                              controller: passwordTextEditingController,
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                              ),
                              obscureText: true,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: RoundedButton(
                          buttonType: 'Register',
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              // authMethods.signUpUsingEmailAndPassword(
                              //     emailTextEditingController.text,
                              //     passwordTextEditingController.text);

                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                      email: emailTextEditingController.text,
                                      password:
                                          passwordTextEditingController.text)
                                  .then((value) => value.user.updateProfile(
                                      displayName:
                                          usernameTextEditingController.text));

                              Map<String, String> userMap = {
                                "name": usernameTextEditingController.text,
                                "email": emailTextEditingController.text,
                                "password": passwordTextEditingController.text,
                              };

                              uploadUserData.setUserInfo(userMap);
                              // SharedPreference.saveUserLoggedInSharedPreference(
                              //     true);
                              // SharedPreference.saveUserEmailSharedPreference(
                              //     emailTextEditingController.text);
                              // SharedPreference.saveUserNameSharedPreference(
                              //     usernameTextEditingController.text);
                              Navigator.pushReplacementNamed(
                                  context, ChatScreen.id);
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? "),
                          GestureDetector(
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, SignIn.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
