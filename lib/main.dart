import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    runApp(ErrorWidgetClass(details));
  };

  runApp(
    StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }
          return GetMaterialApp(
            title: "Application",
            initialRoute: snapshot.data != null ? Routes.home : Routes.login,
            getPages: AppPages.routes,
          );
        }),
  );
}

class ErrorWidgetClass extends StatelessWidget {
  final FlutterErrorDetails errorDetails;
  const ErrorWidgetClass(this.errorDetails, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Custom Error Widget",
      theme: ThemeData(
        primaryColor: Colors.blue, // Warna utama
        scaffoldBackgroundColor: Colors.white, // Warna latar belakang
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.amber, // Warna aksen
        ),
      ),
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 50.0,
              color: Colors.red,
            ),
            Gap(20),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Center(
                child: Text(
                  errorDetails.exceptionAsString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
