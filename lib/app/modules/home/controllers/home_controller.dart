import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../component/config/app_const.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser?.uid ?? '';

    yield* firestore.collection(AppConst.defaultRole).doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamlastPresence() async* {
    String uid = auth.currentUser?.uid ?? '';

    yield* firestore
        .collection(AppConst.defaultRole)
        .doc(uid)
        .collection(AppConst.collectionPresence)
        .orderBy("date", descending: true)
        .limitToLast(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTodayPresence() async* {
    String uid = auth.currentUser?.uid ?? '';

    String todayID =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    yield* firestore
        .collection(AppConst.defaultRole)
        .doc(uid)
        .collection(AppConst.collectionPresence)
        .doc(todayID)
        .snapshots();
  }
}
