import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:recipe_app_exam/db_helper.dart';

class HomeController extends GetxController {
  RxList<Map<String, String>> recipelist = <Map<String, String>>[].obs;

  @override // Add @override annotation
  void onInit() {
    super.onInit();
    fetchrecipe();
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
