import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../routes/app_pages.dart';
import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Presensi'),
        centerTitle: true,
      ),
      body: GetBuilder<AllPresensiController>(
        builder: (c) => FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: controller.getPresence(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.docs.isEmpty || snapshot.data?.docs == null) {
                return SizedBox(
                  height: 150,
                  child: Center(
                    child: Text("belum ada history presensi"),
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      snapshot.data?.docs[index].data() ?? {};

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Material(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Get.toNamed(Routes.detailPresensi, arguments: data);
                        },
                        child: Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Masuk",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat.yMMMEd()
                                        .format(DateTime.parse(data["date"])),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(data["masuk"]?["date"] == null
                                  ? "-"
                                  : DateFormat.jms().format(
                                      DateTime.parse(data["masuk"]["date"]))),
                              Gap(10),
                              Text(
                                "keluar",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(data["keluar"]?["date"] == null
                                  ? "-"
                                  : DateFormat.jms().format(
                                      DateTime.parse(data["keluar"]["date"]))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.dialog(Dialog(
              child: Container(
                  height: 400,
                  padding: EdgeInsets.all(20),
                  child: SfDateRangePicker(
                    // view: DateRangePickerView.year,
                    monthViewSettings:
                        DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                    selectionMode: DateRangePickerSelectionMode.range,
                    showActionButtons: true,
                    onCancel: () => Get.back(),
                    onSubmit: (v) {
                      if (v != null) {
                        if ((v as PickerDateRange).endDate != null) {
                          controller.pickDate((v).startDate!, (v).endDate!);
                        }
                      }
                    },
                  ))));
        },
        child: Icon(Icons.format_list_bulleted_rounded),
      ),
    );
  }
}
