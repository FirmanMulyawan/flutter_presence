import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var isObscure = true.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingAddEmployee = false.obs;

  Future<void> proccessAddEmploye() async {
    if (passwordAdminC.text.isNotEmpty) {
      isLoadingAddEmployee.value = true;

      try {
        String emailAdmin = auth.currentUser?.email ?? '';

        await auth.signInWithEmailAndPassword(
            email: emailAdmin, password: passwordAdminC.text);

        UserCredential employeeCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (employeeCredential.user?.uid != null) {
          String? uid = employeeCredential.user?.uid;
          await firestore.collection('employee').doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "role": "employee",
            "createdAt": DateTime.now().toIso8601String()
          });

          await employeeCredential.user?.sendEmailVerification();
          await auth.signOut();

          await auth.signInWithEmailAndPassword(
              email: emailAdmin, password: passwordAdminC.text);

          isLoadingAddEmployee.value = false;
          Get.back();
          Get.back();
          Get.snackbar("Success", "Success Add Employee");
        }
      } on FirebaseAuthException catch (e) {
        isLoadingAddEmployee.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar("Error", "Password terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Error", "Email telah digunakan");
        } else if (e.code == "wrong-password") {
          Get.snackbar("Error", "wrong password");
        } else {
          Get.snackbar("Error", e.code);
        }
      } catch (e) {
        isLoadingAddEmployee.value = false;
        Get.snackbar("Error", e.toString());
      }
    } else {
      isObscure.value = false;
      Get.snackbar("Error", "Password Wajib di isi");
    }
  }

  Future<void> addEmployee() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isObscure.value = true;
      Get.defaultDialog(
        title: "Admin validation",
        contentPadding: const EdgeInsets.all(20.0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("massukan password untuk validasi admin!"),
            Gap(20),
            Obx(() => TextField(
                  autocorrect: false,
                  controller: passwordAdminC,
                  obscureText: isObscure.value,
                  decoration: InputDecoration(
                      labelText: "Passsowrd",
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          isObscure.value = !isObscure.value;
                        },
                      )),
                )),
            Gap(40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                    onPressed: () {
                      isObscure.value = false;
                      Get.back();
                    },
                    child: Text('Cancel')),
                Obx(() => ElevatedButton(
                    onPressed: () async {
                      if (isLoadingAddEmployee.isFalse) {
                        await proccessAddEmploye();
                      }
                      isObscure.value = false;
                    },
                    child: isLoadingAddEmployee.isFalse
                        ? Text('Add Employee')
                        : SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(),
                          )))
              ],
            )
          ],
        ),
      );
    } else {
      Get.snackbar("Error", "Tidak boleh kosong");
    }
  }
}
