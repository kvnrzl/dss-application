import 'package:dss_application/home_page.dart';
import 'package:dss_application/services/auth.dart';
import 'package:dss_application/sign_in_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: HomePage()
        // StreamBuilder(
        //   stream: AuthService().getCurrentUser(),
        //   builder: (context, snapshot) {
        //     return snapshot.hasData ? HomePage() : SignInPage();
        //   },
        // ),
        );
  }
}
