import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:recipe_app_exam/db_helper.dart';
import 'package:recipe_app_exam/model/recipe_model.dart';

class HomeController extends GetxController {
  RxList<Map<String, String>> recipelist = <Map<String, String>>[].obs;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  RxString recipeimage = ''.obs;
  var reclist = [].obs;


  @override // Add @override annotation
  void onInit() {
    super.onInit();
    fetchrecipe();
  }

  void updateRecipeList(List<Map<String, dynamic>> recipe) {
    recipelist.clear();
    recipelist.addAll(recipe as Iterable<Map<String, String>>);
  }

  void favrecipe() {
    FirebaseFirestore.instance
        .collection("Recipes")
        .doc(DateTime.now().toString())
        .set(Recipe(
                title: title.text,
                description: description.text,
                recipeimage: recipeimage.toString())
            .toJson());
  }

  Future<void> fetchrecipe() async {
    DbHelper helper = DbHelper();
    await helper.initDb();
    List<Map<String, dynamic>> recipe = await helper.GetRecipe();
    recipelist.assignAll(
      recipe.map(
        (e) {
          return {
            'name': e['name'].toString(),
            'description': e['description'].toString(),
            'image': e['image'].toString()
          };
        },
      ),
    );
    recipelist.refresh();
  }
}
