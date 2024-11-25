import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
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
              Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasData) {
              Map<String, dynamic> user = snapshot.data?.data() ?? {};
              return ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Image.network(
                            "https://ui-avatars.com/api/?name=${user['name']}",
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
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.vpn_key),
                    title: Text("Change Password"),
                    onTap: () {},
                  ),
                  if (user["role"] == "admin")
                    ListTile(
                      leading: Icon(Icons.person_add),
                      title: Text("Add Employee"),
                      onTap: () {},
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
    );
  }
}