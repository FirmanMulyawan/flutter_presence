import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../controllers/page_index_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();

  ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasData) {
                Map<String, dynamic> user = snapshot.data?.data() ?? {};
                String defaultImage =
                    "https://ui-avatars.com/api/?name=${user['name'].toString()}";

                return ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (user['name'].toString().isNotEmpty)
                          ClipOval(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Image.network(
                                user["profile"] != null
                                    ? user["profile"] != ""
                                        ? user["profile"]
                                        : defaultImage
                                    : defaultImage,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error);
                                },
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Gap(20),
                    Text(
                      user['name'].toString().toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                    Gap(5),
                    Text(
                      user['email'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    Gap(20),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text("Update Profile"),
                      onTap: () =>
                          Get.toNamed(Routes.updateProfile, arguments: user),
                    ),
                    ListTile(
                      leading: Icon(Icons.vpn_key),
                      title: Text("Change Password"),
                      onTap: () => Get.toNamed(Routes.changePassword),
                    ),
                    if (user["role"] == "admin")
                      ListTile(
                        leading: Icon(Icons.person_add),
                        title: Text("Add Employee"),
                        onTap: () => Get.toNamed(Routes.addPegawai),
                      ),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text("Logout"),
                      onTap: () => controller.logout(),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: Text("Tidak dapat memuat data user"),
                );
              }
            }),
        bottomNavigationBar: ConvexAppBar(
          style: TabStyle.fixedCircle,
          items: [
            TabItem(icon: Icons.home, title: 'Home'),
            TabItem(icon: Icons.fingerprint, title: 'Add'),
            TabItem(icon: Icons.people, title: 'Profile'),
          ],
          initialActiveIndex: pageC.pageIndex.value,
          onTap: (int i) => pageC.changePage(i),
        ));
  }
}
