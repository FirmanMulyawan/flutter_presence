import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addEmployee() async {
    if (nameC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        UserCredential credential = await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );

        if (credential.user?.uid != null) {
          String? uid = credential.user?.uid;
          await firestore.collection('employee').doc(uid).set({
            "nip": nipC.text,
            "name": nameC.text,
            "email": emailC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String()
          });

          await credential.user?.sendEmailVerification();

          Get.defaultDialog(
              title: "Success add Employe",
              middleText: "kamu berhasil menambahkan employee",
              contentPadding: EdgeInsets.all(20),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    child: Text("Success"))
              ]);
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Get.snackbar("Error", "Password terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Error", "Email telah digunakan");
        }
      } catch (e) {
        Get.snackbar("Error", e.toString());
      }
    } else {
      Get.snackbar("Error", "Tidak boleh kosong");
    }
  }
}
