import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:recipe_app_exam/controller/signupcontroller.dart';
import 'package:recipe_app_exam/model/fs_model.dart';
import 'package:recipe_app_exam/view/add_about_infopage.dart';
import 'package:recipe_app_exam/view/homepage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  SignUpController controller = Get.put(SignUpController());
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          "Chats",
          style: TextStyle(color: Colors.white, fontSize: 25),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SignUp",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "and join with chats",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: TextFormField(
                controller:email,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: "Email",
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 20),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white10,
                    filled: true,
                    enabled: true,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Obx(
                    () => TextFormField(
                  controller:password,
                  style: TextStyle(color: Colors.white),
                  obscureText: controller.passwordVisible.value,
                  decoration: InputDecoration(
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 20),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white10,
                    filled: true,
                    enabled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.toggle();
                      },
                      icon: Icon(
                        // Use different icon based on whether the password is visible or not
                        controller.passwordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 50,
                left: 100,
                right: 100,
                bottom: 10,
              ),
              child: InkWell(
                onTap: () async {
                  try {
                    var cu = FirebaseAuth.instance.currentUser;
                    if (cu != null) {
                      print("Already Login");
                    } else {
                      UserCredential user = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: email.text, password: password.text);
                      print(user.user);
                      FSmodel().addUser(user.user);
                      Get.offAll(
                        AddAboutInfoPage(),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'email-already-in-use') {
                      // Show alert dialog if email is already in use
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Error'),
                            content: Text('This email is already in use.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      // Handle other FirebaseAuthException errors
                      print(e.code);
                      print(e.message);
                    }
                  }
                  email.clear();
                  password.clear();
                },
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.080,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      "Signup",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
