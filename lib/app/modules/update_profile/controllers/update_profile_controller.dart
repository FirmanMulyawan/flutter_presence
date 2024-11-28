// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../component/config/app_const.dart';

class UpdateProfileController extends GetxController {
  TextEditingController nameC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  RxBool isLoading = false.obs;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();

  XFile? image;

  Future<void> updateProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {"name": nameC.text};

        if (image != null) {
          // proses upload image ke firebase store
          // File file = File(image?.path ?? '');
          // String ext = image?.name.split(".").last ?? "png";

          // await storage.ref('$uid/profile.$ext').putFile(file);
          // String urlImage =
          //     await storage.ref('$uid/profile.$ext').getDownloadURL();

          data.addAll({
            "profile":
                "https://fastly.picsum.photos/id/206/200/300.jpg?hmac=zgY9ucK8PnViYfAc_jWui8B3N-I1-cVdM4BtXYOpk7I"
          });
        }
        await firestore.collection(AppConst.defaultRole).doc(uid).update(data);
        image = null;

        Get.snackbar("Success", "Susscess update profile");
      } catch (e) {
        Get.snackbar("Error", "Tidak dapat update profile");
      } finally {
        isLoading.value = false;
      }
    }
  }

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {}
    update();
  }

  void deleteProfile(String uid) async {
    try {
      await firestore
          .collection(AppConst.defaultRole)
          .doc(uid)
          .update({"profile": FieldValue.delete()});

      Get.back();
      Get.snackbar("Success", "Success delete profile picture");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      update();
    }
  }
}
