import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
        SizedBox(height: 20),
        Obx(() => TextField(
              autocorrect: false,
              controller: controller.passwordC,
              obscureText: controller.isObscure.value,
              decoration: InputDecoration(
                  labelText: "Password",
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
                    onPressed: () => controller.toggleObscure(),
                  )),
            )),
        SizedBox(height: 30),
        ElevatedButton(
            onPressed: () {
              controller.login();
            },
            child: Text("Login")),
        TextButton(
            onPressed: () => Get.toNamed(Routes.newPassword),
            child: Text("Forgot Password"))
      ]),
    );
  }
}
