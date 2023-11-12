import 'dart:convert';

import 'package:admin_panel/home.dart';
import 'package:admin_panel/models/model_company.dart';
import 'package:admin_panel/views/auth.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppConfig {
  static bool mobile = true;
  static bool test = false;
  static String host =
      test == true ? "http://localhost:8080" : "https://api.vista-taxi.ru";
  static String nameApp = "company_v2";
  static String keyApp = "31343131353131313133131323313132";
  static ModelCompany company =
      ModelCompany(); /*
    ..aes128 = "31343131353131313133333131313135"
    ..password = "1231459"
    ..login = "vistataxi"
    ..idhash = "31343f31353131"
    ..id = 1
    ..name = "ИП виста такси"
    ..info = "Первая компания";*/
  /*
    if (AppConfig.mobile == true) {
      return Scaffold(
        appBar: AppBar(),
      );
    }
    */

  static Future<bool> auth(String login, String password) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/auth-company",
      'GET',
      query: {
        "login": login,
        "password": password,
      },
      headers: {
        "idhash": AppConfig.company.idhash ?? "null",
        "nameapp": AppConfig.nameApp,
        "md5": MD5.toString(),
      },
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.bodyString ?? '{}');
      // ignore: avoid_print
      print(json);
      company = ModelCompany.json(json);
      saveLoginData(password, login);
      Get.offAll(() => Home());

      return true;
    } else {
      AppConfig.showDialogMessage(
        content: response.bodyString ?? 'null',
        title: 'Ошибка',
      );
      return false;
    }
  }

  static Future<bool> sendDriverNotif(int idorder) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    Response response = await gethttp.request(
      "${AppConfig.host}/get-send-notif-driver-new-order",
      'GET',
      query: {"idorder": idorder.toString()},
    );
    if (response.statusCode == 200) {
      AppConfig.showDialogMessage(
        content: response.bodyString ?? 'null',
        title: 'Уведомление',
      );
      return true;
    } else {
      AppConfig.showDialogMessage(
        content: response.bodyString ?? 'null',
        title: 'Ошибка',
      );
      return false;
    }
  }

  static Future<dynamic> getProfile() async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));

    Response response = await gethttp.request(
      "${AppConfig.host}/get-profile-company",
      'GET',
      headers: {
        "idhash": AppConfig.company.idhash ?? "null",
        "nameapp": AppConfig.nameApp,
        "md5": MD5.toString(),
      },
    );
    if (response.statusCode == 200) {
      dynamic json = jsonDecode(response.bodyString ?? '{}');
      return json;
    } else {
      AppConfig.showDialogMessage(
        content: response.bodyString ?? 'null',
        title: 'Ошибка',
      );
      return null;
    }
  }

  static exit() {
    removeLoginData();
    Get.offAll(() => AuthView());
  }

  static removeLoginData() async {
    final box = GetStorage();
    await box.remove('password');
    await box.remove('login');
  }

  static saveLoginData(String? key, String? auth) async {
    final box = GetStorage();
    await box.write('password', key);
    await box.write('login', auth);
  }

  static Map<String, dynamic>? getLoginData() {
    final box = GetStorage();
    var key = box.read('password');
    var auth = box.read('login');
    if (key != null && auth != null) {
      return {
        "password": key,
        "login": auth,
      };
    }
    return null;
  }

  static showDialogMessage(
      {required String title, required String content}) async {
    return await showDialog(
      context: Get.context!,
      builder: (context) {
        return AlertDialog(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.antiAlias,
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Закрыть'),
            ),
          ],
        );
      },
    );
  }
}


/*
await showDialog(
  context: Get.context!,
  builder: (context) {
    return SimpleDialog(
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      title: const Text('Добавить расписание'),
      children: [
        SizedBox(
          height: 550,
          width: 500,
          child: ListView(
            children: [
              //
            ],
          ),
        ),
        Row(
          children: [
            const Spacer(),
            GestureDetector(
              onTap: ()=> Get.back(),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20),
                height: 50,
                width: 200,
                decoration: const BoxDecoration(
                  color: Color(0xff819fb9),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Отмена',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                //
              },
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20, right: 20),
                height: 50,
                width: 200,
                decoration: const BoxDecoration(
                  color: Color(0xff205CBE),
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Добавить',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        )
      ],
    );
  },
);
*/