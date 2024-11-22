import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  var isObscure = true.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  void login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
            email: emailC.text, password: passwordC.text);

        if (userCredential.user != null) {
          if (userCredential.user?.emailVerified == true) {
            if (passwordC.text == "password") {
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
                      onPressed: () => Get.back(), child: Text("Cancel")),
                  ElevatedButton(
                      onPressed: () async {
                        try {
                          await userCredential.user?.sendEmailVerification();
                          Get.back();
                          Get.snackbar("Success", "kirim email verification");
                        } catch (e) {
                          Get.snackbar(
                              "Error", "Tidak dapat mengirim email verifikasi");
                        }
                      },
                      child: Text("Send Verification"))
                ]);
          }
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          Get.snackbar("Error", "User Not Found");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Error", "Wrong Password");
        }
      } catch (e) {
        Get.snackbar("Error", "error");
      }
    } else {
      Get.snackbar("Error", "Harus di isi");
    }
  }
}
