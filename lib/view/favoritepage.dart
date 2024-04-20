import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('recipes')
            .doc(FirebaseAuth.instance.currentUser?.uid ?? "")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            var data = snapshot.data?.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
            if (data == null || data.isEmpty) {
              return Center(
                child: Text('No favorite recipes found.'),
              );
            }
            List<dynamic> recipeList = data['favorites'];
            return ListView.builder(
              itemCount: recipeList.length,
              itemBuilder: (context, index) {
                // Assuming each item in the recipeList is a Map<String, dynamic>
                Map<String, dynamic> recipe = recipeList[index];
                return ListTile(
                  leading: CircleAvatar(
                    // Assuming 'image' is a key in the recipe Map
                    backgroundImage: NetworkImage(recipe['image']),
                  ),
                  title: Text(recipe['name']),
                  subtitle: Text(recipe['description']),
                  // You can add more details or actions here
                );
              },
            );
          }
        },
      ),
    );
  }
}
