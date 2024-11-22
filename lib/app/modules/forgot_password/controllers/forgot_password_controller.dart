import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailC = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> sendEmail() async {
    if (emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await auth.sendPasswordResetEmail(email: emailC.text);
        Get.snackbar("Success", "Cek your email");
        Get.back();
      } catch (e) {
        Get.snackbar("Error", "tidak dapat mengirim email reset password");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "email is not null");
    }
  }
}
