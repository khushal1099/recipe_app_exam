import 'package:get/get.dart';

class SignUpController extends GetxController{
  var passwordVisible = true.obs;

  void toggle() {
    passwordVisible.value = !passwordVisible.value;
  }
}