import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_app_exam/model/recipe_model.dart';
import 'package:recipe_app_exam/model/user_model.dart';
import 'package:sqflite/sqflite.dart';

import '../main.dart';

class FSmodel {
  static final FSmodel _instance = FSmodel._();

  FSmodel._();

  factory FSmodel() {
    return _instance;
  }

  void addUser(User? user) {
    AuthUser authUser = AuthUser(
      name: user?.displayName ?? name.text,
      number: number.text,
      email: user?.email ?? "",
      image: user?.photoURL ?? "",
    );

    FirebaseFirestore.instance
        .collection("User")
        .doc(user?.uid ?? "")
        .set(authUser.toJson());
  }

  // void addRecipe(String name, String description, String image) {
  //   FirebaseFirestore.instance.collection('Recipes').add({
  //     'name': name,
  //     'description': description,
  //     'image': image,
  //     // Add other fields as needed
  //   }).then((value) {
  //     print('Recipe added successfully!');
  //   }).catchError((error) {
  //     print('Failed to add recipe: $error');
  //   });
  // }
  void addRecipeToFirestore(String name, String description, String image) {
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      FirebaseFirestore.instance.collection("recipes").add({
        'name': name,
        'description': description,
        'image': image,
        // Add other fields as needed
        'userId': currentUser.uid, // Optionally store the user ID
      }).then((value) {
        print('Recipe added successfully!');
      }).catchError((error) {
        print('Failed to add recipe: $error');
      });
    } else {
      print('User not authenticated!');
    }
  }


}
