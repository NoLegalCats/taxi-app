import 'dart:convert';

import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/models/model_additional_payment.dart';
import 'package:admin_panel/models/model_cards.dart';
import 'package:admin_panel/models/model_dop.dart';
import 'package:admin_panel/models/model_drivers.dart';
import 'package:admin_panel/models/model_orders.dart';
import 'package:admin_panel/models/model_times.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersController extends GetxController {
  var listOrders = <ModelOrders>[].obs;
  var listDrivers = <ModelDrivers>[].obs;
  var listTimes = <ModelTimes>[].obs;
  var listCards = <ModelCards>[].obs;
  var listDOP = <ModelDop>[].obs;
  var listAddPayment = <ModelAdditionalPayment>[].obs;
  @override
  void onInit() {
    super.onInit();
    getData(DateFormat('yyyy-MM-dd').format(DateTime.now()));
  }

  getMoneyAdd(int id) {
    for (int i = 0; i < listAddPayment.length; i++) {
      if (id == listAddPayment[i].id) {
        return listAddPayment[i].payment;
      }
    }
    return 0;
  }

  getCardsMoney(int id) {
    for (int i = 0; i < listCards.length; i++) {
      if (id == listCards[i].id) {
        return listCards[i].payment;
      }
    }
    return 0;
  }

  getInterCardMoney(int idcard, int id) {
    for (int i = 0; i < listCards.length; i++) {
      if (idcard == listCards[i].id) {
        for (int j = 0; j < listCards[i].lisIntertCards.length; j++) {
          if (id == listCards[i].lisIntertCards[j].id) {
            return listCards[i].lisIntertCards[j].payment;
          }
        }
      }
    }
    return 0;
  }

  String? getInfoDriver(ModelOrders item) {
    if (item.listOrderDrivers.isNotEmpty) {
      if (item.listOrderDrivers.last.idstate != 2) {
        for (int i = 0; i < listDrivers.length; i++) {
          if (item.listOrderDrivers.last.iddrivers == listDrivers[i].id) {
            return 'ID ${listDrivers[i].id} ${listDrivers[i].name}, ${listDrivers[i].mobile}';
          }
        }
      }
    }
    return '-';
  }

