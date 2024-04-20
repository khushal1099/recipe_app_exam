import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipe_app_exam/controller/logincontroller.dart';
import 'package:recipe_app_exam/model/fs_model.dart';
import 'package:recipe_app_exam/view/homepage.dart';
import 'package:recipe_app_exam/view/signuppage.dart';

class LoginPage extends StatefulWidget {
   LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController controller = Get.put(LoginController());
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Chats",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 10),
              child: TextFormField(
                controller: email,
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
                  controller: password,
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
              padding: const EdgeInsets.only(left: 230, top: 10, bottom: 30),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 10,
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
                          .signInWithEmailAndPassword(
                          email: email.text, password: password.text);
                      print(user);
                      Get.off(
                        Homepage(),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'invalid-credential') {
                      // Show alert dialog if email is already in use
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Login Error'),
                            content: Text(
                                'Not exists account on this email and password.please signup'),
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
                      print(e.code);
                      print(e.message);
                    }
                  } finally {

                  }
                },
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.080,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.sizeOf(context).height * 0.12,
                  width: MediaQuery.sizeOf(context).width * 0.12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    image: DecorationImage(
                      image: AssetImage("assets/google.png"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                TextButton(
                  onPressed: () async {
                    var cu = FirebaseAuth.instance.currentUser;
                    if (cu != null) {
                      print("Already login");
                    } else {
                      var googlesignIn = await GoogleSignIn().signIn();
                      print("googlesignIn $googlesignIn");
                      var auth = await googlesignIn?.authentication;
                      var credential = GoogleAuthProvider.credential(
                          accessToken: auth?.accessToken,
                          idToken: auth?.idToken);
                      var data = await FirebaseAuth.instance
                          .signInWithCredential(credential);
                      FSmodel().addUser(data.user);
                      Get.off(
                        Homepage(),
                      );
                    }
                  },
                  child: Text(
                    "Log in with Google",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "OR",
              style: TextStyle(
                color: Colors.white38,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don't have an account?",
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                TextButton(
                  onPressed: () {
                    Get.to(
                      SignupPage(),
                    );
                  },
                  child: Text(
                    "Sign up.",
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
