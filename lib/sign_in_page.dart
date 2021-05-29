import 'package:dss_application/home_page.dart';
import 'package:dss_application/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: ElevatedButton.icon(
            onPressed: () {
              AuthService()
                  .signInWithGoogleAccount()
                  .then((value) => Get.off(HomePage()));
            },
            icon: Icon(Icons.mail),
            label: Text("Google Sign In"),
          ),
        ),
      ),
    );
  }
}
