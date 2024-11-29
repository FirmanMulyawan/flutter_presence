import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/page_index_controller.dart';
import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
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
                      children: [
                        ClipOval(
                          child: Container(
                            width: 75,
                            height: 75,
                            color: Colors.grey[200],
                            child: Center(
                              child: Image.network(
                                user["profile"] != null
                                    ? user["profile"] != ""
                                        ? user["profile"]
                                        : defaultImage
                                    : defaultImage,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error);
                                },
                              ),
                            ),
                          ),
                        ),
                        Gap(10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 250,
                              child: Text(
                                user["address"] != null
                                    ? "${user["address"]}"
                                    : "Location not found",
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Gap(20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user["job"],
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Gap(20),
                          Text(
                            user["nip"],
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          Gap(10),
                          Text(
                            user["name"],
                            style: TextStyle(fontSize: 18),
                          )
                        ],
                      ),
                    ),
                    Gap(20),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(20)),
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                              stream: controller.streamTodayPresence(),
                              builder: (context, snapshotToday) {
                                if (snapshotToday.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                Map<String, dynamic>? dataToday =
                                    snapshotToday.data?.data();

                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text("masuk"),
                                        Text(dataToday?["masuk"] == null
                                            ? "-"
                                            : DateFormat.jms().format(
                                                DateTime.parse(
                                                    "${dataToday?["masuk"]["date"]}"))),
                                      ],
                                    ),
                                    Container(
                                      width: 2,
                                      height: 40,
                                      color: Colors.grey,
                                    ),
                                    Column(
                                      children: [
                                        Text("keluar"),
                                        Text(dataToday?["keluar"] == null
                                            ? "-"
                                            : DateFormat.jms().format(
                                                DateTime.parse(
                                                    "${dataToday?["keluar"]["date"]}"))),
                                      ],
                                    )
                                  ],
                                );
                              }),
                    ),
                    Gap(20),
                    Divider(
                      thickness: 2,
                      color: Colors.grey[300],
                    ),
                    Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Last 5 days",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        TextButton(
                            onPressed: () => Get.toNamed(Routes.allPresensi),
                            child: Text("see more")),
                      ],
                    ),
                    Gap(10),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: controller.streamlastPresence(),
                        builder: (context, snapPresence) {
                          if (snapPresence.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapPresence.data!.docs.isEmpty ||
                              snapPresence.data?.docs == null) {
                            return SizedBox(
                              height: 150,
                              child: Center(
                                child: Text("belum ada history presensi"),
                              ),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapPresence.data?.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data =
                                  snapPresence.data?.docs[index].data() ?? {};
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Material(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () {
                                      Get.toNamed(Routes.detailPresensi,
                                          arguments: data);
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Masuk",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                DateFormat.yMMMEd().format(
                                                    DateTime.parse(
                                                        data["date"])),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Text(data["masuk"]?["date"] == null
                                              ? "-"
                                              : DateFormat.jms().format(
                                                  DateTime.parse(
                                                      data["masuk"]["date"]))),
                                          Gap(10),
                                          Text(
                                            "keluar",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(data["keluar"]?["date"] == null
                                              ? "-"
                                              : DateFormat.jms().format(
                                                  DateTime.parse(
                                                      data["keluar"]["date"]))),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        })
                  ],
                );
              } else {
                return Center(
                  child: Text('Data not found'),
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
