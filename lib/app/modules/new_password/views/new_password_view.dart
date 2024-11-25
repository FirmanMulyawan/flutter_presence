import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/new_password_controller.dart';

class NewPasswordView extends GetView<NewPasswordController> {
  const NewPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Password'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Obx(() => TextField(
                autocorrect: false,
                controller: controller.passwordC,
                obscureText: controller.isObscure.value,
                decoration: InputDecoration(
                  labelText: "New Password",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isObscure.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: controller.toggleObscure,
                  ),
                ),
              )),
          SizedBox(height: 30),
          ElevatedButton(
              onPressed: () {
                controller.changePassword();
              },
              child: Text("Continue"))
        ],
      ),
    );
  }
}
