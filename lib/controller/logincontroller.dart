import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class LoginController extends GetxController {
  var passwordVisible = true.obs;

  void toggle() {
    passwordVisible.value = !passwordVisible.value;
  }

}