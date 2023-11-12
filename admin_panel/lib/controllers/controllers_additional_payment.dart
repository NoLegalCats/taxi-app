import 'dart:convert';

import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/models/model_additional_payment.dart';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';

class AddpaymentController extends GetxController {
  var list = <ModelAdditionalPayment>[].obs;
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
      "${AppConfig.host}/get-list-add-payment",
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
        list.add(ModelAdditionalPayment.json(json[i]));
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

  Future<bool> removeO(String? idhash) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/remove-add-payment",
      'DELETE',
      query: {"id": idhash},
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
      "${AppConfig.host}/create-add-payment",
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
      "${AppConfig.host}/update-add-payment",
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
