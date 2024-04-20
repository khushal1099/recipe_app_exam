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

  void addRecipe(String title, String decription, String image) {
    Recipe recipe = Recipe(
      title: title,
      description: decription,
      recipeimage: image,
    );

    FirebaseFirestore.instance
        .collection("Recipes")
        .doc(FirebaseAuth.instance.currentUser?.uid??"")
        .set(recipe.toJson());
  }

}
