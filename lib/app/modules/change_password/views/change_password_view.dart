import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Obx(() => TextField(
                autocorrect: false,
                controller: controller.currentC,
                obscureText: controller.isCurrentObscure.value,
                decoration: InputDecoration(
                    labelText: "Current Password",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isCurrentObscure.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        controller.isCurrentObscure.value =
                            !controller.isCurrentObscure.value;
                      },
                    )),
              )),
          Gap(10),
          Obx(() => TextField(
                autocorrect: false,
                controller: controller.newC,
                obscureText: controller.isNewObscure.value,
                decoration: InputDecoration(
                    labelText: "New Password",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isNewObscure.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        controller.isNewObscure.value =
                            !controller.isNewObscure.value;
                      },
                    )),
              )),
          Gap(10),
          Obx(() => TextField(
                autocorrect: false,
                controller: controller.confirmC,
                obscureText: controller.isConfirmObscure.value,
                decoration: InputDecoration(
                    labelText: "Confirm Password",
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isConfirmObscure.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        controller.isConfirmObscure.value =
                            !controller.isConfirmObscure.value;
                      },
                    )),
              )),
          Gap(40),
          Obx(() => ElevatedButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.changePassword();
                }
              },
              child: controller.isLoading.isFalse
                  ? Text("Change Password")
                  : const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    )))
        ],
      ),
    );
  }
}
