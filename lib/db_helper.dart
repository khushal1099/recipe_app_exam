import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _obj = DbHelper._helper();

  DbHelper._helper();

  final dbname = 'recipe.db';

  factory DbHelper() {
    return _obj;
  }

  static DbHelper get instance => _obj;

  Database? database;

  Future<void> initDb() async {
    database = await openDatabase(
      dbname,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE "Recipe" ('
              '"id" INTEGER, '
              '"name" TEXT NOT NULL, '
              '"description" TEXT NOT NULL, '
              '"image" TEXT , '
              'PRIMARY KEY("id" AUTOINCREMENT))',
        );
      },
      singleInstance: true,
    );
  }

  Future<void> insertRecipe(String name, String description, String image) async {
    var db = await openDatabase(dbname);
    List<Map<String, dynamic>> result = await db.query(
      'Recipe',
      where: 'name = ? AND description = ? AND image = ?' ,
      whereArgs: [name, description,image],
    );

    // If the quote doesn't exist, insert it into the database
    if (result.isEmpty) {
      await db.insert(
        'Recipe',
        {
          'name': name,
          'description': description,
          'image': image, // Include the image path in the database entry
        },
      );
    } else {
      // Quote already exists, handle accordingly
      print('Quote already exists in the database');
    }
  }

  Future<List<Map<String, Object?>>> GetRecipe() async {
    var db = await openDatabase(dbname);
    return await db.query('Recipe');
  }
}
