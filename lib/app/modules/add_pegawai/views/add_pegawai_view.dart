import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_pegawai_controller.dart';

class AddPegawaiView extends GetView<AddPegawaiController> {
  const AddPegawaiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Employee'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          TextField(
            controller: controller.nipC,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration:
                InputDecoration(labelText: "NIP", border: OutlineInputBorder()),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.nameC,
            decoration: InputDecoration(
                labelText: "Name", border: OutlineInputBorder()),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.emailC,
            decoration: InputDecoration(
                labelText: "Email", border: OutlineInputBorder()),
          ),
          SizedBox(height: 30),
          ElevatedButton(
              onPressed: () {
                controller.addEmployee();
              },
              child: Text("Add Employee"))
        ],
      ),
    );
  }
}
