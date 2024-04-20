import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:recipe_app_exam/view/homepage.dart';
import 'package:recipe_app_exam/view/loginpage.dart';
import 'package:recipe_app_exam/view/splashscreen.dart';
import 'db_helper.dart';
import 'firebase_options.dart';

TextEditingController name = TextEditingController();
TextEditingController number = TextEditingController();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbHelper().initDb();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var cu = FirebaseAuth.instance.currentUser;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: cu != null ? Homepage() : LoginPage(),
    );
  }
}
