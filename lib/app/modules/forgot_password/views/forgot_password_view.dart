import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Forgot Password'),
          centerTitle: true,
        ),
        body: ListView(padding: EdgeInsets.all(20), children: [
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                labelText: "Email",
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0))),
          ),
          Gap(20),
          Obx(() => ElevatedButton(
              onPressed: () async {
                if (controller.isLoading.isFalse) {
                  await controller.sendEmail();
                }
              },
              child: controller.isLoading.isFalse
                  ? Text("Send Reset Password")
                  : const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ))),
        ]));
  }
}
