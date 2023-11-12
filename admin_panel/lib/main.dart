import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/home.dart';
import 'package:admin_panel/views/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  dynamic getParams = Uri.base.queryParameters;
  if (getParams != null) {
    if (getParams['mobile'] == "true") {
      AppConfig.mobile = true;
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          selectedItemColor: Color(0xff283048),
          unselectedItemColor: Color(0x5f283048),
          unselectedLabelStyle: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          selectedLabelStyle: TextStyle(
            letterSpacing: 1,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'VistaTaxi',
      home: AuthView(), // Home(),
    );
  }
}
