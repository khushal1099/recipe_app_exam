import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../model/user_model.dart';
import 'homepage.dart';

class AddAboutInfoPage extends StatelessWidget {
  AddAboutInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cu = FirebaseAuth.instance.currentUser;
    RxString image = ''.obs;


    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Align(
          child: Container(
            height: MediaQuery.sizeOf(context).height * 0.44,
            width: MediaQuery.sizeOf(context).width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(35),
              color: Colors.grey,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("User")
                          .doc(cu?.uid ?? "")
                          .snapshots(),
                      builder: (context, snapshot) {
                        String? img = (snapshot.data?.data()
                        as Map<String, dynamic>?)?["image"];
                        Uint8List? decodeimage;
                        if (img != null) {
                          decodeimage = base64Decode(img);
                        }
                        return Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              backgroundImage: decodeimage != null
                                  ? MemoryImage(decodeimage)
                                  : null,
                            ),
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: IconButton(
                                onPressed: () async {
                                  var pickImage = await ImagePicker()
                                      .pickImage(source: ImageSource.gallery);
                                  if (pickImage != null) {
                                    image.value = pickImage.path;
                                    var readAsBytes =
                                    await pickImage.readAsBytes();
                                    var base64encode =
                                    base64Encode(readAsBytes);

                                    FirebaseFirestore.instance
                                        .collection("User")
                                        .doc(cu?.uid ?? "")
                                        .update(
                                      {
                                        "image": base64encode,
                                      },
                                    );
                                  }
                                },
                                icon: Icon(Icons.photo),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: IconButton(
                                onPressed: () async {
                                  var pickImage = await ImagePicker()
                                      .pickImage(source: ImageSource.camera);
                                  if (pickImage != null) {
                                    image.value = pickImage.path;
                                    var readAsBytes =
                                    await pickImage.readAsBytes();
                                    var base64encode =
                                    base64Encode(readAsBytes);
                                    print("base64 => ${base64encode}");

                                    FirebaseFirestore.instance
                                        .collection("User")
                                        .doc(cu?.uid ?? "")
                                        .update(
                                      {
                                        "image": base64encode,
                                      },
                                    );
                                  }
                                },
                                icon: Icon(Icons.camera_alt),
                              ),
                            ),
                          ],
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        hintText: "Enter your name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: number,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                          hintText: "Enter your number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Get the image as a base64 encoded string
                      String? base64Image = image.value.isNotEmpty
                          ? base64Encode(File(image.value).readAsBytesSync())
                          : null;

                      // Create the AuthUser object with the updated image field
                      AuthUser user = AuthUser(
                        image: base64Image,
                        name: name.text,
                        email: FirebaseAuth.instance.currentUser?.email ?? "",
                        number: number.text,
                      );

                      // Update the user information in Firestore
                      await FirebaseFirestore.instance
                          .collection("User")
                          .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
                          .update(user.toJson());

                      // Clear the fields after updating
                      name.clear();
                      number.clear();

                      // Navigate to the HomePage after updating
                      Get.off(() => Homepage());
                    },
                    child: Text("Edit"),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