//ffffffffffffffffffffffffffffff
  String getMoneyOrder(ModelOrders item) {
    int money = 0;
    for (int i = 0; i < item.listOrderRequests.length; i++) {
      if (item.listOrderRequests[i].idstate != 2) {
        int d = 0;
        if (item.listOrderRequests[i].idintermediateCards != null) {
          int? r = getInterCardMoney(item.listOrderRequests[i].idcards!,
              item.listOrderRequests[i].idintermediateCards!);
          print('rer $r');
          if (r != null) {
            if (item.listOrderRequests[i].passengers != null) {
              int cc = item.listOrderRequests[i].passengers!.count ?? 1;
              d += (r * cc); //money += (r * cc);
            }
          }
        } else {
          int? r = getCardsMoney(item.listOrderRequests[i].idcards!);
          print('rer2 $r');
          if (r != null) {
            if (item.listOrderRequests[i].passengers != null) {
              int cc = item.listOrderRequests[i].passengers!.count ?? 1;
              //money += (r * cc);
              d += (r * cc);
            }
          }
        }
        if (item.listOrderRequests[i].passengers!.idaddPAyment != null) {
          int? r =
              getMoneyAdd(item.listOrderRequests[i].passengers!.idaddPAyment!);
          if (r != null) {
            int cc = item.listOrderRequests[i].passengers!.count ?? 1;

            //money += (r * cc);
            d += (r * cc);
          }
        }

        //ffffffffffff
        print('din=$d');
        {

          int dop = 0;

          try {
            var json =
                jsonDecode(item.listOrderRequests[i].passengers!.dataFull);
            for (int d = 0; d < listDOP.length; d++) {
              if (json[listDOP[d].name] != null) {
                if (listDOP[d].id == json[listDOP[d].name]['id']) {
                  if (json[listDOP[d].name]['enable'] == true) {
                    dop += listDOP[d].payment!;
                    //print(r);
                  }
                }
              }
            }
          } catch (e) {
            //
            print('1111 0 ' + e.toString());
          }
          //
          int deg = 0, pay = 0;
          if(item.listOrderRequests[i].passengers!.degres!=null){
          if (item.listOrderRequests[i].passengers!.degres! > 0) {
            try {
              deg = item.listOrderRequests[i].passengers!.degres!;
            } catch (e) {
              print('1111 1 '+e.toString());
            }
          }}
          if(item.listOrderRequests[i].passengers!.payment!=null){
          if (item.listOrderRequests[i].passengers!.payment! > 0) {
            try {
              pay = item.listOrderRequests[i].passengers!.payment!;
            } catch (e) {
              //
              print('1111 2 '+e.toString());
            }
          }}
          d  += dop;

          if (pay > 0) {
            d  -= pay;
          }
          if (deg > 0) {
            //сумма/100×%
            try {
              double dz = ((d / 100) * deg);
              d = d - dz.toInt();
            } catch (e) {
              //
              print('1111 3 '+e.toString());
            }
          }
        }
        print('d=$d');
        money += d;
      }
    }
    return money.toString();
  }

  bool getStateAppClient(ModelOrders item) {
    for (int i = 0; i < item.listOrderRequests.length; i++) {
      if (item.listOrderRequests[i].idstate == 1) {
        if (item.listOrderRequests[i].passengers != null) {
          if (item.listOrderRequests[i].passengers!.idusers != null) {
            return true;
          }
        }
      }
    }
    return false;
  }

  getInterCardStr(int idcard, int id) {
    for (int i = 0; i < listCards.length; i++) {
      if (idcard == listCards[i].id) {
        for (int j = 0; j < listCards[i].lisIntertCards.length; j++) {
          if (id == listCards[i].lisIntertCards[j].id) {
            return '${listCards[i].lisIntertCards[j].inMap}-${listCards[i].lisIntertCards[j].outMap}';
          }
        }
      }
    }
    return '-';
  }

  String getStateCards(ModelOrders item) {
    String str = '';
    //bool state = false;
    for (int i = 0; i < item.listOrderRequests.length; i++) {
      if (item.listOrderRequests[i].idstate == 1) {
        if (item.listOrderRequests[i].idintermediateCards != null) {
          str +=
              '${getInterCardStr(item.listOrderRequests[i].idcards!, item.listOrderRequests[i].idintermediateCards!)}\n';
        }
      }
    }

    return str;
  }

  String getStateOrder(ModelOrders item) {
    if (item.listOrderDrivers.isNotEmpty) {
      switch (item.listOrderDrivers.last.idstate) {
        case 1:
          return 'Заказ принял\nводитель';
        case 2:
          return 'Назначение водителя\nотмененно';
        case 3:
          return 'В работе';

        case 4:
          return 'Завершен';

        default:
          return 'Неизвестный статус';
      }
    }
    return '-';
  }

  Color getStateOrderColorText(ModelOrders item) {
    if (item.listOrderDrivers.isNotEmpty) {
      switch (item.listOrderDrivers.last.idstate) {
        case 1:
          return const Color(0xff18D497); //'Заказ принял\nводитель';
        case 2:
          return const Color(0xffE63D3A); //'Назначение водителя\nотмененно';
        case 3:
          return const Color(0xff18D497); //'В работе';

        case 4:
          return const Color(0xff205CBE); //'Завершен';

        default:
          return const Color(0xff80A0B9); //'Неизвестный статус';
      }
    }
    return const Color(0xff80A0B9);
  }

  Color getStateOrderColor(ModelOrders item) {
    if (item.listOrderDrivers.isNotEmpty) {
      switch (item.listOrderDrivers.last.idstate) {
        case 1:
          return const Color(0xffA4EED7); //'Заказ принял\nводитель';
        case 2:
          return const Color(0xffF6B0B2); //'Назначение водителя\nотмененно';
        case 3:
          return const Color(0xffA4EED7); //'В работе';

        case 4:
          return const Color(0xffBCD8FF); //'Завершен';

        default:
          return const Color(0xffDAE1E7); //'Неизвестный статус';
      }
    }
    return const Color(0xffDAE1E7);
  }

  String? getTimes(int? id) {
    for (int i = 0; i < listTimes.length; i++) {
      if (id == listTimes[i].id) {
        if (listTimes[i].minute != null) {
          String r = Duration(minutes: listTimes[i].minute!)
              .toString()
              .substring(0, 5);
          if (r[4] == ':') {
            r = r.substring(0, 4);
          }
          return r;
        }
        return null;
      }
    }
    return null;
  }

  ModelTimes? getTimesModel(int? id) {
    for (int i = 0; i < listTimes.length; i++) {
      if (id == listTimes[i].id) {
        return listTimes[i];
      }
    }
    return null;
  }

  Future<bool> getData(String? date) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/get-list-orders",
      'GET',
      query: {"date": date},
      headers: {
        "idhash": AppConfig.company.idhash ?? "null",
        "nameapp": AppConfig.nameApp,
        "md5": MD5.toString(),
      },
    );
    if (response.statusCode == 200) {
      listCards.clear();
      listOrders.clear();
      listTimes.clear();
      listDrivers.clear();
      listAddPayment.clear();
      listDOP.clear();

      var json = jsonDecode(response.bodyString ?? '{}');
      // ignore: avoid_print
      print(json);

      for (int i = 0; i < json['cards'].length; i++) {
        listCards.add(ModelCards.json(json['cards'][i]));
      }
      listCards.value = listCards.reversed.toList();
      listCards.refresh();

      for (int i = 0; i < json['times'].length; i++) {
        listTimes.add(ModelTimes.json(json['times'][i]));
      }
      listTimes.refresh();

      for (int i = 0; i < json['drivers'].length; i++) {
        listDrivers.add(ModelDrivers.json(json['drivers'][i]));
      }
      listDrivers.refresh();

      for (int i = 0; i < json['additional_payment'].length; i++) {
        listAddPayment
            .add(ModelAdditionalPayment.json(json['additional_payment'][i]));
      }
      listAddPayment.refresh();

      for (int i = 0; i < json['orders'].length; i++) {
        listOrders.add(ModelOrders.json(json['orders'][i]));
      }
      listOrders.refresh();

      for (int i = 0; i < json['option_passagers'].length; i++) {
        listDOP.add(ModelDop.json(json['option_passagers'][i]));
      }
      listDOP.refresh();

      return true;
    } else {
      AppConfig.showDialogMessage(
        content: response.bodyString ?? 'null',
        title: 'Ошибка',
      );
      return false;
    }
  }

  Future<ModelOrders?> getIdhashData(String? idhash) async {
    if (idhash == null) {
      return null;
    }
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/get-list-order",
      'GET',
      query: {"id": idhash},
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
      for (int i = 0; i < json.length;) {
        return ModelOrders.json(json['orders'][i]);
      }
      return null;
    } else {
      AppConfig.showDialogMessage(
        content: response.bodyString ?? 'null',
        title: 'Ошибка',
      );
      return null;
    }
  }

  Future<bool> updateO(Map<String, dynamic> data) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/update-order",
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

  Future<bool> updateOpassager(Map<String, dynamic> data) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/update-order-request-passengers",
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

  Future<bool> removeO(String? idhash) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/remove-order",
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
      "${AppConfig.host}/create-order",
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

  Future<bool> newOpassager(Map<String, dynamic> data) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/create-order-request-passengers",
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

  Future<bool> removeOpassager(String? idhash, int state) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/remove-order-request-passengers",
      'DELETE',
      query: {"id": idhash, "state": state.toString()},
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

  Future<bool> removeODriver(String? idhash) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/remove-order-driver",
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

  Future<bool> newODriver(Map<String, dynamic> data) async {
    GetConnect gethttp = GetConnect(timeout: const Duration(seconds: 20));
    // ignore: non_constant_identifier_names
    Digest MD5 = md5.convert(utf8.encode(
        '${AppConfig.company.id}:${AppConfig.company.idhash}:${AppConfig.nameApp}:${AppConfig.keyApp}:${AppConfig.company.aes128}'));
    Response response = await gethttp.request(
      "${AppConfig.host}/create-order-driver",
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
}
