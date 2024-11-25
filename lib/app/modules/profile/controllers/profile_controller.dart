import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../component/config/app_const.dart';
import '../../../routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser?.uid ?? '';

    yield* firestore.collection(AppConst.defaultRole).doc(uid).snapshots();
  }

  void logout() async {
    await auth.signOut();

    Get.offAllNamed(Routes.login);
  }
}
