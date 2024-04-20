import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recipe_app_exam/controller/homecontroller.dart';
import 'package:recipe_app_exam/model/fs_model.dart';
import 'package:recipe_app_exam/view/favoritepage.dart';
import 'package:recipe_app_exam/view/loginpage.dart';
import '../db_helper.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  HomeController controller = Get.put(HomeController());
  DbHelper helper = DbHelper();
  Uint8List? decodeimg;

  @override
  void initState() {
    FirebaseFirestore.instance.collection("User").get().then((value) {
      return (value) {};
    });
    controller.fetchrecipe();
    _fetchRecipesFromDatabase();
    super.initState();
  }

  void _fetchRecipesFromDatabase() async {
    List<Map<String, dynamic>> recipes = await helper.GetRecipe();
    // Update the recipe list in the controller
    controller.updateRecipeList(recipes);
  }

  @override
  Widget build(BuildContext context) {
    var cu = FirebaseAuth.instance.currentUser;
    return Scaffold(
      drawer: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("User")
            .doc(cu?.uid ?? "")
            .snapshots(),
        builder: (context, snapshot) {
          var data = snapshot.data?.data() as Map<String, dynamic>?;
          print("data=>$data");
          return NavigationDrawer(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: cu != null &&
                        cu.providerData.isNotEmpty &&
                        cu.providerData[0].providerId == 'google.com'
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(data?["image"] ?? ""),
                        radius: 30, // Adjust the radius as needed
                      )
                    : data?["image"] != null
                        ? StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("User")
                                .doc(cu?.uid ?? "")
                                .snapshots(),
                            builder: (context, snapshot) {
                              var img = (snapshot.data?.data()
                                  as Map<String, dynamic>?)?["image"];

                              if (img != null) {
                                decodeimg = base64Decode(img);
                              }
                              return CircleAvatar(
                                backgroundImage: decodeimg != null
                                    ? MemoryImage(decodeimg!)
                                    : null,
                                radius: 30, // Adjust the radius as needed
                              );
                            },
                          )
                        : const CircleAvatar(
                            child: Icon(Icons.account_circle),
                            radius: 30, // Adjust the radius as needed
                          ),
                accountEmail: Text(cu?.email ?? ""),
                accountName:
                    cu != null && cu.providerData[0].providerId == 'google.com'
                        ? Text(cu.displayName ?? "")
                        : Text(
                            "${data?["name"]}",
                          ),
              ),
              ListTile(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  await GoogleSignIn().signOut();
                  Get.offAll(
                    LoginPage(),
                  );
                },
                title: Text(
                  "Logout",
                ),
              ),
              ListTile(
                onTap: () {
                  Get.to(()=>FavoritePage());
                },
                title: Text(
                  "Favorite Recipes",
                ),
              ),
            ],
          );
        },
      ),
      appBar: AppBar(
        title: Text(
          "Recipes",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.recipelist.length,
          itemBuilder: (context, index) {
            var rec = controller.recipelist[index];
            return Stack(
              children: [
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: FileImage(File(rec["image"]!)),
                    ),
                    title: Text("${rec["name"]}"),
                    subtitle: Text(
                      "${rec["description"]}",
                      softWrap: true, // Allow text to wrap to the next line
                      maxLines: 10, // Set maximum lines to 3
                      overflow: TextOverflow
                          .ellipsis, // Add ellipsis if text overflows
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          FSmodel().addRecipeToFirestore(
                              rec["name"]!, rec["description"]!, rec["image"]!);
                        },
                        icon: Icon(
                          Icons.favorite,
                          size: 20,
                        ),
                      ),
                      PopupMenuButton(
                        iconSize: 20,
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              child: Text("Edit"),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text("Add Recipe"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        // Set the column size to the minimum
                                        children: [
                                          StreamBuilder<DocumentSnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("Recipes")
                                                .doc(cu?.uid ?? "")
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              String? img =
                                                  (snapshot.data?.data() as Map<
                                                          String, dynamic>?)?[
                                                      "recipeimage"];
                                              Uint8List? decodeimage;
                                              if (img != null) {
                                                decodeimage = base64Decode(img);
                                              }
                                              return Stack(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 70,
                                                    backgroundColor:
                                                        Colors.white,
                                                    backgroundImage:
                                                        decodeimage != null
                                                            ? MemoryImage(
                                                                decodeimage)
                                                            : null,
                                                  ),
                                                  Positioned(
                                                    left: 0,
                                                    bottom: 0,
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        var pickImage =
                                                            await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .gallery);
                                                        if (pickImage != null) {
                                                          controller.recipeimage
                                                                  .value =
                                                              pickImage.path;
                                                          var readAsBytes =
                                                              await pickImage
                                                                  .readAsBytes();
                                                          var base64encode =
                                                              base64Encode(
                                                                  readAsBytes);

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Recipes")
                                                              .doc(
                                                                  cu?.uid ?? "")
                                                              .update(
                                                            {
                                                              "recipeimage":
                                                                  base64encode,
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
                                                        var pickImage =
                                                            await ImagePicker()
                                                                .pickImage(
                                                                    source: ImageSource
                                                                        .camera);
                                                        if (pickImage != null) {
                                                          controller.recipeimage
                                                                  .value =
                                                              pickImage.path;
                                                          var readAsBytes =
                                                              await pickImage
                                                                  .readAsBytes();
                                                          var base64encode =
                                                              base64Encode(
                                                                  readAsBytes);
                                                          print(
                                                              "base64 => ${base64encode}");

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Recipes")
                                                              .doc(
                                                                  cu?.uid ?? "")
                                                              .update(
                                                            {
                                                              "recipeimage":
                                                                  base64encode,
                                                            },
                                                          );
                                                        }
                                                      },
                                                      icon: Icon(
                                                          Icons.camera_alt),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                          TextFormField(
                                            controller: controller.title,
                                            decoration: InputDecoration(
                                              labelText: "Recipe Name",
                                            ),
                                          ),
                                          TextFormField(
                                            controller: controller.description,
                                            decoration: InputDecoration(
                                              labelText: "Recipe Description",
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Cancel"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            helper.insertRecipe(
                                                controller.title.text,
                                                controller.description.text,
                                                controller.recipeimage
                                                    .toString());
                                            Navigator.of(context).pop();

                                            controller.title.clear();
                                            controller.description.clear();
                                            controller.recipeimage.value = "";
                                          },
                                          child: const Text("Submit"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            PopupMenuItem(
                              child: Text("Delete"),
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Add Recipe"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  // Set the column size to the minimum
                  children: [
                    StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Recipes")
                          .doc(cu?.uid ?? "")
                          .snapshots(),
                      builder: (context, snapshot) {
                        String? img = (snapshot.data?.data()
                            as Map<String, dynamic>?)?["recipeimage"];
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
                                    controller.recipeimage.value =
                                        pickImage.path;
                                    var readAsBytes =
                                        await pickImage.readAsBytes();
                                    var base64encode =
                                        base64Encode(readAsBytes);

                                    FirebaseFirestore.instance
                                        .collection("Recipes")
                                        .doc(cu?.uid ?? "")
                                        .update(
                                      {
                                        "recipeimage": base64encode,
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
                                    controller.recipeimage.value =
                                        pickImage.path;
                                    var readAsBytes =
                                        await pickImage.readAsBytes();
                                    var base64encode =
                                        base64Encode(readAsBytes);
                                    print("base64 => ${base64encode}");

                                    FirebaseFirestore.instance
                                        .collection("Recipes")
                                        .doc(cu?.uid ?? "")
                                        .update(
                                      {
                                        "recipeimage": base64encode,
                                      },
                                    );
                                  }
                                },
                                icon: Icon(Icons.camera_alt),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    TextFormField(
                      controller: controller.title,
                      decoration: InputDecoration(
                        labelText: "Recipe Name",
                      ),
                    ),
                    TextFormField(
                      controller: controller.description,
                      decoration: InputDecoration(
                        labelText: "Recipe Description",
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      helper.insertRecipe(
                          controller.title.text,
                          controller.description.text,
                          controller.recipeimage.toString());
                      Navigator.of(context).pop();
                      controller.title.clear();
                      controller.description.clear();
                      controller.recipeimage.value = "";
                    },
                    child: const Text("Submit"),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
