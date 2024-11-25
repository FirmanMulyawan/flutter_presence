import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/config/app_const.dart';
import '../../../routes/app_pages.dart';

class NewPasswordController extends GetxController {
  TextEditingController passwordC = TextEditingController();
  var isObscure = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void toggleObscure() {
    isObscure.value = !isObscure.value; // Ganti status
  }

  void changePassword() async {
    if (passwordC.text.isNotEmpty) {
      if (passwordC.text != AppConst.defaultPassword) {
        try {
          String email = auth.currentUser!.email!;

          await auth.currentUser?.updatePassword(passwordC.text);
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: email, password: passwordC.text);

          Get.offAllNamed(Routes.home);
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            Get.snackbar("Error", "weak password");
          }
        } catch (e) {
          Get.snackbar("Error", e.toString());
        }
      } else {
        Get.snackbar("Error", "Jangan gunakan password yang terdahulu");
      }
    } else {
      Get.snackbar("Error", "Password harus di isi ");
    }
  }
}
