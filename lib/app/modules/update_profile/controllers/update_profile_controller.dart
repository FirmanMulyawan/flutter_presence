import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/config/app_const.dart';

class UpdateProfileController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        isLoading.value = true;
        await firestore
            .collection(AppConst.defaultRole)
            .doc(uid)
            .update({"name": nameC.text});
        Get.snackbar("Success", "Susscess update profile");
      } catch (e) {
        Get.snackbar("Error", "Tidak dapat update profile");
      } finally {
        isLoading.value = false;
      }
    }
  }
}
