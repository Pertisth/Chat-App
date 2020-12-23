import 'package:chat_app/utilities/roundedButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  static const String id = 'resetPassword';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool isLoading = false;
  bool mainBody = true;

  TextEditingController emailTextEditingController =
      new TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;

  void resetPassword() {
    try {
      _auth
          .sendPasswordResetEmail(email: emailTextEditingController.text)
          .then((value) {
        setState(() {
          mainBody = false;
        });

        print("Mail sent!");
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
      ),
      body: mainBody
          ? Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                    child: TextFormField(
                      controller: emailTextEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(100.0),
                          ),
                        ),
                        hintText: 'Enter your email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RoundedButton(
                    buttonType: "Submit",
                    onPressed: resetPassword,
                  ),
                ],
              ),
            )
          : Container(
              child: Center(
                child: Text(
                  "Mail sent.",
                  style: TextStyle(
                    fontSize: 25.0,
                  ),
                ),
              ),
            ),
    );
  }
}
