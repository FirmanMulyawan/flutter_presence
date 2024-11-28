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
          actions: [
            IconButton(
                onPressed: () => Get.toNamed(Routes.profile),
                icon: Icon(Icons.person))
          ],
        ),
        body: ListView(
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
                      child: Text("X"),
                    ),
                  ),
                ),
                Gap(10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text("Jl Raya Gandul"),
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
                    "Developer",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Gap(20),
                  Text(
                    "1111111",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Gap(10),
                  Text(
                    "sandh",
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("masuk"),
                      Text("-"),
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
                      Text("-"),
                    ],
                  )
                ],
              ),
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                TextButton(onPressed: () {}, child: Text("see more")),
              ],
            ),
            Gap(10),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "masuk",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat.yMMMEd().format(DateTime.now()),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Text(DateFormat.jms().format(DateTime.now())),
                      Gap(10),
                      Text(
                        "keluar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(DateFormat.jms().format(DateTime.now())),
                    ],
                  ),
                );
              },
            )
          ],
        ),
        bottomNavigationBar: ConvexAppBar(
          // style: TabStyle.fixedCircle,
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
