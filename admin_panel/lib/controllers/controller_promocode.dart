import 'dart:convert';

import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/models/model_promocod.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';

class PromocodeController extends GetxController {
  var list = <ModelPromocode>[].obs;
  @override
  void onInit() {
    super.onInit();
    getData();
  }

  Future<bool> getData() async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/get-list-promocode",
      'GET',
      headers: {
        "idhash": AppConfig.company.idhash ?? "null",
        "nameapp": AppConfig.nameApp,
        "md5": MD5.toString(),
      },
    );
    if (response.statusCode == 200) {
      list.clear();
      var json = jsonDecode(response.bodyString ?? '{}');
      // ignore: avoid_print
      print(json);
      for (int i = 0; i < json.length; i++) {
        list.add(ModelPromocode.json(json[i]));
      }
      list.refresh();
      return true;
    } else {
      AppConfig.showDialogMessage(
        content: response.bodyString ?? 'null',
        title: 'Ошибка',
      );
      return false;
    }
  }

  Future<bool> removeO(String? id) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/remove-promocode",
      'DELETE',
      query: {"id": id},
      headers: {
        "idhash": AppConfig.company.idhash ?? "null",
        "nameapp": AppConfig.nameApp,
        "md5": MD5.toString(),
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      AppConfig.showDialogMessage(
        content: response.bodyString ?? 'null',
        title: 'Ошибка',
      );
      return false;
    }
  }

  Future<bool> newO(Map<String, dynamic> data) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/create-add-promocode",
      'POST',
      body: data,
      headers: {
        "idhash": AppConfig.company.idhash ?? "null",
        "nameapp": AppConfig.nameApp,
        "md5": MD5.toString(),
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      AppConfig.showDialogMessage(
        content: response.bodyString ?? 'null',
        title: 'Ошибка',
      );
      return false;
    }
  }

  Future<bool> updateO(Map<String, dynamic> data) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/update-promocode",
      'PUT',
      query: data,
      headers: {
        "idhash": AppConfig.company.idhash ?? "null",
        "nameapp": AppConfig.nameApp,
        "md5": MD5.toString(),
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      AppConfig.showDialogMessage(
        content: response.bodyString ?? 'null',
        title: 'Ошибка',
      );
      return false;
    }
  }
}
