import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var isCurrentObscure = true.obs;
  var isNewObscure = true.obs;
  var isConfirmObscure = true.obs;

  RxBool isLoading = false.obs;

  TextEditingController currentC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  void changePassword() async {
    if (currentC.text.isNotEmpty &&
        newC.text.isNotEmpty &&
        confirmC.text.isNotEmpty) {
      if (newC.text == confirmC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser?.email ?? '';

          await auth.signInWithEmailAndPassword(
              email: emailUser, password: currentC.text);

          await auth.currentUser?.updatePassword(newC.text);

          Get.back();
          Get.snackbar("Success", "Success Change password");
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            Get.snackbar("Error", "wrong password");
          } else {
            Get.snackbar("Error", e.code.toLowerCase());
          }
        } catch (e) {
          Get.snackbar("Error", e.toString());
        } finally {
          isLoading.value = false;
        }
      } else {
        Get.snackbar("Error", "confirm password harus sama");
      }
    } else {
      Get.snackbar("Error", "Semua input harus di isi");
    }
  }
}
