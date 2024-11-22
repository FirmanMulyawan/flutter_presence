import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => Get.toNamed(Routes.addPegawai),
              icon: Icon(Icons.person))
        ],
      ),
      body: const Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
      floatingActionButton: Obx(() => FloatingActionButton(
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                controller.isLoading.value = true;
                await FirebaseAuth.instance.signOut();
                controller.isLoading.value = false;

                Get.offAllNamed(Routes.login);
              }
            },
            child: controller.isLoading.isFalse
                ? Icon(Icons.logout)
                : const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
          )),
    );
  }
}
