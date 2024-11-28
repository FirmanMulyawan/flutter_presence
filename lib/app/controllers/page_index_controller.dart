import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../component/config/app_const.dart';

import '../routes/app_pages.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int index) async {
    pageIndex.value = index;
    switch (index) {
      case 1:
        Map<String, dynamic> dataResponse = await determinePosition();
        if (dataResponse["error"] != true) {
          Position position = dataResponse["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);
          // print('${placemarks[0].street}');
          // print('${placemarks[1].street}');
          // print('${placemarks[2].street}');
          // print('${placemarks[3].street}');
          // print('${placemarks[4].street}');
          String address =
              "${placemarks[0].name}, ${placemarks[0].subLocality}, ${placemarks[0].locality}";
          await updatePosition(position, address);

          // presensi
          await presensi(position, address);
          Get.snackbar("Berhasil", "Kamu telah mengisi daftar hadir");
        } else {
          Get.snackbar("Error", dataResponse["message"]);
        }
        break;
      case 2:
        Get.offAllNamed(Routes.profile);
        break;
      default:
        Get.offAllNamed(Routes.home);
    }
  }

  Future<void> presensi(Position position, String address) async {
    String uid = auth.currentUser?.uid ?? '';
    CollectionReference<Map<String, dynamic>> colPresence = firestore
        .collection(AppConst.defaultRole)
        .doc(uid)
        .collection(AppConst.collectionPresence);

    QuerySnapshot<Map<String, dynamic>> snapPresence = await colPresence.get();

    DateTime now = DateTime.now();
    String todayDocID = DateFormat.yMd().format(now).replaceAll("/", "-");

    if (snapPresence.docs.isEmpty) {
      // belum pernah absen & set absen masuk
      await colPresence.doc(todayDocID).set({
        "date": now.toIso8601String(),
        "masuk": {
          "date": now.toIso8601String(),
          "lat": position.latitude,
          "long": position.longitude,
          "address": address,
          "status": "Di dalam area"
        }
      });
    } else {
      // sudah pernah absen -> cek hari ini sudah absen masuk / keluar ?
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocID).get();
      if (todayDoc.exists) {
        // tinggal absen keluar atau sudah absen masuk & keluar
        Map<String, dynamic>? dataPresenceToday = todayDoc.data();
        if (dataPresenceToday?["keluar"] != null) {
          // sudah absen masuk & keluar
          Get.snackbar("Sukses",
              "Kamu telah absen masuk & keluar dan tidak dapat masuk & keluar");
        } else {
          // absen keluar
          await colPresence.doc(todayDocID).update({
            "keluar": {
              "date": now.toIso8601String(),
              "lat": position.latitude,
              "long": position.longitude,
              "address": address,
              "status": "Di dalam area"
            }
          });
        }
      } else {
        // absen masuk
        await colPresence.doc(todayDocID).set({
          "date": now.toIso8601String(),
          "masuk": {
            "date": now.toIso8601String(),
            "lat": position.latitude,
            "long": position.longitude,
            "address": address,
            "status": "Di dalam area"
          }
        });
      }
    }
  }

  Future<void> updatePosition(Position position, String address) async {
    String uid = auth.currentUser?.uid ?? '';
    await firestore.collection(AppConst.defaultRole).doc(uid).update({
      "position": {"lat": position.latitude, "long": position.longitude},
      "address": address
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      // return Future.error('Location services are disabled.');
      return {"message": "Location services are disabled.", "error": true};
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        // return Future.error('Location permissions are denied');
        return {"message": "Location permissions are denied", "error": true};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Location permissions are permanently denied, we cannot request permissions.",
        "error": true
      };
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device.",
      "error": false
    };
  }
}
