import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/config/app_const.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  var isObscure = true.obs;
  RxBool isLoading = false.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passwordC.text);

        if (userCredential.user != null) {
          if (userCredential.user?.emailVerified == true) {
            isLoading.value = false;
            if (passwordC.text == AppConst.defaultPassword) {
              Get.offAllNamed(Routes.newPassword);
            } else {
              Get.offAllNamed(Routes.home);
            }
          } else {
            Get.defaultDialog(
                title: "Not Verification",
                middleText: "kamu belum verifikasi akun",
                contentPadding: EdgeInsets.all(20),
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        isLoading.value = false;
                        Get.back();
                      },
                      child: Text("Cancel")),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await userCredential.user?.sendEmailVerification();
                          isLoading.value = false;
                          Get.back();
                          Get.snackbar("Success", "kirim email verification");
                        } catch (e) {
                          isLoading.value = false;
                          Get.snackbar(
                              "Error", "Tidak dapat mengirim email verifikasi");
                        }
                      },
                      child: Text("Send Verification"))
                ]);
          }
        }
        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          Get.snackbar("Error", "User Not Found");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Error", "Wrong Password");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Error", "error");
      }
    } else {
      Get.snackbar("Error", "Harus di isi");
    }
  }
}
