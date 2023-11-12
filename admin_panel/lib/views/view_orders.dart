/*
Осталось:
- фильтры
- редактирование
- создние пассажиров
- статусы
*/

import 'dart:convert';

import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/controllers/controllers_ordes.dart';
import 'package:admin_panel/models/model_additional_payment.dart';
import 'package:admin_panel/models/model_cards.dart';
import 'package:admin_panel/models/model_dop.dart';
import 'package:admin_panel/models/model_drivers.dart';
import 'package:admin_panel/models/model_intermediate_cards.dart';
import 'package:admin_panel/models/model_order_requests.dart';
import 'package:admin_panel/models/model_orders.dart';
import 'package:admin_panel/models/model_passengers.dart';
import 'package:admin_panel/models/model_times.dart';
import 'package:admin_panel/views/items/item_order.dart';
import 'package:admin_panel/widgets/button_custom.dart';
import 'package:admin_panel/widgets/drop_company.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ViewOrders extends StatelessWidget {
  final controller = Get.put(OrdersController());
  var date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  var cards = 'Не выбрано'.obs;
  var filter = 0.obs;
  var degress = '0'.obs;
  TextEditingController cDate = TextEditingController();

  List<String> listDegress() {
    List<String> l = ['0'];
    for (int i = 1; i < 101; i++) {
      l.add(i.toString());
    }
    return l;
  }

  String getSummDegress(ModelOrders o) {
    String s = controller.getMoneyOrder(o);
    try {
      if (s != '0' && degress.value != '0') {
        return ((int.parse(s) / 100) * int.parse(degress.value))
            .toInt()
            .toString();
      }
      return '0';
    } catch (e) {
      return 'error';
    }
  }

  bool filterCount(int j) {
    bool r = filterOne.value == true
        ? controller.listOrders[j].countPassagers() <
                controller.listOrders[j].countMest!
            ? true
            : false
        : filterTwo.value == true
            ? controller.listOrders[j].countPassagers() ==
                    controller.listOrders[j].countMest
                ? true
                : false
            : filterFree.value == true
                ? controller.listOrders[j].countPassagers() != 0 &&
                        controller.listOrders[j].countMest! >
                            controller.listOrders[j].countPassagers()
                    ? true
                    : false
                : true;
    return r;
  }

  List<String> getDate() {
    List<String> l = [];
    DateTime now = DateTime.now();
    now = now.add(const Duration(days: -10));
    var formatter = DateFormat('yyyy-MM-dd');
    for (int i = 0; i < 30; i++) {
      l.add(formatter.format(now));
      now = now.add(const Duration(days: 1));
    }
    return l;
  }

  List<String> getDate2() {
    List<String> l = [];
    DateTime now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    for (int i = 0; i < 20; i++) {
      l.add(formatter.format(now));
      now = now.add(const Duration(days: 1));
    }
    return l;
  }

  var filterOne = false.obs;
  var filterTwo = false.obs;
  var filterFree = false.obs;
  filterOneSend(bool b) {
    if (b == true) {
      filterTwo.value = false;
      filterTwo.refresh();
      filterFree.value = false;
      filterFree.refresh();
    }
    filterOne.value = b;
    filterOne.refresh();
  }

  filterTwoSend(bool b) {
    if (b == true) {
      filterFree.value = false;
      filterFree.refresh();
      filterOne.value = false;
      filterOne.refresh();
    }
    filterTwo.value = b;
    filterTwo.refresh();
  }

  filterFreeSend(bool b) {
    if (b == true) {
      filterTwo.value = false;
      filterTwo.refresh();
      filterOne.value = false;
      filterOne.refresh();
    }
    filterFree.value = b;
    filterFree.refresh();
  }

  List<String> getCardsIn() {
    List<String> l = ['Не выбрано'];
    for (int i = 0; i < controller.listCards.length; i++) {
      l.add(
          '${controller.listCards[i].inMap} - ${controller.listCards[i].outMap}');
    }
    return l;
  }

  int? getCardsID(String str) {
    for (int i = 0; i < controller.listCards.length; i++) {
      if (str ==
          '${controller.listCards[i].inMap} - ${controller.listCards[i].outMap}') {
        return (controller.listCards[i].id);
      }
    }
    return null;
  }

  ModelCards? getCardsIDmodel(int id) {
    for (int i = 0; i < controller.listCards.length; i++) {
      if (id == controller.listCards[i].id) {
        return controller.listCards[i];
      }
    }
    return null;
  }

  String? getCardsSTR(int id) {
    for (int i = 0; i < controller.listCards.length; i++) {
      if (id == controller.listCards[i].id) {
        return '${controller.listCards[i].inMap} - ${controller.listCards[i].outMap}';
      }
    }
    return null;
  }

  List<String> getCards(ModelCards card) {
    List<String> l = ['${card.inMap} - ${card.outMap}'];
    for (int i = 0; i < card.lisIntertCards.length; i++) {
      l.add(
          '${card.lisIntertCards[i].inMap} - ${card.lisIntertCards[i].outMap}');
    }
    return l;
  }

  ModelIntermediateCards? getCardsInter(ModelCards card) {
    for (int i = 0; i < card.lisIntertCards.length; i++) {
      if (cards.value ==
          '${card.lisIntertCards[i].inMap} - ${card.lisIntertCards[i].outMap}') {
        return card.lisIntertCards[i];
      }
    }
    return null;
  }

  String? getTimeCards(int? idtimes, ModelCards card) {
    ModelIntermediateCards? cM = getCardsInter(card);
    ModelTimes? tM1 = controller.getTimesModel(idtimes);

    String? init = controller.getTimes(idtimes);
    if (tM1 != null) {
      if (cM != null) {
        if (tM1.minute != null && cM.countMinute != null) {
          int m = tM1.minute! + cM.countMinute!;
          String r = Duration(minutes: m).toString().substring(0, 5);
          if (r[4] == ':') {
            r = r.substring(0, 4);
          }
          return r;
        }
      }
    }
    return init;
  }

  getCardsName(int id) {
    for (int i = 0; i < controller.listCards.length; i++) {
      if (id == controller.listCards[i].id) {
        return "${controller.listCards[i].inMap} - ${controller.listCards[i].outMap}";
      }
    }

    return 'Неизвестный маршрут';
  }

  getTimeStr(int id) {
    ModelTimes? tM1 = controller.getTimesModel(id);
    if (tM1 == null) {
      return 'NULL';
    }
    String r = Duration(minutes: tM1.minute!).toString().substring(0, 5);
    if (r[4] == ':') {
      r = r.substring(0, 4);
    }
    return r;
  }

  ViewOrders({super.key});
  @override
  Widget build(BuildContext context) {
    if (AppConfig.mobile == true) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Заказы'),
          actions: [
            IconButton(
              onPressed: () async {
                //
                await showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return SimpleDialog(
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      insetPadding: const EdgeInsets.all(5),
                      title: const Text('Фильтр'),
                      children: [
                        Obx(
                          () => GestureDetector(
                            onTap: () async {
                              //
                              if (filter.value == 1) {
                                filter.value = 0;
                                filterOneSend(false);
                              } else {
                                filter.value = 1;
                                filterOneSend(true);
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              height: 50,
                              decoration: BoxDecoration(
                                color: filter.value == 1
                                    ? const Color(0xff819fb9)
                                    : Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      'Свободными местами',
                                      style: TextStyle(
                                        color: filter.value == 1
                                            ? Colors.white
                                            : const Color(0xff819FB9),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => GestureDetector(
                            onTap: () async {
                              //
                              if (filter.value == 2) {
                                filter.value = 0;
                                filterTwoSend(false);
                              } else {
                                filter.value = 2;
                                filterTwoSend(true);
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              height: 50,
                              decoration: BoxDecoration(
                                color: filter.value == 2
                                    ? const Color(0xff819fb9)
                                    : Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      'Где нет мест',
                                      style: TextStyle(
                                        color: filter.value == 2
                                            ? Colors.white
                                            : const Color(0xff819FB9),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => GestureDetector(
                            onTap: () async {
                              //
                              if (filter.value == 3) {
                                filter.value = 0;
                                filterFreeSend(false);
                              } else {
                                filter.value = 3;
                                filterFreeSend(true);
                              }
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              height: 50,
                              decoration: BoxDecoration(
                                color: filter.value == 3
                                    ? const Color(0xff819fb9)
                                    : Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child: Center(
                                child: Row(
                                  children: [
                                    Text(
                                      'Свободные только с пассажирами',
                                      style: TextStyle(
                                        color: filter.value == 3
                                            ? Colors.white
                                            : const Color(0xff819FB9),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Маршрут\n($cards)',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff80A0B9),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    //getCardsIn
                                    await showDialog(
                                      context: Get.context!,
                                      builder: (context) {
                                        return SimpleDialog(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.antiAlias,
                                          title: const Text('Маршрут'),
                                          children: [
                                            SizedBox(
                                              height: 550,
                                              width: 300,
                                              child: ListView(
                                                children: [
                                                  for (int k = 0;
                                                      k < getCardsIn().length;
                                                      k++)
                                                    ListTile(
                                                      title:
                                                          Text(getCardsIn()[k]),
                                                      onTap: () {
                                                        cards.value =
                                                            getCardsIn()[k];
                                                        cards.refresh();

                                                        Get.back();
                                                      },
                                                    ),
                                                  SizedBox(
                                                    height: 100,
                                                    child: Row(
                                                      children: [
                                                        const Spacer(),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              Get.back(),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    right: 20),
                                                            height: 50,
                                                            width: 200,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xff819fb9),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    15),
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                'Отмена',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_rounded,
                                    color: Color(0xff80A0B9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Дата\n(${date.value})',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff80A0B9),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: Get.context!,
                                      builder: (context) {
                                        return SimpleDialog(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.antiAlias,
                                          title: const Text('Дата'),
                                          children: [
                                            SizedBox(
                                              height: 550,
                                              width: 300,
                                              child: ListView(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 200,
                                                        child: TextFieldCustom(
                                                          controller: cDate,
                                                          title: 'Дата',
                                                          hintText:
                                                              '2023-01-29',
                                                          inputFormatters: [
                                                            MaskTextInputFormatter(
                                                              mask:
                                                                  '####-##-##',
                                                              filter: {
                                                                "#": RegExp(
                                                                    r'[0-9]')
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            date.value =
                                                                cDate.text;
                                                            date.refresh();
                                                            Get.back();
                                                            controller.getData(
                                                                date.value);
                                                          },
                                                          icon: const Icon(Icons
                                                              .check_circle),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  for (int k = 0;
                                                      k < getDate().length;
                                                      k++)
                                                    ListTile(
                                                      title: Text(getDate()[k]),
                                                      onTap: () {
                                                        date.value =
                                                            getDate()[k];
                                                        date.refresh();
                                                        controller.getData(
                                                            date.value);
                                                        Get.back();
                                                      },
                                                    ),
                                                  SizedBox(
                                                    height: 100,
                                                    child: Row(
                                                      children: [
                                                        const Spacer(),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              Get.back(),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    right: 20),
                                                            height: 50,
                                                            width: 200,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xff819fb9),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    15),
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                'Отмена',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_rounded,
                                    color: Color(0xff80A0B9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 150,
                          child: Row(
                            children: [
                              const Spacer(),
                              GestureDetector(
                                onTap: () => Get.back(),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  height: 50,
                                  width: 150,
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
                                onTap: () => Get.back(),
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  height: 50,
                                  width: 150,
                                  decoration: const BoxDecoration(
                                    color: Color(0xff205CBE),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Готово',
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
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              color: const Color(0xff819fb9),
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () async {
                List<ModelTimes> listTimes = controller.listTimes;
                var date1 = getDate2()[0]
                    .obs; // = DateFormat('dd-MM-yyyy').format(DateTime.now());

                var cards1 = ''.obs;
                var full = false.obs;
                var lTimes =
                    [for (int d = 0; d < listTimes.length; d++) false].obs;
                Map<String, TextEditingController> list = {};
                list['count_day'] = TextEditingController(text: "0");
                list['degres'] = TextEditingController(text: "4");
                list['count_mest'] = TextEditingController(text: "4");
                Future<bool> Function(Map<String, dynamic>) newObj =
                    controller.newO;

                await showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return SimpleDialog(
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      insetPadding: const EdgeInsets.all(5),
                      title: const Text('Добавить рейсы'),
                      children: [
                        Obx(
                          () => SizedBox(
                            height: Get.height - 60,
                            width: Get.width - 10,
                            child: ListView(
                              children: [
                                DropList(
                                  list: getCardsIn(),
                                  type: 'drop',
                                  title: 'Маршрут',
                                  initMail: cards1.value,
                                  onPress: (s) {
                                    if (s != null) {
                                      // ignore: avoid_print
                                      print(s);
                                      cards1.value = s;
                                      cards1.refresh();
                                    }
                                  },
                                ),
                                DropList(
                                  list: getDate2(),
                                  type: 'drop',
                                  title: 'Дата',
                                  initMail: date1.value,
                                  onPress: (s) {
                                    if (s != null) {
                                      date1.value = s;
                                      date1.refresh();
                                    }
                                  },
                                ),
                                TextFieldCustom(
                                  title: 'На сколько дней вперед?',
                                  hintText: '1',
                                  controller: list['count_day'],
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                      mask: "##",
                                      filter: {"#": RegExp(r'[0-9]')},
                                    ),
                                  ],
                                ),
                                TextFieldCustom(
                                  title: 'Кол-мест',
                                  hintText: 'кол-мест',
                                  controller: list['count_mest'],
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                      mask: "#",
                                      filter: {"#": RegExp(r'[0-9]')},
                                    ),
                                  ],
                                ),
                                TextFieldCustom(
                                  title: '%',
                                  hintText: '4',
                                  controller: list['degres'],
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                      mask: "##",
                                      filter: {"#": RegExp(r'[0-9]')},
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                SwitchListTile(
                                  title: const Text(
                                      'Создать рейсы по всему расписанию'),
                                  value: full.value,
                                  onChanged: (v) {
                                    full.value = v;
                                    full.refresh();
                                    for (int s = 0; s < lTimes.length; s++) {
                                      if (v == true) {
                                        lTimes[s] = true;
                                      } else {
                                        lTimes[s] = false;
                                      }
                                    }
                                  },
                                ),
                                for (int j = 0; j < listTimes.length; j += 2)
                                  Row(
                                    children: [
                                      Flexible(
                                        child: SwitchListTile(
                                          title: Text(
                                              '${controller.getTimes(controller.listTimes[j].id)}'),
                                          value: lTimes[j],
                                          onChanged: (v) {
                                            lTimes[j] = v;
                                            lTimes.refresh();
                                          },
                                        ),
                                      ),
                                      if ((j + 1) < listTimes.length)
                                        Flexible(
                                          child: SwitchListTile(
                                            title: Text(
                                                '${controller.getTimes(controller.listTimes[j + 1].id)}'),
                                            value: lTimes[j + 1],
                                            onChanged: (v) {
                                              lTimes[j + 1] = v;
                                              lTimes.refresh();
                                            },
                                          ),
                                        ),
                                    ],
                                  ),
                                SizedBox(
                                  height: 150,
                                  child: Row(
                                    children: [
                                      const Spacer(),
                                      GestureDetector(
                                        onTap: () => Get.back(),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          height: 50,
                                          width: 150,
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
                                        onTap: () async {
                                          //
                                          if (date1.value == '') {
                                            AppConfig.showDialogMessage(
                                                title: 'Уведомление',
                                                content: 'Вы не выбрали дату');
                                            return;
                                          }
                                          if (cards1.value == 'Не выбрано' ||
                                              cards1.value == '') {
                                            AppConfig.showDialogMessage(
                                                title: 'Уведомление',
                                                content:
                                                    'Вы не выбрали маршрут');
                                            return;
                                          }
                                          int c1 = 1;
                                          try {
                                            c1 = int.parse(
                                                list['count_day']!.text);
                                            c1++;
                                          } catch (e) {
                                            print(e);
                                            AppConfig.showDialogMessage(
                                                title: 'Уведомление',
                                                content:
                                                    'Вы указали не верное кол-во дней');
                                            return;
                                          }

                                          for (int e = 0; e < c1; e++) {
                                            var formatter =
                                                DateFormat('yyyy-MM-dd');

                                            var d = DateTime.parse(date1.value);
                                            d = d.add(Duration(days: e));
                                            print(formatter.format(d));
                                            for (int r = 0;
                                                r < listTimes.length;
                                                r++) {
                                              if (lTimes[r] == true) {
                                                //
                                                int? idcardSearch =
                                                    getCardsID(cards1.value);
                                                if (idcardSearch != null) {
                                                  int da = 0;
                                                  if (list['degres']
                                                          ?.text
                                                          .length !=
                                                      0) {
                                                    try {
                                                      da = int.parse(
                                                          list['degres']!
                                                              .text
                                                              .toString());
                                                    } catch (e) {
                                                      ///
                                                    }
                                                  }
                                                  await newObj({
                                                    "count_mest":
                                                        list['count_mest']
                                                            ?.text,
                                                    "date": formatter.format(d),
                                                    "times_idtimes":
                                                        listTimes[r].id,
                                                    "cards_idcards":
                                                        idcardSearch,
                                                    "degres": da,
                                                  });
                                                }
                                              }
                                            }
                                          }
                                          Get.back();
                                          controller.getData(date.value);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          height: 50,
                                          width: 150,
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
                controller.getData(date.value);
              },
              color: const Color(0xff819fb9),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                controller.getData(date.value);
              },
              color: const Color(0xff819fb9),
              icon: const Icon(Icons.update),
            ),
          ],
        ),
        body: Obx(
          () => ListView(children: [
            for (int j = 0; j < controller.listOrders.length; j++)
              if (cards.value ==
                      getCardsSTR(controller.listOrders[j].idcards!) ||
                  cards.value == 'Не выбрано')
                if (filterCount(j) == true)
                  ExpansionTile(
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    collapsedBackgroundColor:
                        j.isEven == true ? Colors.white : Colors.grey[200],
                    backgroundColor:
                        j.isEven == true ? Colors.white : Colors.grey[200],
                    leading: Column(
                      children: [
                        Text('№ ${controller.listOrders[j].id}'),
                        const SizedBox(height: 5),
                        Icon(
                          Icons.circle,
                          size: 20,
                          color: controller
                              .getStateOrderColor(controller.listOrders[j]),
                        ),
                      ],
                    ),
                    title: Text(
                      '${getCardsName(controller.listOrders[j].idcards!)}, ${controller.listOrders[j].date} ${controller.getTimes(controller.listOrders[j].idtimes!)}',
                    ),
                    subtitle: Text(
                        'Водитель: ${controller.getInfoDriver(controller.listOrders[j])}\nМест: ${controller.listOrders[j].countPassagers()} / ${controller.listOrders[j].countMest}\nЗаказ:${controller.getStateAppClient(controller.listOrders[j]) == true ? "C приложения" : "-"}\nСумма: ${controller.getMoneyOrder(controller.listOrders[j])} руб\nСтатус: ${controller.getStateOrder(controller.listOrders[j])}'),
                    children: [
                      Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              AppConfig.sendDriverNotif(
                                  controller.listOrders[j].id!);
                            },
                            color: const Color(0xff205CBE),
                            icon: const Icon(Icons.send),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            color: const Color(0xff205CBE),
                            onPressed: () async {
                              //--
                              var item1 = ModelOrders().obs;
                              item1.value = controller.listOrders[j];
                              var driver1 = ''.obs;
                              String? time1 = controller
                                  .getTimes(controller.listOrders[j].idtimes);
                              late List<ModelAdditionalPayment> addpayments1 =
                                  controller.listAddPayment;
                              var list = <String, TextEditingController>{}.obs;

                              List<ModelDrivers> listDrivers1 =
                                  controller.listDrivers;
                              List<ModelCards> cards1 = controller.listCards;
                              Future<ModelOrders?> Function(String? idhash)
                                  onUpdate = controller.getIdhashData;
                              Future<bool> Function(Map<String, dynamic>)
                                  onSave = controller.updateO;
                              Future<bool> Function(Map<String, dynamic>)
                                  onSavePassagers = controller.updateOpassager;
                              Future<bool> Function(String? idhash) onRemove =
                                  controller.removeO;
                              Future<bool> Function(String? idhash, int state)
                                  onRemovePassagers =
                                  controller.removeOpassager;

                              Future<bool> Function(Map<String, dynamic>)
                                  onSaveDriver = controller.newODriver;
                              Future<bool> Function(String? idhash)
                                  onRemoveDriver = controller.removeODriver;

                              //--
                              String? getInitIdDriver1() {
                                driver1.value = '';
                                driver1.refresh();
                                int? id;
                                if (item1.value.listOrderDrivers.isNotEmpty) {
                                  if (item1.value.listOrderDrivers.last
                                          .idstate !=
                                      2) {
                                    id = item1
                                        .value.listOrderDrivers.last.iddrivers;
                                  }
                                }
                                //print('id $id');

                                if (id != null) {
                                  for (int i = 0;
                                      i < listDrivers1.length;
                                      i++) {
                                    if (id == listDrivers1[i].id) {
                                      String r =
                                          'ID ${listDrivers1[i].id} ${listDrivers1[i].name}, ${listDrivers1[i].mobile}';
                                      driver1.value = r;
                                      driver1.refresh();
                                      //print (r);
                                      return r;
                                    }
                                  }
                                }
                                return null;
                              }

                              onInitTextController1() {
                                getInitIdDriver1();
                                list['count_mest'] = TextEditingController(
                                    text: item1.value.countMest.toString());
                                list['driver_mobile'] = TextEditingController(
                                    text: item1.value.driverMobile);
                                list['driver_info'] = TextEditingController(
                                    text: item1.value.driverInfo);

                                list['degres'] = TextEditingController(
                                    text: item1.value.degres.toString());
                                //
                                list.refresh();
                              }

                              onupdade1() async {
                                ModelOrders? o =
                                    await onUpdate(item1.value.id.toString());
                                if (o != null) {
                                  item1.value = o;
                                  item1.refresh();
                                }
                                onInitTextController1();
                              }

                              String getInfoStateDriver1(int id) {
                                switch (id) {
                                  case 1:
                                    return 'Заказ принял';
                                  case 2:
                                    return 'Назначение водителя отмененно';
                                  case 3:
                                    return 'В работе';

                                  case 4:
                                    return 'Завершен';

                                  default:
                                    return 'Неизвестен';
                                }
                              }

                              List<String> getDriver1() {
                                List<String> l = ['Не выбрано'];
                                for (int i = 0; i < listDrivers1.length; i++) {
                                  if (listDrivers1[i].idstate == 1) {
                                    l.add(
                                        'ID ${listDrivers1[i].id} ${listDrivers1[i].name}, ${listDrivers1[i].mobile}');
                                  }
                                }
                                return l;
                              }

                              String? getInfoIdDriver1() {
                                int? id;
                                if (item1.value.listOrderDrivers.isNotEmpty) {
                                  if (item1.value.listOrderDrivers.last
                                          .idstate !=
                                      2) {
                                    id = item1
                                        .value.listOrderDrivers.last.iddrivers;
                                  }
                                }
                                //print('id $id');

                                if (id != null) {
                                  for (int i = 0;
                                      i < listDrivers1.length;
                                      i++) {
                                    if (id == listDrivers1[i].id) {
                                      String r =
                                          'ID ${listDrivers1[i].id} ${listDrivers1[i].name}, ${listDrivers1[i].mobile}\nМашина ${listDrivers1[i].markaModel} ${listDrivers1[i].color} ${listDrivers1[i].number}, мест: ${listDrivers1[i].count}';
                                      //print (r);
                                      return r;
                                    }
                                  }
                                }
                                return null;
                              }

                              int? getIdDriver1() {
                                for (int i = 0; i < listDrivers1.length; i++) {
                                  if (driver1.value ==
                                      'ID ${listDrivers1[i].id} ${listDrivers1[i].name}, ${listDrivers1[i].mobile}') {
                                    return listDrivers1[i].id;
                                  }
                                }
                                return null;
                              }

                              String getStrCardInter1(int idcard, int id) {
                                for (int i = 0; i < cards1.length; i++) {
                                  if (idcard == cards1[i].id) {
                                    for (int j = 0;
                                        j < cards1[i].lisIntertCards.length;
                                        j++) {
                                      if (id ==
                                          cards1[i].lisIntertCards[j].id) {
                                        return 'ожидание ${cards1[i].lisIntertCards[j].countMinute} минут, ${cards1[i].lisIntertCards[j].inMap}-${cards1[i].lisIntertCards[j].outMap}, ${cards1[i].lisIntertCards[j].payment} руб';
                                      }
                                    }
                                  }
                                }
                                return '-';
                              }

                              String getStrCard1(int id) {
                                for (int i = 0; i < cards1.length; i++) {
                                  if (id == cards1[i].id) {
                                    return '${cards1[i].inMap}-${cards1[i].outMap}, ${cards1[i].payment} руб';
                                  }
                                }
                                return '-';
                              }

                              int getCardInterMoney1(int idcard, int id) {
                                for (int i = 0; i < cards1.length; i++) {
                                  if (idcard == cards1[i].id) {
                                    for (int j = 0;
                                        j < cards1[i].lisIntertCards.length;
                                        j++) {
                                      if (id ==
                                          cards1[i].lisIntertCards[j].id) {
                                        return cards1[i]
                                                .lisIntertCards[j]
                                                .payment ??
                                            0;
                                      }
                                    }
                                  }
                                }
                                return 0;
                              }

                              int getCardMoney1(int id) {
                                for (int i = 0; i < cards1.length; i++) {
                                  if (id == cards1[i].id) {
                                    return cards1[i].payment ?? 0;
                                  }
                                }
                                return 0;
                              }

                              int getAddPayMoney1(int id) {
                                for (int i = 0; i < addpayments1.length; i++) {
                                  if (id == addpayments1[i].id) {
                                    return addpayments1[i].payment ?? 0;
                                  }
                                }
                                return 0;
                              }

                              String getAddPayStr1(int id) {
                                for (int i = 0; i < addpayments1.length; i++) {
                                  if (id == addpayments1[i].id) {
                                    return '${addpayments1[i].text} +${addpayments1[i].payment} руб';
                                  }
                                }
                                return '';
                              }

                              //fffffff
                              int dopMoney(ModelPassengers objP) {
                                int r = 0;
                                var json;
                                if (objP.dataFull == null) {
                                  return 0;
                                }
                                try {
                                  json = jsonDecode(objP.dataFull);
                                  print(objP.dataFull);
                                } catch (e) {
                                  print('err json dop, $e');
                                  return 0;
                                }
                                try {
                                  for (int d = 0;
                                      d < controller.listDOP.length;
                                      d++) {
                                    if (json[controller.listDOP[d].name] !=
                                        null) {
                                      if (controller.listDOP[d].id ==
                                          json[controller.listDOP[d].name]
                                              ['id']) {
                                        if (json[controller.listDOP[d].name]
                                                ['enable'] ==
                                            true) {
                                          r += controller.listDOP[d].payment!;
                                          print(r);
                                        }
                                      }
                                    }
                                  }
                                } catch (e) {
                                  print('err fi, $e');
                                }
                                return r;
                              }

                              //fffffff
                              String dopMoneyString(ModelPassengers objP) {
                                String r = 'Доп. опции: ';
                                var json;
                                if (objP.dataFull == null) {
                                  return r;
                                }
                                try {
                                  json = jsonDecode(objP.dataFull);
                                } catch (e) {
                                  print('err json dop');
                                }
                                try {
                                  for (int d = 0;
                                      d < controller.listDOP.length;
                                      d++) {
                                    if (json[controller.listDOP[d].name] !=
                                        null) {
                                      if (controller.listDOP[d].id ==
                                          json[controller.listDOP[d].name]
                                              ['id']) {
                                        if (json[controller.listDOP[d].name]
                                                ['enable'] ==
                                            true) {
                                          r += controller.listDOP[d].name! +
                                              ', ';
                                          print(r);
                                        }
                                      }
                                    }
                                  }
                                } catch (e) {
                                  print('eer json, $e');
                                }
                                return r;
                              }

                              //ffffffffffffffffff
                              String getCardsMoneyInfo1(int id) {
                                for (int i = 0;
                                    i < item1.value.listOrderRequests.length;
                                    i++) {
                                  if (item1.value.listOrderRequests[i].id ==
                                      id) {
                                    int dop = 0;
                                    String dopStr = '';
                                    if (item1.value.listOrderRequests[i]
                                            .passengers!.idaddPAyment !=
                                        null) {
                                      dop = getAddPayMoney1(item1
                                          .value
                                          .listOrderRequests[i]
                                          .passengers!
                                          .idaddPAyment!);
                                      dopStr = getAddPayStr1(item1
                                          .value
                                          .listOrderRequests[i]
                                          .passengers!
                                          .idaddPAyment!);
                                    }
                                    if (item1.value.listOrderRequests[i]
                                            .idintermediateCards !=
                                        null) {
                                      //item.value.listOrderRequests[i].idintermediateCards
                                      int tr = ((getCardInterMoney1(
                                                  item1
                                                      .value
                                                      .listOrderRequests[i]
                                                      .idcards!,
                                                  item1
                                                      .value
                                                      .listOrderRequests[i]
                                                      .idintermediateCards!) *
                                              item1.value.listOrderRequests[i]
                                                  .passengers!.count!) +
                                          (dop *
                                              item1.value.listOrderRequests[i]
                                                  .passengers!.count!));
                                      tr += dopMoney(item1.value
                                          .listOrderRequests[i].passengers!);
                                      {
                                        int deg = 0, pay = 0;
                                        if (item1.value.listOrderRequests[i]
                                                .passengers!.degres !=
                                            0) {
                                          try {
                                            deg = item1
                                                .value
                                                .listOrderRequests[i]
                                                .passengers!
                                                .degres!;
                                          } catch (e) {
                                            //
                                          }
                                        }
                                        if (item1.value.listOrderRequests[i]
                                                .passengers!.payment !=
                                            0) {
                                          try {
                                            pay = item1
                                                .value
                                                .listOrderRequests[i]
                                                .passengers!
                                                .payment!;
                                          } catch (e) {
                                            //
                                            print('err2');
                                          }
                                        }

                                        if (pay != 0) {
                                          tr = tr - pay;
                                        }
                                        if (deg != 0) {
                                          //сумма/100×%
                                          try {
                                            double dz = ((tr / 100) * deg);
                                            tr = tr - dz.toInt();
                                          } catch (e) {
                                            //
                                            print('err1');
                                          }
                                        }
                                      }

                                      return '$dopStr${dopStr.isNotEmpty ? '\n' : ''}${getStrCardInter1(item1.value.listOrderRequests[i].idcards!, item1.value.listOrderRequests[i].idintermediateCards!)}, ${dopMoneyString(item1.value.listOrderRequests[i].passengers!)} \nИтого $tr руб';
                                    } else {
                                      //item.value.listOrderRequests[i].idcards
                                      int tr = ((getCardMoney1(item1
                                                  .value
                                                  .listOrderRequests[i]
                                                  .idcards!) *
                                              item1.value.listOrderRequests[i]
                                                  .passengers!.count!) +
                                          (dop *
                                              item1.value.listOrderRequests[i]
                                                  .passengers!.count!));
                                      tr += dopMoney(item1.value
                                          .listOrderRequests[i].passengers!);
                                      {
                                        int deg = 0, pay = 0;
                                        if (item1.value.listOrderRequests[i]
                                                .passengers!.degres !=
                                            0) {
                                          try {
                                            deg = item1
                                                .value
                                                .listOrderRequests[i]
                                                .passengers!
                                                .degres!;
                                          } catch (e) {
                                            //
                                          }
                                        }
                                        if (item1.value.listOrderRequests[i]
                                                .passengers!.payment !=
                                            0) {
                                          try {
                                            pay = item1
                                                .value
                                                .listOrderRequests[i]
                                                .passengers!
                                                .payment!;
                                          } catch (e) {
                                            //
                                            print('err2');
                                          }
                                        }

                                        if (pay != 0) {
                                          tr = tr - pay;
                                        }
                                        if (deg != 0) {
                                          //сумма/100×%
                                          try {
                                            double dz = ((tr / 100) * deg);
                                            tr = tr - dz.toInt();
                                          } catch (e) {
                                            //
                                            print('err1 $e');
                                          }
                                        }
                                      }
                                      return '$dopStr${dopStr.isNotEmpty ? '\n' : ''}${getStrCard1(item1.value.listOrderRequests[i].idcards!)}, ${dopMoneyString(item1.value.listOrderRequests[i].passengers!)} \nИтого $tr руб';
                                    }
                                  }
                                }
                                return '-';
                              }

                              //--
                              onInitTextController1();
                              await showDialog(
                                context: Get.context!,
                                builder: (context) {
                                  return SimpleDialog(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.antiAlias,
                                    insetPadding: const EdgeInsets.all(5),
                                    title: Text('Заказ № ${item1.value.id}'),
                                    children: [
                                      Obx(
                                        () => SizedBox(
                                          height: Get.height - 60,
                                          width: Get.width - 10,
                                          child: ListView(
                                            children: [
                                              ListTile(
                                                dense: true,
                                                title: Text(
                                                    'Дата и время отпраки по основному маршруту, $time1 ${item1.value.date}'),
                                                subtitle: Text(
                                                    'Дата создание заказа ${DateFormat('dd.MM.yyyy H:m').format(DateTime.fromMillisecondsSinceEpoch(int.parse(item1.value.datetimeCreated!)))}'),
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 120,
                                                    child: TextFieldCustom(
                                                      title: 'Кол-во мест',
                                                      hintText: 'кол-мест',
                                                      controller:
                                                          list['count_mest'],
                                                      inputFormatters: [
                                                        MaskTextInputFormatter(
                                                          mask: "#",
                                                          filter: {
                                                            "#":
                                                                RegExp(r'[0-9]')
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: TextFieldCustom(
                                                      title: '%',
                                                      hintText: '4',
                                                      controller:
                                                          list['degres'],
                                                      inputFormatters: [
                                                        MaskTextInputFormatter(
                                                          mask: "##",
                                                          filter: {
                                                            "#":
                                                                RegExp(r'[0-9]')
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  IconButton(
                                                    color:
                                                        const Color(0xff819fb9),
                                                    onPressed: () async {
                                                      await newPass(
                                                        addpayments1: controller
                                                            .listAddPayment,
                                                        card1: getCardsIDmodel(
                                                            controller
                                                                .listOrders[j]
                                                                .idcards!)!,
                                                        cards1: getCardsName(
                                                            controller
                                                                .listOrders[j]
                                                                .idcards!),
                                                        newObj: controller
                                                            .newOpassager,
                                                        order1: controller
                                                            .listOrders[j],
                                                        time1: controller
                                                            .getTimes(controller
                                                                .listOrders[j]
                                                                .idtimes)!,
                                                        dop: controller.listDOP,
                                                      );

                                                      onupdade1();
                                                    },
                                                    icon: const Icon(
                                                        Icons.person_add),
                                                  ),
                                                  IconButton(
                                                    color:
                                                        const Color(0xff819fb9),
                                                    onPressed: () async {
                                                      onupdade1();
                                                    },
                                                    icon: const Icon(
                                                        Icons.update),
                                                  ),
                                                  IconButton(
                                                    color:
                                                        const Color(0xff819fb9),
                                                    onPressed: () async {
                                                      showDialog(
                                                        context: Get.context!,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            alignment: Alignment
                                                                .bottomCenter,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            title: const Text(
                                                                'Уведомление'),
                                                            content: const Text(
                                                                'Вы действительно хотите удалить запись?'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  bool r = await onRemove(
                                                                      item1
                                                                          .value
                                                                          .id
                                                                          .toString());
                                                                  if (r ==
                                                                      true) {
                                                                    Get.back();
                                                                    Get.back();
                                                                  }
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Да'),
                                                              ),
                                                              TextButton(
                                                                onPressed: () =>
                                                                    Get.back(),
                                                                child:
                                                                    const Text(
                                                                        'Нет'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                        Icons.delete),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  GestureDetector(
                                                    onTap: () => Get.back(),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 20),
                                                      height: 50,
                                                      width: 150,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xff819fb9),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(15),
                                                        ),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          'Отмена',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      int da = 0;
                                                      if (list['degres']
                                                              ?.text
                                                              .length !=
                                                          0) {
                                                        try {
                                                          da = int.parse(
                                                              list['degres']!
                                                                  .text
                                                                  .toString());
                                                        } catch (e) {
                                                          ///
                                                        }
                                                      }
                                                      bool r = await onSave({
                                                        "count_mest":
                                                            list['count_mest']
                                                                ?.text,
                                                        "driver_mobile": list[
                                                                'driver_mobile']
                                                            ?.text,
                                                        "driver_info":
                                                            list['driver_info']
                                                                ?.text,
                                                        "degres": da.toString(),
                                                        "id": item1.value.id
                                                            .toString()
                                                      });
                                                      if (r == true) {
                                                        Get.back();
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 20),
                                                      height: 50,
                                                      width: 150,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xff205CBE),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                          Radius.circular(15),
                                                        ),
                                                      ),
                                                      child: const Center(
                                                        child: Text(
                                                          'Готово',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                ],
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15,
                                                    left: 20,
                                                    right: 20),
                                                child: Container(
                                                  height: .5,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),

                                              const SizedBox(height: 15),
                                              DropList(
                                                list: getDriver1(),
                                                type: 'drop',
                                                title: 'Водитель',
                                                initMail: driver1.value,
                                                onPress: (s) {
                                                  if (s != null) {
                                                    driver1.value = s;
                                                    driver1.refresh();
                                                  }
                                                },
                                              ),

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15,
                                                    left: 20,
                                                    right: 20),
                                                child: Text(
                                                  getInfoIdDriver1() ??
                                                      'Водитель: -',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (getIdDriver1() !=
                                                          null) {
                                                        bool r =
                                                            await onSaveDriver({
                                                          "iddriver":
                                                              getIdDriver1(),
                                                          "idorders":
                                                              item1.value.id,
                                                        });
                                                        if (r == true) {
                                                          onupdade1();
                                                        }
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Назначить водителя',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Color(0xff205CBE),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  TextButton(
                                                    onPressed: () async {
                                                      bool r =
                                                          await onRemoveDriver(
                                                              item1
                                                                  .value
                                                                  .listOrderDrivers
                                                                  .last
                                                                  .id
                                                                  .toString());
                                                      if (r == true) {
                                                        onupdade1();
                                                      }
                                                    },
                                                    child: const Text(
                                                      'Убрать назначение водителя',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Color(0xff205CBE),
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15,
                                                    left: 20,
                                                    right: 20),
                                                child: Container(
                                                  height: .5,
                                                  color: Colors.blueGrey,
                                                ),
                                              ),
                                              //

                                              ExpansionTile(
                                                iconColor:
                                                    const Color(0xff205CBE),
                                                textColor:
                                                    const Color(0xff205CBE),
                                                initiallyExpanded: true,
                                                title: Text(
                                                    'Пассажиры (${item1.value.countPassagers()})'),
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          item1
                                                              .value
                                                              .listOrderRequests
                                                              .length;
                                                      i++)
                                                    ListTile(
                                                      dense: item1
                                                                  .value
                                                                  .listOrderRequests[
                                                                      i]
                                                                  .idstate !=
                                                              2
                                                          ? false
                                                          : true,
                                                      enabled: item1
                                                                  .value
                                                                  .listOrderRequests[
                                                                      i]
                                                                  .idstate !=
                                                              2
                                                          ? true
                                                          : false,
                                                      onTap: () async {
                                                        ModelOrderRequests
                                                            item2 = item1.value
                                                                .listOrderRequests[i];
                                                        String addpayment2 =
                                                            'Не выбрано';
                                                        late List<
                                                                ModelAdditionalPayment>
                                                            addpayments2 =
                                                            addpayments1;
                                                        var list2 = <String,
                                                                TextEditingController>{}
                                                            .obs;

                                                        Future<bool> Function(
                                                                Map<String,
                                                                    dynamic>)
                                                            onSave =
                                                            onSavePassagers;
                                                        List<String>
                                                            getAddPay2() {
                                                          List<String> l = [
                                                            'Не выбрано'
                                                          ];
                                                          for (int i = 0;
                                                              i <
                                                                  addpayments2
                                                                      .length;
                                                              i++) {
                                                            l.add(
                                                                '${addpayments2[i].text} ${addpayments2[i].payment} руб');
                                                          }
                                                          return l;
                                                        }

                                                        String?
                                                            getStrAddPayment2(
                                                                int? id) {
                                                          if (id != null) {
                                                            for (int i = 0;
                                                                i <
                                                                    addpayments2
                                                                        .length;
                                                                i++) {
                                                              if (id ==
                                                                  addpayments2[
                                                                          i]
                                                                      .id) {
                                                                return '${addpayments2[i].text} ${addpayments2[i].payment} руб';
                                                              }
                                                            }
                                                          }
                                                          return null;
                                                        }

                                                        int? getIdAddPay2() {
                                                          for (int i = 0;
                                                              i <
                                                                  addpayments2
                                                                      .length;
                                                              i++) {
                                                            if (addpayment2 ==
                                                                '${addpayments2[i].text} ${addpayments2[i].payment} руб') {
                                                              return addpayments2[
                                                                      i]
                                                                  .id;
                                                            }
                                                          }
                                                          return null;
                                                        }

                                                        onInitTextController2() {
                                                          list2['in_adress'] =
                                                              TextEditingController(
                                                                  text: item2
                                                                      .passengers
                                                                      ?.inAdress);
                                                          list2['out_adress'] =
                                                              TextEditingController(
                                                                  text: item2
                                                                      .passengers
                                                                      ?.outAdress);
                                                          list2['info'] =
                                                              TextEditingController(
                                                                  text: item2
                                                                      .passengers
                                                                      ?.info);
                                                          list2['name'] =
                                                              TextEditingController(
                                                                  text: item2
                                                                      .passengers
                                                                      ?.name);
                                                          list2['mobile'] =
                                                              TextEditingController(
                                                                  text: item2
                                                                      .passengers
                                                                      ?.mobile);
                                                          list2['degres'] =
                                                              TextEditingController(
                                                                  text:
                                                                      '${item2.passengers?.degres}');
                                                          list2['payment'] =
                                                              TextEditingController(
                                                                  text:
                                                                      '${item2.passengers?.payment}');
                                                          addpayment2 =
                                                              getStrAddPayment2(item2
                                                                      .passengers
                                                                      ?.idaddPAyment) ??
                                                                  'Не выбрано';
                                                          list2.refresh();
                                                        }

                                                        onInitTextController2();

                                                        await showDialog(
                                                          context: Get.context!,
                                                          builder: (context) {
                                                            return SimpleDialog(
                                                              insetPadding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              clipBehavior: Clip
                                                                  .antiAlias,
                                                              title: Text(
                                                                  'Заказ ID ${item2.id}, пассажир ID ${item2.passengers?.id}'),
                                                              children: [
                                                                Obx(
                                                                  () =>
                                                                      SizedBox(
                                                                    height:
                                                                        Get.height -
                                                                            150,
                                                                    width:
                                                                        Get.width -
                                                                            10,
                                                                    child:
                                                                        ListView(
                                                                      children: [
                                                                        //

                                                                        //
                                                                        TextFieldCustom(
                                                                          title:
                                                                              'Имя',
                                                                          hintText:
                                                                              'имя пассажира',
                                                                          controller:
                                                                              list2['name'],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: TextFieldCustom(
                                                                                title: 'адрес от',
                                                                                hintText: 'откуда',
                                                                                controller: list2['in_adress'],
                                                                              ),
                                                                            ),
                                                                            Flexible(
                                                                              child: TextFieldCustom(
                                                                                title: 'адрес до',
                                                                                hintText: 'куда',
                                                                                controller: list2['out_adress'],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(
                                                                            left:
                                                                                20,
                                                                            right:
                                                                                20,
                                                                            top:
                                                                                15,
                                                                          ),
                                                                          child:
                                                                              DropList2Check(
                                                                            title:
                                                                                'Доп. опции',
                                                                            listID: [
                                                                              for (int y = 0; y < controller.listDOP.length; y++)
                                                                                controller.listDOP[y].id!
                                                                            ],
                                                                            list: [
                                                                              for (int y = 0; y < controller.listDOP.length; y++)
                                                                                controller.listDOP[y].name!
                                                                            ],
                                                                            m: item2.passengers!.dataFull == null
                                                                                ? null
                                                                                : item2.passengers!.dataFull!,
                                                                            color:
                                                                                const Color(0xffF0F2F0),
                                                                            onChange:
                                                                                (l, m) {
                                                                              print(l);
                                                                              print(m);
                                                                              item2.passengers!.dataFull = m;
                                                                              //list['data_full']!.text = jsonEncode(m);
                                                                              //upd2();
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Flexible(
                                                                              child: TextFieldCustom(
                                                                                title: 'Скидка %',
                                                                                hintText: '10',
                                                                                controller: list2['degres'],
                                                                                inputFormatters: [
                                                                                  MaskTextInputFormatter(
                                                                                    mask: "###",
                                                                                    filter: {
                                                                                      "#": RegExp(r'[0-9]')
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Flexible(
                                                                              child: TextFieldCustom(
                                                                                title: 'Скидка в руб',
                                                                                hintText: '10',
                                                                                controller: list2['payment'],
                                                                                inputFormatters: [
                                                                                  MaskTextInputFormatter(
                                                                                    mask: "######",
                                                                                    filter: {
                                                                                      "#": RegExp(r'[0-9]')
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),

                                                                        TextFieldCustom(
                                                                          title:
                                                                              'Доп. инфо',
                                                                          hintText:
                                                                              'дополнительная информация',
                                                                          controller:
                                                                              list2['info'],
                                                                        ),
                                                                        TextFieldCustom(
                                                                          title:
                                                                              'Мобильный',
                                                                          hintText:
                                                                              '7(999)130-40-53',
                                                                          controller:
                                                                              list2['mobile'],
                                                                          inputFormatters: [
                                                                            MaskTextInputFormatter(
                                                                              mask: '+7(###) ###-##-##',
                                                                              filter: {
                                                                                "#": RegExp(r'[0-9]')
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        DropList(
                                                                          list:
                                                                              getAddPay2(),
                                                                          type:
                                                                              'drop',
                                                                          title:
                                                                              'Район',
                                                                          initMail:
                                                                              addpayment2,
                                                                          onPress:
                                                                              (s) {
                                                                            if (s !=
                                                                                null) {
                                                                              addpayment2 = s;
                                                                            }
                                                                          },
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                15),
                                                                        Row(
                                                                          children: [
                                                                            const Spacer(),
                                                                            GestureDetector(
                                                                              onTap: () => Get.back(),
                                                                              child: Container(
                                                                                padding: const EdgeInsets.only(left: 20, right: 20),
                                                                                height: 50,
                                                                                width: 150,
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
                                                                              onTap: () async {
                                                                                bool r = await onSave({
                                                                                  "degres": list2['degres']?.text.length == 0 ? 0 : list2['degres']!.text,
                                                                                  "payment": list2['payment']?.text.length == 0 ? 0 : list2['payment']!.text,
                                                                                  "in_adress": list2['in_adress']?.text,
                                                                                  "out_adress": list2['out_adress']?.text,
                                                                                  "info": list2['info']?.text,
                                                                                  "data_full": item2.passengers!.dataFull == null ? null : jsonEncode(item2.passengers!.dataFull!),
                                                                                  //"count": list['count']?.text,
                                                                                  "name": list2['name']?.text,
                                                                                  "mobile": list2['mobile']?.text.replaceAll(RegExp(r'[^0-9]'), ""),
                                                                                  "id": item2.idpassengers.toString(),
                                                                                  "additional_payment_idadd_payment":
                                                                                      // ignore: prefer_null_aware_operators
                                                                                      getIdAddPay2() != null ? getIdAddPay2().toString() : null
                                                                                });
                                                                                if (r == true) {
                                                                                  Get.back();
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                padding: const EdgeInsets.only(left: 20, right: 20),
                                                                                height: 50,
                                                                                width: 150,
                                                                                decoration: const BoxDecoration(
                                                                                  color: Color(0xff205CBE),
                                                                                  borderRadius: BorderRadius.all(
                                                                                    Radius.circular(15),
                                                                                  ),
                                                                                ),
                                                                                child: const Center(
                                                                                  child: Text(
                                                                                    'Готово',
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
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                        onupdade1();
                                                        /*
                                                                      await Get.to(
                                                                          () =>
                                                                              ItemPassegerOrder(
                                                                                item.value.listOrderRequests[i],
                                                                                onSave: onSavePassagers,
                                                                                addpayments: addpayments,
                                                                              ));
                                                                      onupdade();
                                                                      */
                                                      },
                                                      leading: item1
                                                                  .value
                                                                  .listOrderRequests[
                                                                      i]
                                                                  .passengers!
                                                                  .idusers !=
                                                              null
                                                          ? const Icon(Icons
                                                              .mobile_friendly)
                                                          : const Icon(Icons
                                                              .window_sharp),
                                                      title: Text(
                                                          '${item1.value.listOrderRequests[i].passengers?.name}, мест ${item1.value.listOrderRequests[i].passengers?.count}'),
                                                      subtitle: Row(
                                                        children: [
                                                          Flexible(
                                                            child: Text(
                                                                '${item1.value.listOrderRequests[i].passengers?.mobile}, от: ${item1.value.listOrderRequests[i].passengers?.inAdress}, до: ${item1.value.listOrderRequests[i].passengers?.outAdress}\n${getCardsMoneyInfo1(item1.value.listOrderRequests[i].id!)}'),
                                                          ),
                                                          IconButton(
                                                            onPressed: () {
                                                              Clipboard.setData(
                                                                  ClipboardData(
                                                                      text:
                                                                          '${item1.value.listOrderRequests[i].passengers?.name}, мест ${item1.value.listOrderRequests[i].passengers?.count}\n${item1.value.listOrderRequests[i].passengers?.mobile}, от: ${item1.value.listOrderRequests[i].passengers?.inAdress}, до: ${item1.value.listOrderRequests[i].passengers?.outAdress}\n${getCardsMoneyInfo1(item1.value.listOrderRequests[i].id!)}'));
                                                            },
                                                            icon: const Icon(
                                                                Icons.copy),
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: IconButton(
                                                        onPressed: () async {
                                                          if (item1
                                                                  .value
                                                                  .listOrderRequests[
                                                                      i]
                                                                  .idstate !=
                                                              2) {
                                                            bool r = await onRemovePassagers(
                                                                item1
                                                                    .value
                                                                    .listOrderRequests[
                                                                        i]
                                                                    .id
                                                                    .toString(),
                                                                2);
                                                            if (r == true) {
                                                              //Get.back();
                                                            }
                                                            onupdade1();
                                                          }
                                                        },
                                                        icon: const Icon(
                                                            Icons.delete),
                                                      ),
                                                    ),
                                                  const SizedBox(height: 25),
                                                ],
                                              ),

                                              ExpansionTile(
                                                iconColor:
                                                    const Color(0xff205CBE),
                                                textColor:
                                                    const Color(0xff205CBE),
                                                initiallyExpanded: true,
                                                title: const Text(
                                                    'Статусы заказа'),
                                                children: [
                                                  for (int i = 0;
                                                      i <
                                                          item1
                                                              .value
                                                              .listOrderDrivers
                                                              .length;
                                                      i++)
                                                    ListTile(
                                                      title: Text(
                                                          'ID водителя ${item1.value.listOrderDrivers[i].iddrivers}'),
                                                      subtitle: Text(
                                                          '"${getInfoStateDriver1(item1.value.listOrderDrivers[i].idstate!)}"'),
                                                    ),
                                                  const SizedBox(height: 25),
                                                ],
                                              ),

                                              const SizedBox(height: 25),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              controller.getData(date.value);
                            },
                            icon: const Icon(Icons.create),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            color: const Color(0xff205CBE),
                            onPressed: () async {
                              await newPass(
                                addpayments1: controller.listAddPayment,
                                card1: getCardsIDmodel(
                                    controller.listOrders[j].idcards!)!,
                                cards1: getCardsName(
                                    controller.listOrders[j].idcards!),
                                newObj: controller.newOpassager,
                                order1: controller.listOrders[j],
                                time1: controller.getTimes(
                                    controller.listOrders[j].idtimes)!,
                                dop: controller.listDOP,
                              );
                              controller.getData(date.value);
                              return;
                            },
                            icon: const Icon(Icons.person_add_alt),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            color: const Color(0xff205CBE),
                            onPressed: () async {
                              showDialog(
                                context: Get.context!,
                                builder: (context) {
                                  return AlertDialog(
                                    alignment: Alignment.bottomCenter,
                                    clipBehavior: Clip.antiAlias,
                                    title: const Text('Уведомление'),
                                    content: const Text(
                                        'Вы действительно хотите удалить запись?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          bool r = await controller.removeO(
                                              controller.listOrders[j].id
                                                  .toString());
                                          if (r == true) {
                                            Get.back();
                                            controller.getData(date.value);
                                          }
                                        },
                                        child: const Text('Да'),
                                      ),
                                      TextButton(
                                        onPressed: () => Get.back(),
                                        child: const Text('Нет'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.delete_outlined),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                    ],
                  ),
          ]),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Заказы',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.getData(date.value);
            },
            color: const Color(0xff819fb9),
            icon: const Icon(Icons.update),
          ),
        ],
      ),
      body: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  child: Container(
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xffF7F8FA),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            //
                            if (filter.value == 1) {
                              filter.value = 0;
                              filterOneSend(false);
                            } else {
                              filter.value = 1;
                              filterOneSend(true);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            height: 50,
                            decoration: BoxDecoration(
                              color: filter.value == 1
                                  ? const Color(0xff819fb9)
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Свободными местами',
                                    style: TextStyle(
                                      color: filter.value == 1
                                          ? Colors.white
                                          : const Color(0xff819FB9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            //
                            if (filter.value == 2) {
                              filter.value = 0;
                              filterTwoSend(false);
                            } else {
                              filter.value = 2;
                              filterTwoSend(true);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            height: 50,
                            decoration: BoxDecoration(
                              color: filter.value == 2
                                  ? const Color(0xff819fb9)
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Где нет мест',
                                    style: TextStyle(
                                      color: filter.value == 2
                                          ? Colors.white
                                          : const Color(0xff819FB9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            //
                            if (filter.value == 3) {
                              filter.value = 0;
                              filterFreeSend(false);
                            } else {
                              filter.value = 3;
                              filterFreeSend(true);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            height: 50,
                            decoration: BoxDecoration(
                              color: filter.value == 3
                                  ? const Color(0xff819fb9)
                                  : Colors.transparent,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  Text(
                                    'Свободные только с пассажирами',
                                    style: TextStyle(
                                      color: filter.value == 3
                                          ? Colors.white
                                          : const Color(0xff819FB9),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {
                    List<ModelTimes> listTimes = controller.listTimes;
                    var date1 = getDate2()[0]
                        .obs; // = DateFormat('dd-MM-yyyy').format(DateTime.now());

                    var cards1 = ''.obs;
                    var full = false.obs;
                    var lTimes =
                        [for (int d = 0; d < listTimes.length; d++) false].obs;
                    Map<String, TextEditingController> list = {};
                    list['count_day'] = TextEditingController(text: "0");
                    list['degres'] = TextEditingController(text: "4");
                    list['count_mest'] = TextEditingController(text: "4");
                    Future<bool> Function(Map<String, dynamic>) newObj =
                        controller.newO;

                    await showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return SimpleDialog(
                          alignment: Alignment.center,
                          clipBehavior: Clip.antiAlias,
                          title: const Text('Добавить рейсы'),
                          children: [
                            Obx(
                              () => SizedBox(
                                height: 600,
                                width: 550,
                                child: ListView(
                                  children: [
                                    Row(
                                      children: [
                                        Flexible(
                                          child: DropList(
                                            list: getCardsIn(),
                                            type: 'drop',
                                            title: 'Маршрут',
                                            initMail: cards1.value,
                                            onPress: (s) {
                                              if (s != null) {
                                                // ignore: avoid_print
                                                print(s);
                                                cards1.value = s;
                                                cards1.refresh();
                                              }
                                            },
                                          ),
                                        ),
                                        Flexible(
                                          child: DropList(
                                            list: getDate2(),
                                            type: 'drop',
                                            title: 'Дата',
                                            initMail: date1.value,
                                            onPress: (s) {
                                              if (s != null) {
                                                date1.value = s;
                                                date1.refresh();
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 250,
                                          child: TextFieldCustom(
                                            title: 'На сколько дней вперед?',
                                            hintText: '1',
                                            controller: list['count_day'],
                                            inputFormatters: [
                                              MaskTextInputFormatter(
                                                mask: "##",
                                                filter: {"#": RegExp(r'[0-9]')},
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          child: TextFieldCustom(
                                            title: 'Кол-мест',
                                            hintText: 'кол-мест',
                                            controller: list['count_mest'],
                                            inputFormatters: [
                                              MaskTextInputFormatter(
                                                mask: "#",
                                                filter: {"#": RegExp(r'[0-9]')},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: TextFieldCustom(
                                            title: '%',
                                            hintText: '4',
                                            controller: list['degres'],
                                            inputFormatters: [
                                              MaskTextInputFormatter(
                                                mask: "##",
                                                filter: {"#": RegExp(r'[0-9]')},
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    SwitchListTile(
                                      title: const Text(
                                          'Создать рейсы по всему расписанию'),
                                      value: full.value,
                                      onChanged: (v) {
                                        full.value = v;
                                        full.refresh();
                                        for (int s = 0;
                                            s < lTimes.length;
                                            s++) {
                                          if (v == true) {
                                            lTimes[s] = true;
                                          } else {
                                            lTimes[s] = false;
                                          }
                                        }
                                      },
                                    ),
                                    for (int j = 0;
                                        j < listTimes.length;
                                        j += 2)
                                      Row(
                                        children: [
                                          Flexible(
                                            child: SwitchListTile(
                                              title: Text(
                                                  '${controller.getTimes(controller.listTimes[j].id)}'),
                                              value: lTimes[j],
                                              onChanged: (v) {
                                                lTimes[j] = v;
                                                lTimes.refresh();
                                              },
                                            ),
                                          ),
                                          if ((j + 1) < listTimes.length)
                                            Flexible(
                                              child: SwitchListTile(
                                                title: Text(
                                                    '${controller.getTimes(controller.listTimes[j + 1].id)}'),
                                                value: lTimes[j + 1],
                                                onChanged: (v) {
                                                  lTimes[j + 1] = v;
                                                  lTimes.refresh();
                                                },
                                              ),
                                            ),
                                        ],
                                      ),
                                    SizedBox(
                                      height: 150,
                                      child: Row(
                                        children: [
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () => Get.back(),
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
                                            onTap: () async {
                                              //
                                              if (date1.value == '') {
                                                AppConfig.showDialogMessage(
                                                    title: 'Уведомление',
                                                    content:
                                                        'Вы не выбрали дату');
                                                return;
                                              }
                                              if (cards1.value ==
                                                      'Не выбрано' ||
                                                  cards1.value == '') {
                                                AppConfig.showDialogMessage(
                                                    title: 'Уведомление',
                                                    content:
                                                        'Вы не выбрали маршрут');
                                                return;
                                              }
                                              int c1 = 1;
                                              try {
                                                c1 = int.parse(
                                                    list['count_day']!.text);
                                                c1++;
                                              } catch (e) {
                                                print(e);
                                                AppConfig.showDialogMessage(
                                                    title: 'Уведомление',
                                                    content:
                                                        'Вы указали не верное кол-во дней');
                                                return;
                                              }

                                              for (int e = 0; e < c1; e++) {
                                                var formatter =
                                                    DateFormat('yyyy-MM-dd');

                                                var d =
                                                    DateTime.parse(date1.value);
                                                d = d.add(Duration(days: e));
                                                print(formatter.format(d));
                                                for (int r = 0;
                                                    r < listTimes.length;
                                                    r++) {
                                                  if (lTimes[r] == true) {
                                                    //
                                                    int? idcardSearch =
                                                        getCardsID(
                                                            cards1.value);
                                                    if (idcardSearch != null) {
                                                      int da = 0;
                                                      if (list['degres']
                                                              ?.text
                                                              .length !=
                                                          0) {
                                                        try {
                                                          da = int.parse(
                                                              list['degres']!
                                                                  .text
                                                                  .toString());
                                                        } catch (e) {
                                                          ///
                                                        }
                                                      }
                                                      await newObj({
                                                        "count_mest":
                                                            list['count_mest']
                                                                ?.text,
                                                        "date":
                                                            formatter.format(d),
                                                        "times_idtimes":
                                                            listTimes[r].id,
                                                        "cards_idcards":
                                                            idcardSearch,
                                                        "degres": da,
                                                      });
                                                    }
                                                  }
                                                }
                                              }
                                              Get.back();
                                              controller.getData(date.value);
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
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    controller.getData(date.value);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xff819fb9),
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    child: const Center(
                      child: Row(
                        children: [
                          Icon(Icons.add_circle_outline, color: Colors.white),
                          SizedBox(width: 20),
                          Text(
                            'Добавить рейсы',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 10),
            /*SizedBox(
              child: Table(
                /*
                0: IntrinsicColumnWidth(), min 
                1: FlexColumnWidth(), max
                2: FixedColumnWidth(64),
                */
                columnWidths: const {
                  0: FixedColumnWidth(30),
                  1: FlexColumnWidth(),
                  2: FlexColumnWidth(),
                  3: FlexColumnWidth(),
                  4: FlexColumnWidth(),
                  5: FlexColumnWidth(),
                  6: FlexColumnWidth(),
                  7: FlexColumnWidth(),
                  8: IntrinsicColumnWidth(),
                  /*
                  1: FixedColumnWidth(220), //FlexColumnWidth(),
                  2: FixedColumnWidth(140), //FlexColumnWidth(),
                  3: FixedColumnWidth(120), //FlexColumnWidth(),
                  4: FixedColumnWidth(200), //FlexColumnWidth(),
                  5: FixedColumnWidth(100), //FlexColumnWidth(),
                  6: FixedColumnWidth(120), //FlexColumnWidth(),
                  7: FixedColumnWidth(100), //FlexColumnWidth(),
                  8: FixedColumnWidth(250) //IntrinsicColumnWidth(),
                  */
                },
                children: [
                  TableRow(
                    children: [
                      const SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            '№',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff80A0B9),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Маршрут\n($cards)',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xff80A0B9),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                //getCardsIn
                                await showDialog(
                                  context: Get.context!,
                                  builder: (context) {
                                    return SimpleDialog(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.antiAlias,
                                      title: const Text('Маршрут'),
                                      children: [
                                        SizedBox(
                                          height: 550,
                                          width: 300,
                                          child: ListView(
                                            children: [
                                              for (int k = 0;
                                                  k < getCardsIn().length;
                                                  k++)
                                                ListTile(
                                                  title: Text(getCardsIn()[k]),
                                                  onTap: () {
                                                    cards.value =
                                                        getCardsIn()[k];
                                                    cards.refresh();

                                                    Get.back();
                                                  },
                                                ),
                                              SizedBox(
                                                height: 100,
                                                child: Row(
                                                  children: [
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () => Get.back(),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                right: 20),
                                                        height: 50,
                                                        width: 200,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xff819fb9),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(15),
                                                          ),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Отмена',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.filter_alt_rounded,
                                color: Color(0xff80A0B9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Дата\n(${date.value})',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xff80A0B9),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: Get.context!,
                                  builder: (context) {
                                    return SimpleDialog(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.antiAlias,
                                      title: const Text('Дата'),
                                      children: [
                                        SizedBox(
                                          height: 550,
                                          width: 300,
                                          child: ListView(
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 200,
                                                    child: TextFieldCustom(
                                                      controller: cDate,
                                                      title: 'Дата',
                                                      hintText: '2023-01-29',
                                                      inputFormatters: [
                                                        MaskTextInputFormatter(
                                                          mask: '####-##-##',
                                                          filter: {
                                                            "#":
                                                                RegExp(r'[0-9]')
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: IconButton(
                                                      onPressed: () {
                                                        date.value = cDate.text;
                                                        date.refresh();
                                                        Get.back();
                                                        controller.getData(
                                                            date.value);
                                                      },
                                                      icon: const Icon(
                                                          Icons.check_circle),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              for (int k = 0;
                                                  k < getDate().length;
                                                  k++)
                                                ListTile(
                                                  title: Text(getDate()[k]),
                                                  onTap: () {
                                                    date.value = getDate()[k];
                                                    date.refresh();
                                                    controller
                                                        .getData(date.value);
                                                    Get.back();
                                                  },
                                                ),
                                              SizedBox(
                                                height: 100,
                                                child: Row(
                                                  children: [
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () => Get.back(),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                right: 20),
                                                        height: 50,
                                                        width: 200,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xff819fb9),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(15),
                                                          ),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Отмена',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.filter_alt_rounded,
                                color: Color(0xff80A0B9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Время',
                              style: TextStyle(
                                color: Color(0xff80A0B9),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                //
                              },
                              icon: const Icon(
                                Icons.filter_alt_rounded,
                                color: Color(0xff80A0B9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Водитель',
                            style: TextStyle(
                              color: Color(0xff80A0B9),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Занято мест',
                            style: TextStyle(
                              color: Color(0xff80A0B9),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(
                            'Заказ',
                            style: TextStyle(
                              color: Color(0xff80A0B9),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Сумма\n($degress %)',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xff80A0B9),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: Get.context!,
                                  builder: (context) {
                                    return SimpleDialog(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.antiAlias,
                                      title: const Text('Процент'),
                                      children: [
                                        SizedBox(
                                          height: 550,
                                          width: 300,
                                          child: ListView(
                                            children: [
                                              for (int k = 0;
                                                  k < listDegress().length;
                                                  k++)
                                                ListTile(
                                                  title: Text(
                                                      '${listDegress()[k]} %'),
                                                  onTap: () {
                                                    degress.value =
                                                        listDegress()[k];
                                                    degress.refresh();

                                                    Get.back();
                                                  },
                                                ),
                                              SizedBox(
                                                height: 100,
                                                child: Row(
                                                  children: [
                                                    const Spacer(),
                                                    GestureDetector(
                                                      onTap: () => Get.back(),
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                right: 20),
                                                        height: 50,
                                                        width: 200,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xff819fb9),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(15),
                                                          ),
                                                        ),
                                                        child: const Center(
                                                          child: Text(
                                                            'Отмена',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Spacer(),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.filter_alt_rounded,
                                color: Color(0xff80A0B9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Статус',
                              style: TextStyle(
                                color: Color(0xff80A0B9),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                //
                              },
                              icon: const Icon(
                                Icons.filter_alt_rounded,
                                color: Color(0xff80A0B9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),*/
            Flexible(
              child: ListView(
                children: [
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(35),
                      1: IntrinsicColumnWidth(),
                      2: IntrinsicColumnWidth(),
                      3: FlexColumnWidth(),
                      4: FlexColumnWidth(),
                      5: FlexColumnWidth(),
                      6: FlexColumnWidth(),
                      7: FlexColumnWidth(),
                      8: IntrinsicColumnWidth(),
                      /*
                      0: FixedColumnWidth(30),
                      1: FixedColumnWidth(220), //FlexColumnWidth(),
                      2: FixedColumnWidth(140), //FlexColumnWidth(),
                      3: FixedColumnWidth(120), //FlexColumnWidth(),
                      4: FixedColumnWidth(200), //FlexColumnWidth(),
                      5: FixedColumnWidth(100), //FlexColumnWidth(),
                      6: FixedColumnWidth(120), //FlexColumnWidth(),
                      7: FixedColumnWidth(100), //FlexColumnWidth(),
                      8: FixedColumnWidth(250) //IntrinsicColumnWidth(),*/
                    },
                    children: [
                      TableRow(
                        children: [
                          const SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                '№',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xff80A0B9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Маршрут\n($cards)',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff80A0B9),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    //getCardsIn
                                    await showDialog(
                                      context: Get.context!,
                                      builder: (context) {
                                        return SimpleDialog(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.antiAlias,
                                          title: const Text('Маршрут'),
                                          children: [
                                            SizedBox(
                                              height: 550,
                                              width: 300,
                                              child: ListView(
                                                children: [
                                                  for (int k = 0;
                                                      k < getCardsIn().length;
                                                      k++)
                                                    ListTile(
                                                      title:
                                                          Text(getCardsIn()[k]),
                                                      onTap: () {
                                                        cards.value =
                                                            getCardsIn()[k];
                                                        cards.refresh();

                                                        Get.back();
                                                      },
                                                    ),
                                                  SizedBox(
                                                    height: 100,
                                                    child: Row(
                                                      children: [
                                                        const Spacer(),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              Get.back(),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    right: 20),
                                                            height: 50,
                                                            width: 200,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xff819fb9),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    15),
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                'Отмена',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_rounded,
                                    color: Color(0xff80A0B9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Дата\n(${date.value})',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff80A0B9),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: Get.context!,
                                      builder: (context) {
                                        return SimpleDialog(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.antiAlias,
                                          title: const Text('Дата'),
                                          children: [
                                            SizedBox(
                                              height: 550,
                                              width: 300,
                                              child: ListView(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 200,
                                                        child: TextFieldCustom(
                                                          controller: cDate,
                                                          title: 'Дата',
                                                          hintText:
                                                              '2023-01-29',
                                                          inputFormatters: [
                                                            MaskTextInputFormatter(
                                                              mask:
                                                                  '####-##-##',
                                                              filter: {
                                                                "#": RegExp(
                                                                    r'[0-9]')
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: IconButton(
                                                          onPressed: () {
                                                            date.value =
                                                                cDate.text;
                                                            date.refresh();
                                                            Get.back();
                                                            controller.getData(
                                                                date.value);
                                                          },
                                                          icon: const Icon(Icons
                                                              .check_circle),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  for (int k = 0;
                                                      k < getDate().length;
                                                      k++)
                                                    ListTile(
                                                      title: Text(getDate()[k]),
                                                      onTap: () {
                                                        date.value =
                                                            getDate()[k];
                                                        date.refresh();
                                                        controller.getData(
                                                            date.value);
                                                        Get.back();
                                                      },
                                                    ),
                                                  SizedBox(
                                                    height: 100,
                                                    child: Row(
                                                      children: [
                                                        const Spacer(),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              Get.back(),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    right: 20),
                                                            height: 50,
                                                            width: 200,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xff819fb9),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    15),
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                'Отмена',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_rounded,
                                    color: Color(0xff80A0B9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Время',
                                  style: TextStyle(
                                    color: Color(0xff80A0B9),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    //
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_rounded,
                                    color: Color(0xff80A0B9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'Водитель',
                                style: TextStyle(
                                  color: Color(0xff80A0B9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'Занято мест',
                                style: TextStyle(
                                  color: Color(0xff80A0B9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                            child: Center(
                              child: Text(
                                'Заказ',
                                style: TextStyle(
                                  color: Color(0xff80A0B9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Сумма\n($degress %)',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xff80A0B9),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await showDialog(
                                      context: Get.context!,
                                      builder: (context) {
                                        return SimpleDialog(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.antiAlias,
                                          title: const Text('Процент'),
                                          children: [
                                            SizedBox(
                                              height: 550,
                                              width: 300,
                                              child: ListView(
                                                children: [
                                                  for (int k = 0;
                                                      k < listDegress().length;
                                                      k++)
                                                    ListTile(
                                                      title: Text(
                                                          '${listDegress()[k]} %'),
                                                      onTap: () {
                                                        degress.value =
                                                            listDegress()[k];
                                                        degress.refresh();

                                                        Get.back();
                                                      },
                                                    ),
                                                  SizedBox(
                                                    height: 100,
                                                    child: Row(
                                                      children: [
                                                        const Spacer(),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              Get.back(),
                                                          child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 20,
                                                                    right: 20),
                                                            height: 50,
                                                            width: 200,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color: Color(
                                                                  0xff819fb9),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                                Radius.circular(
                                                                    15),
                                                              ),
                                                            ),
                                                            child: const Center(
                                                              child: Text(
                                                                'Отмена',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_rounded,
                                    color: Color(0xff80A0B9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Статус',
                                  style: TextStyle(
                                    color: Color(0xff80A0B9),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    //
                                  },
                                  icon: const Icon(
                                    Icons.filter_alt_rounded,
                                    color: Color(0xff80A0B9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      for (int j = 0; j < controller.listOrders.length; j++)
                        if (cards.value ==
                                getCardsSTR(
                                    controller.listOrders[j].idcards!) ||
                            cards.value == 'Не выбрано')
                          if (filterCount(j) == true)
                            TableRow(
                              children: [
                                SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Text(
                                    '${controller.listOrders[j].id}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393939),
                                    ),
                                  ),
                                ),
                                Text(
                                  '${getCardsName(controller.listOrders[j].idcards!)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393939),
                                  ),
                                ),
                                Text(
                                  '${controller.listOrders[j].date}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393939),
                                  ),
                                ),
                                Text(
                                  '${controller.getTimes(controller.listOrders[j].idtimes!)}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff205CBE),
                                  ),
                                ),
                                Text(
                                  '${controller.getInfoDriver(controller.listOrders[j])}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393939),
                                  ),
                                ),
                                Text(
                                  '${controller.listOrders[j].countPassagers()} / ${controller.listOrders[j].countMest}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393939),
                                  ),
                                ),
                                Text(
                                  controller.getStateAppClient(
                                              controller.listOrders[j]) ==
                                          true
                                      ? "C приложения"
                                      : "-",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393939),
                                  ),
                                ),
                                Text(
                                  '${controller.getMoneyOrder(controller.listOrders[j])} р\n${getSummDegress(controller.listOrders[j])} р (%)',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393939),
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 15),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color:
                                                controller.getStateOrderColor(
                                                    controller.listOrders[j]),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(15)),
                                          ),
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            controller.getStateOrder(
                                                controller.listOrders[j]),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: controller
                                                  .getStateOrderColorText(
                                                      controller.listOrders[j]),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    //const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        AppConfig.sendDriverNotif(
                                            controller.listOrders[j].id!);
                                      },
                                      color: const Color(0xff205CBE),
                                      icon: const Icon(Icons.send),
                                    ),
                                    IconButton(
                                      color: const Color(0xff205CBE),
                                      onPressed: () async {
                                        //--
                                        var item1 = ModelOrders().obs;
                                        item1.value = controller.listOrders[j];
                                        var driver1 = ''.obs;
                                        String? time1 = controller.getTimes(
                                            controller.listOrders[j].idtimes);
                                        late List<ModelAdditionalPayment>
                                            addpayments1 =
                                            controller.listAddPayment;
                                        var list =
                                            <String, TextEditingController>{}
                                                .obs;

                                        List<ModelDrivers> listDrivers1 =
                                            controller.listDrivers;
                                        List<ModelCards> cards1 =
                                            controller.listCards;
                                        Future<ModelOrders?> Function(
                                                String? idhash) onUpdate =
                                            controller.getIdhashData;
                                        Future<bool> Function(
                                                Map<String, dynamic>) onSave =
                                            controller.updateO;
                                        Future<bool> Function(
                                                Map<String, dynamic>)
                                            onSavePassagers =
                                            controller.updateOpassager;
                                        Future<bool> Function(String? idhash)
                                            onRemove = controller.removeO;
                                        Future<bool> Function(
                                                String? idhash, int state)
                                            onRemovePassagers =
                                            controller.removeOpassager;

                                        Future<bool> Function(
                                                Map<String, dynamic>)
                                            onSaveDriver =
                                            controller.newODriver;
                                        Future<bool> Function(String? idhash)
                                            onRemoveDriver =
                                            controller.removeODriver;

                                        //--
                                        String? getInitIdDriver1() {
                                          driver1.value = '';
                                          driver1.refresh();
                                          int? id;
                                          if (item1.value.listOrderDrivers
                                              .isNotEmpty) {
                                            if (item1.value.listOrderDrivers
                                                    .last.idstate !=
                                                2) {
                                              id = item1.value.listOrderDrivers
                                                  .last.iddrivers;
                                            }
                                          }
                                          //print('id $id');

                                          if (id != null) {
                                            for (int i = 0;
                                                i < listDrivers1.length;
                                                i++) {
                                              if (id == listDrivers1[i].id) {
                                                String r =
                                                    'ID ${listDrivers1[i].id} ${listDrivers1[i].name}, ${listDrivers1[i].mobile}';
                                                driver1.value = r;
                                                driver1.refresh();
                                                //print (r);
                                                return r;
                                              }
                                            }
                                          }
                                          return null;
                                        }

                                        onInitTextController1() {
                                          getInitIdDriver1();
                                          list['count_mest'] =
                                              TextEditingController(
                                                  text: item1.value.countMest
                                                      .toString());
                                          list['driver_mobile'] =
                                              TextEditingController(
                                                  text:
                                                      item1.value.driverMobile);
                                          list['driver_info'] =
                                              TextEditingController(
                                                  text: item1.value.driverInfo);

                                          list['degres'] =
                                              TextEditingController(
                                                  text: item1.value.degres
                                                      .toString());
                                          //
                                          list.refresh();
                                        }

                                        onupdade1() async {
                                          ModelOrders? o = await onUpdate(
                                              item1.value.id.toString());
                                          if (o != null) {
                                            item1.value = o;
                                            item1.refresh();
                                          }
                                          onInitTextController1();
                                        }

                                        String getInfoStateDriver1(int id) {
                                          switch (id) {
                                            case 1:
                                              return 'Заказ принял';
                                            case 2:
                                              return 'Назначение водителя отмененно';
                                            case 3:
                                              return 'В работе';

                                            case 4:
                                              return 'Завершен';

                                            default:
                                              return 'Неизвестен';
                                          }
                                        }

                                        List<String> getDriver1() {
                                          List<String> l = ['Не выбрано'];
                                          for (int i = 0;
                                              i < listDrivers1.length;
                                              i++) {
                                            if (listDrivers1[i].idstate == 1) {
                                              l.add(
                                                  'ID ${listDrivers1[i].id} ${listDrivers1[i].name}, ${listDrivers1[i].mobile}');
                                            }
                                          }
                                          return l;
                                        }

                                        String? getInfoIdDriver1() {
                                          int? id;
                                          if (item1.value.listOrderDrivers
                                              .isNotEmpty) {
                                            if (item1.value.listOrderDrivers
                                                    .last.idstate !=
                                                2) {
                                              id = item1.value.listOrderDrivers
                                                  .last.iddrivers;
                                            }
                                          }
                                          //print('id $id');

                                          if (id != null) {
                                            for (int i = 0;
                                                i < listDrivers1.length;
                                                i++) {
                                              if (id == listDrivers1[i].id) {
                                                String r =
                                                    'ID ${listDrivers1[i].id} ${listDrivers1[i].name}, ${listDrivers1[i].mobile}\nМашина ${listDrivers1[i].markaModel} ${listDrivers1[i].color} ${listDrivers1[i].number}, мест: ${listDrivers1[i].count}';
                                                //print (r);
                                                return r;
                                              }
                                            }
                                          }
                                          return null;
                                        }

                                        int? getIdDriver1() {
                                          for (int i = 0;
                                              i < listDrivers1.length;
                                              i++) {
                                            if (driver1.value ==
                                                'ID ${listDrivers1[i].id} ${listDrivers1[i].name}, ${listDrivers1[i].mobile}') {
                                              return listDrivers1[i].id;
                                            }
                                          }
                                          return null;
                                        }

                                        String getStrCardInter1(
                                            int idcard, int id) {
                                          for (int i = 0;
                                              i < cards1.length;
                                              i++) {
                                            if (idcard == cards1[i].id) {
                                              for (int j = 0;
                                                  j <
                                                      cards1[i]
                                                          .lisIntertCards
                                                          .length;
                                                  j++) {
                                                if (id ==
                                                    cards1[i]
                                                        .lisIntertCards[j]
                                                        .id) {
                                                  return 'ожидание ${cards1[i].lisIntertCards[j].countMinute} минут, ${cards1[i].lisIntertCards[j].inMap}-${cards1[i].lisIntertCards[j].outMap}, ${cards1[i].lisIntertCards[j].payment} руб';
                                                }
                                              }
                                            }
                                          }
                                          return '-';
                                        }

                                        String getStrCard1(int id) {
                                          for (int i = 0;
                                              i < cards1.length;
                                              i++) {
                                            if (id == cards1[i].id) {
                                              return '${cards1[i].inMap}-${cards1[i].outMap}, ${cards1[i].payment} руб';
                                            }
                                          }
                                          return '-';
                                        }

                                        int getCardInterMoney1(
                                            int idcard, int id) {
                                          for (int i = 0;
                                              i < cards1.length;
                                              i++) {
                                            if (idcard == cards1[i].id) {
                                              for (int j = 0;
                                                  j <
                                                      cards1[i]
                                                          .lisIntertCards
                                                          .length;
                                                  j++) {
                                                if (id ==
                                                    cards1[i]
                                                        .lisIntertCards[j]
                                                        .id) {
                                                  return cards1[i]
                                                          .lisIntertCards[j]
                                                          .payment ??
                                                      0;
                                                }
                                              }
                                            }
                                          }
                                          return 0;
                                        }

                                        int getCardMoney1(int id) {
                                          for (int i = 0;
                                              i < cards1.length;
                                              i++) {
                                            if (id == cards1[i].id) {
                                              return cards1[i].payment ?? 0;
                                            }
                                          }
                                          return 0;
                                        }

                                        int getAddPayMoney1(int id) {
                                          for (int i = 0;
                                              i < addpayments1.length;
                                              i++) {
                                            if (id == addpayments1[i].id) {
                                              return addpayments1[i].payment ??
                                                  0;
                                            }
                                          }
                                          return 0;
                                        }

                                        String getAddPayStr1(int id) {
                                          for (int i = 0;
                                              i < addpayments1.length;
                                              i++) {
                                            if (id == addpayments1[i].id) {
                                              return '${addpayments1[i].text} +${addpayments1[i].payment} руб';
                                            }
                                          }
                                          return '';
                                        }

                                        //fffffff
                                        int dopMoney(ModelPassengers objP) {
                                          int r = 0;
                                          var json;
                                          if (objP.dataFull == null) {
                                            return 0;
                                          }
                                          try {
                                            json = jsonDecode(objP.dataFull);
                                            print(objP.dataFull);
                                          } catch (e) {
                                            print('err json dop, $e');
                                            return 0;
                                          }
                                          try {
                                            for (int d = 0;
                                                d < controller.listDOP.length;
                                                d++) {
                                              if (json[controller
                                                      .listDOP[d].name] !=
                                                  null) {
                                                if (controller.listDOP[d].id ==
                                                    json[controller.listDOP[d]
                                                        .name]['id']) {
                                                  if (json[controller.listDOP[d]
                                                          .name]['enable'] ==
                                                      true) {
                                                    r += controller
                                                        .listDOP[d].payment!;
                                                    print(r);
                                                  }
                                                }
                                              }
                                            }
                                          } catch (e) {
                                            print('err fi, $e');
                                          }
                                          return r;
                                        }

                                        //fffffff
                                        String dopMoneyString(
                                            ModelPassengers objP) {
                                          String r = 'Доп. опции: ';
                                          var json;
                                          if (objP.dataFull == null) {
                                            return r;
                                          }
                                          try {
                                            json = jsonDecode(objP.dataFull);
                                          } catch (e) {
                                            print('err json dop');
                                          }
                                          try {
                                            for (int d = 0;
                                                d < controller.listDOP.length;
                                                d++) {
                                              if (json[controller
                                                      .listDOP[d].name] !=
                                                  null) {
                                                if (controller.listDOP[d].id ==
                                                    json[controller.listDOP[d]
                                                        .name]['id']) {
                                                  if (json[controller.listDOP[d]
                                                          .name]['enable'] ==
                                                      true) {
                                                    r += controller
                                                            .listDOP[d].name! +
                                                        ', ';
                                                    print(r);
                                                  }
                                                }
                                              }
                                            }
                                          } catch (e) {
                                            print('eer json, $e');
                                          }
                                          return r;
                                        }

                                        //ffffffffffffffffff
                                        String getCardsMoneyInfo1(int id) {
                                          for (int i = 0;
                                              i <
                                                  item1.value.listOrderRequests
                                                      .length;
                                              i++) {
                                            if (item1.value.listOrderRequests[i]
                                                    .id ==
                                                id) {
                                              int dop = 0;
                                              String dopStr = '';
                                              if (item1
                                                      .value
                                                      .listOrderRequests[i]
                                                      .passengers!
                                                      .idaddPAyment !=
                                                  null) {
                                                dop = getAddPayMoney1(item1
                                                    .value
                                                    .listOrderRequests[i]
                                                    .passengers!
                                                    .idaddPAyment!);
                                                dopStr = getAddPayStr1(item1
                                                    .value
                                                    .listOrderRequests[i]
                                                    .passengers!
                                                    .idaddPAyment!);
                                              }
                                              if (item1
                                                      .value
                                                      .listOrderRequests[i]
                                                      .idintermediateCards !=
                                                  null) {
                                                //item.value.listOrderRequests[i].idintermediateCards
                                                int tr = ((getCardInterMoney1(
                                                            item1
                                                                .value
                                                                .listOrderRequests[
                                                                    i]
                                                                .idcards!,
                                                            item1
                                                                .value
                                                                .listOrderRequests[
                                                                    i]
                                                                .idintermediateCards!) *
                                                        item1
                                                            .value
                                                            .listOrderRequests[
                                                                i]
                                                            .passengers!
                                                            .count!) +
                                                    (dop *
                                                        item1
                                                            .value
                                                            .listOrderRequests[
                                                                i]
                                                            .passengers!
                                                            .count!));
                                                tr += dopMoney(item1
                                                    .value
                                                    .listOrderRequests[i]
                                                    .passengers!);
                                                {
                                                  int deg = 0, pay = 0;
                                                  if (item1
                                                          .value
                                                          .listOrderRequests[i]
                                                          .passengers!
                                                          .degres !=
                                                      0) {
                                                    try {
                                                      deg = item1
                                                          .value
                                                          .listOrderRequests[i]
                                                          .passengers!
                                                          .degres!;
                                                    } catch (e) {
                                                      //
                                                    }
                                                  }
                                                  if (item1
                                                          .value
                                                          .listOrderRequests[i]
                                                          .passengers!
                                                          .payment !=
                                                      0) {
                                                    try {
                                                      pay = item1
                                                          .value
                                                          .listOrderRequests[i]
                                                          .passengers!
                                                          .payment!;
                                                    } catch (e) {
                                                      //
                                                      print('err2');
                                                    }
                                                  }

                                                  if (pay != 0) {
                                                    tr = tr - pay;
                                                  }
                                                  if (deg != 0) {
                                                    //сумма/100×%
                                                    try {
                                                      double dz =
                                                          ((tr / 100) * deg);
                                                      tr = tr - dz.toInt();
                                                    } catch (e) {
                                                      //
                                                      print('err1');
                                                    }
                                                  }
                                                }

                                                return '$dopStr${dopStr.isNotEmpty ? '\n' : ''}${getStrCardInter1(item1.value.listOrderRequests[i].idcards!, item1.value.listOrderRequests[i].idintermediateCards!)}, ${dopMoneyString(item1.value.listOrderRequests[i].passengers!)} \nИтого $tr руб';
                                              } else {
                                                //item.value.listOrderRequests[i].idcards
                                                int tr = ((getCardMoney1(item1
                                                            .value
                                                            .listOrderRequests[
                                                                i]
                                                            .idcards!) *
                                                        item1
                                                            .value
                                                            .listOrderRequests[
                                                                i]
                                                            .passengers!
                                                            .count!) +
                                                    (dop *
                                                        item1
                                                            .value
                                                            .listOrderRequests[
                                                                i]
                                                            .passengers!
                                                            .count!));
                                                tr += dopMoney(item1
                                                    .value
                                                    .listOrderRequests[i]
                                                    .passengers!);
                                                {
                                                  int deg = 0, pay = 0;
                                                  if (item1
                                                          .value
                                                          .listOrderRequests[i]
                                                          .passengers!
                                                          .degres !=
                                                      0) {
                                                    try {
                                                      deg = item1
                                                          .value
                                                          .listOrderRequests[i]
                                                          .passengers!
                                                          .degres!;
                                                    } catch (e) {
                                                      //
                                                    }
                                                  }
                                                  if (item1
                                                          .value
                                                          .listOrderRequests[i]
                                                          .passengers!
                                                          .payment !=
                                                      0) {
                                                    try {
                                                      pay = item1
                                                          .value
                                                          .listOrderRequests[i]
                                                          .passengers!
                                                          .payment!;
                                                    } catch (e) {
                                                      //
                                                      print('err2');
                                                    }
                                                  }

                                                  if (pay != 0) {
                                                    tr = tr - pay;
                                                  }
                                                  if (deg != 0) {
                                                    //сумма/100×%
                                                    try {
                                                      double dz =
                                                          ((tr / 100) * deg);
                                                      tr = tr - dz.toInt();
                                                    } catch (e) {
                                                      //
                                                      print('err1 $e');
                                                    }
                                                  }
                                                }
                                                return '$dopStr${dopStr.isNotEmpty ? '\n' : ''}${getStrCard1(item1.value.listOrderRequests[i].idcards!)}, ${dopMoneyString(item1.value.listOrderRequests[i].passengers!)} \nИтого $tr руб';
                                              }
                                            }
                                          }
                                          return '-';
                                        }

                                        //--
                                        onInitTextController1();
                                        await showDialog(
                                          context: Get.context!,
                                          builder: (context) {
                                            return SimpleDialog(
                                              alignment: Alignment.center,
                                              clipBehavior: Clip.antiAlias,
                                              title: Text(
                                                  'Заказ № ${item1.value.id}'),
                                              children: [
                                                Obx(
                                                  () => SizedBox(
                                                    height: 600,
                                                    width: 700,
                                                    child: ListView(
                                                      children: [
                                                        ListTile(
                                                          dense: true,
                                                          title: Text(
                                                              'Дата и время отпраки по основному маршруту, $time1 ${item1.value.date}'),
                                                          subtitle: Text(
                                                              'Дата создание заказа ${DateFormat('dd.MM.yyyy H:m').format(DateTime.fromMillisecondsSinceEpoch(int.parse(item1.value.datetimeCreated!)))}'),
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 120,
                                                              child:
                                                                  TextFieldCustom(
                                                                title:
                                                                    'Кол-во мест',
                                                                hintText:
                                                                    'кол-мест',
                                                                controller: list[
                                                                    'count_mest'],
                                                                inputFormatters: [
                                                                  MaskTextInputFormatter(
                                                                    mask: "#",
                                                                    filter: {
                                                                      "#": RegExp(
                                                                          r'[0-9]')
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: 150,
                                                              child:
                                                                  TextFieldCustom(
                                                                title: '%',
                                                                hintText: '4',
                                                                controller: list[
                                                                    'degres'],
                                                                inputFormatters: [
                                                                  MaskTextInputFormatter(
                                                                    mask: "##",
                                                                    filter: {
                                                                      "#": RegExp(
                                                                          r'[0-9]')
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            IconButton(
                                                              color: const Color(
                                                                  0xff819fb9),
                                                              onPressed:
                                                                  () async {
                                                                await newPass(
                                                                  addpayments1:
                                                                      controller
                                                                          .listAddPayment,
                                                                  card1: getCardsIDmodel(
                                                                      controller
                                                                          .listOrders[
                                                                              j]
                                                                          .idcards!)!,
                                                                  cards1: getCardsName(
                                                                      controller
                                                                          .listOrders[
                                                                              j]
                                                                          .idcards!),
                                                                  newObj: controller
                                                                      .newOpassager,
                                                                  order1: controller
                                                                      .listOrders[j],
                                                                  time1: controller.getTimes(
                                                                      controller
                                                                          .listOrders[
                                                                              j]
                                                                          .idtimes)!,
                                                                  dop: controller
                                                                      .listDOP,
                                                                );

                                                                onupdade1();
                                                              },
                                                              icon: const Icon(
                                                                  Icons
                                                                      .person_add),
                                                            ),
                                                            IconButton(
                                                              color: const Color(
                                                                  0xff819fb9),
                                                              onPressed:
                                                                  () async {
                                                                onupdade1();
                                                              },
                                                              icon: const Icon(
                                                                  Icons.update),
                                                            ),
                                                            IconButton(
                                                              color: const Color(
                                                                  0xff819fb9),
                                                              onPressed:
                                                                  () async {
                                                                showDialog(
                                                                  context: Get
                                                                      .context!,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      alignment:
                                                                          Alignment
                                                                              .bottomCenter,
                                                                      clipBehavior:
                                                                          Clip.antiAlias,
                                                                      title: const Text(
                                                                          'Уведомление'),
                                                                      content:
                                                                          const Text(
                                                                              'Вы действительно хотите удалить запись?'),
                                                                      actions: [
                                                                        TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            bool
                                                                                r =
                                                                                await onRemove(item1.value.id.toString());
                                                                            if (r ==
                                                                                true) {
                                                                              Get.back();
                                                                              Get.back();
                                                                            }
                                                                          },
                                                                          child:
                                                                              const Text('Да'),
                                                                        ),
                                                                        TextButton(
                                                                          onPressed: () =>
                                                                              Get.back(),
                                                                          child:
                                                                              const Text('Нет'),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  },
                                                                );
                                                              },
                                                              icon: const Icon(
                                                                  Icons.delete),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        Row(
                                                          children: [
                                                            const Spacer(),
                                                            GestureDetector(
                                                              onTap: () =>
                                                                  Get.back(),
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                height: 50,
                                                                width: 200,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Color(
                                                                      0xff819fb9),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            15),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    'Отмена',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            GestureDetector(
                                                              onTap: () async {
                                                                int da = 0;
                                                                if (list['degres']
                                                                        ?.text
                                                                        .length !=
                                                                    0) {
                                                                  try {
                                                                    da = int.parse(list[
                                                                            'degres']!
                                                                        .text
                                                                        .toString());
                                                                  } catch (e) {
                                                                    ///
                                                                  }
                                                                }
                                                                bool r =
                                                                    await onSave({
                                                                  "count_mest":
                                                                      list['count_mest']
                                                                          ?.text,
                                                                  "driver_mobile":
                                                                      list['driver_mobile']
                                                                          ?.text,
                                                                  "driver_info":
                                                                      list['driver_info']
                                                                          ?.text,
                                                                  "degres": da
                                                                      .toString(),
                                                                  "id": item1
                                                                      .value.id
                                                                      .toString()
                                                                });
                                                                if (r == true) {
                                                                  Get.back();
                                                                }
                                                              },
                                                              child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                height: 50,
                                                                width: 200,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Color(
                                                                      0xff205CBE),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            15),
                                                                  ),
                                                                ),
                                                                child:
                                                                    const Center(
                                                                  child: Text(
                                                                    'Готово',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                          ],
                                                        ),

                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  left: 20,
                                                                  right: 20),
                                                          child: Container(
                                                            height: .5,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                        ),

                                                        const SizedBox(
                                                            height: 15),
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 350,
                                                              child: DropList(
                                                                list:
                                                                    getDriver1(),
                                                                type: 'drop',
                                                                title:
                                                                    'Водитель',
                                                                initMail:
                                                                    driver1
                                                                        .value,
                                                                onPress: (s) {
                                                                  if (s !=
                                                                      null) {
                                                                    driver1.value =
                                                                        s;
                                                                    driver1
                                                                        .refresh();
                                                                  }
                                                                },
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20),
                                                                child: Text(
                                                                  getInfoIdDriver1() ??
                                                                      'Водитель: -',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 15),
                                                        Row(
                                                          children: [
                                                            const Spacer(),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (getIdDriver1() !=
                                                                    null) {
                                                                  bool r =
                                                                      await onSaveDriver({
                                                                    "iddriver":
                                                                        getIdDriver1(),
                                                                    "idorders":
                                                                        item1
                                                                            .value
                                                                            .id,
                                                                  });
                                                                  if (r ==
                                                                      true) {
                                                                    onupdade1();
                                                                  }
                                                                }
                                                              },
                                                              child: const Text(
                                                                'Назначить водителя',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  color: Color(
                                                                      0xff205CBE),
                                                                ),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            TextButton(
                                                              onPressed:
                                                                  () async {
                                                                bool r = await onRemoveDriver(item1
                                                                    .value
                                                                    .listOrderDrivers
                                                                    .last
                                                                    .id
                                                                    .toString());
                                                                if (r == true) {
                                                                  onupdade1();
                                                                }
                                                              },
                                                              child: const Text(
                                                                'Убрать назначение водителя',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 15,
                                                                  color: Color(
                                                                      0xff205CBE),
                                                                ),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                          ],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 15,
                                                                  left: 20,
                                                                  right: 20),
                                                          child: Container(
                                                            height: .5,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                        ),
                                                        //
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child:
                                                                  ExpansionTile(
                                                                iconColor:
                                                                    const Color(
                                                                        0xff205CBE),
                                                                textColor:
                                                                    const Color(
                                                                        0xff205CBE),
                                                                initiallyExpanded:
                                                                    true,
                                                                title: Text(
                                                                    'Пассажиры (${item1.value.countPassagers()})'),
                                                                children: [
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          item1
                                                                              .value
                                                                              .listOrderRequests
                                                                              .length;
                                                                      i++)
                                                                    ListTile(
                                                                      dense: item1.value.listOrderRequests[i].idstate !=
                                                                              2
                                                                          ? false
                                                                          : true,
                                                                      enabled: item1.value.listOrderRequests[i].idstate !=
                                                                              2
                                                                          ? true
                                                                          : false,
                                                                      onTap:
                                                                          () async {
                                                                        ModelOrderRequests
                                                                            item2 =
                                                                            item1.value.listOrderRequests[i];
                                                                        String
                                                                            addpayment2 =
                                                                            'Не выбрано';
                                                                        late List<ModelAdditionalPayment>
                                                                            addpayments2 =
                                                                            addpayments1;
                                                                        var list2 = <
                                                                            String,
                                                                            TextEditingController>{}.obs;

                                                                        Future<bool>
                                                                                Function(Map<String, dynamic>)
                                                                            onSave =
                                                                            onSavePassagers;
                                                                        List<String>
                                                                            getAddPay2() {
                                                                          List<String>
                                                                              l =
                                                                              [
                                                                            'Не выбрано'
                                                                          ];
                                                                          for (int i = 0;
                                                                              i < addpayments2.length;
                                                                              i++) {
                                                                            l.add('${addpayments2[i].text} ${addpayments2[i].payment} руб');
                                                                          }
                                                                          return l;
                                                                        }

                                                                        String? getStrAddPayment2(
                                                                            int?
                                                                                id) {
                                                                          if (id !=
                                                                              null) {
                                                                            for (int i = 0;
                                                                                i < addpayments2.length;
                                                                                i++) {
                                                                              if (id == addpayments2[i].id) {
                                                                                return '${addpayments2[i].text} ${addpayments2[i].payment} руб';
                                                                              }
                                                                            }
                                                                          }
                                                                          return null;
                                                                        }

                                                                        int?
                                                                            getIdAddPay2() {
                                                                          for (int i = 0;
                                                                              i < addpayments2.length;
                                                                              i++) {
                                                                            if (addpayment2 ==
                                                                                '${addpayments2[i].text} ${addpayments2[i].payment} руб') {
                                                                              return addpayments2[i].id;
                                                                            }
                                                                          }
                                                                          return null;
                                                                        }

                                                                        onInitTextController2() {
                                                                          list2['in_adress'] =
                                                                              TextEditingController(text: item2.passengers?.inAdress);
                                                                          list2['out_adress'] =
                                                                              TextEditingController(text: item2.passengers?.outAdress);
                                                                          list2['info'] =
                                                                              TextEditingController(text: item2.passengers?.info);
                                                                          list2['name'] =
                                                                              TextEditingController(text: item2.passengers?.name);
                                                                          list2['mobile'] =
                                                                              TextEditingController(text: item2.passengers?.mobile);
                                                                          list2['degres'] =
                                                                              TextEditingController(text: '${item2.passengers?.degres}');
                                                                          list2['payment'] =
                                                                              TextEditingController(text: '${item2.passengers?.payment}');
                                                                          addpayment2 =
                                                                              getStrAddPayment2(item2.passengers?.idaddPAyment) ?? 'Не выбрано';
                                                                          list2
                                                                              .refresh();
                                                                        }

                                                                        onInitTextController2();

                                                                        await showDialog(
                                                                          context:
                                                                              Get.context!,
                                                                          builder:
                                                                              (context) {
                                                                            return SimpleDialog(
                                                                              alignment: Alignment.center,
                                                                              clipBehavior: Clip.antiAlias,
                                                                              title: Text('Заказ ID ${item2.id}, пассажир ID ${item2.passengers?.id}'),
                                                                              children: [
                                                                                Obx(
                                                                                  () => SizedBox(
                                                                                    height: 600,
                                                                                    width: 500,
                                                                                    child: ListView(
                                                                                      children: [
                                                                                        //
                                                                                        TextFieldCustom(
                                                                                          title: 'Имя',
                                                                                          hintText: 'имя пассажира',
                                                                                          controller: list2['name'],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Flexible(
                                                                                              child: TextFieldCustom(
                                                                                                title: 'адрес от',
                                                                                                hintText: 'откуда',
                                                                                                controller: list2['in_adress'],
                                                                                              ),
                                                                                            ),
                                                                                            Flexible(
                                                                                              child: TextFieldCustom(
                                                                                                title: 'адрес до',
                                                                                                hintText: 'куда',
                                                                                                controller: list2['out_adress'],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        Row(
                                                                                          children: [
                                                                                            Flexible(
                                                                                              child: Padding(
                                                                                                padding: const EdgeInsets.only(
                                                                                                  left: 20,
                                                                                                  right: 20,
                                                                                                ),
                                                                                                child: DropList2Check(
                                                                                                  title: 'Доп. опции',
                                                                                                  listID: [
                                                                                                    for (int y = 0; y < controller.listDOP.length; y++) controller.listDOP[y].id!
                                                                                                  ],
                                                                                                  list: [
                                                                                                    for (int y = 0; y < controller.listDOP.length; y++) controller.listDOP[y].name!
                                                                                                  ],
                                                                                                  m: item2.passengers!.dataFull == null ? null : item2.passengers!.dataFull!,
                                                                                                  color: const Color(0xffF0F2F0),
                                                                                                  onChange: (l, m) {
                                                                                                    print(l);
                                                                                                    print(m);
                                                                                                    item2.passengers!.dataFull = m;
                                                                                                    //list['data_full']!.text = jsonEncode(m);
                                                                                                    //upd2();
                                                                                                  },
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                            Flexible(
                                                                                              child: TextFieldCustom(
                                                                                                title: 'Скидка %',
                                                                                                hintText: '10',
                                                                                                controller: list2['degres'],
                                                                                                inputFormatters: [
                                                                                                  MaskTextInputFormatter(
                                                                                                    mask: "###",
                                                                                                    filter: {
                                                                                                      "#": RegExp(r'[0-9]')
                                                                                                    },
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            Flexible(
                                                                                              child: TextFieldCustom(
                                                                                                title: 'Скидка в руб',
                                                                                                hintText: '10',
                                                                                                controller: list2['payment'],
                                                                                                inputFormatters: [
                                                                                                  MaskTextInputFormatter(
                                                                                                    mask: "######",
                                                                                                    filter: {
                                                                                                      "#": RegExp(r'[0-9]')
                                                                                                    },
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),

                                                                                        TextFieldCustom(
                                                                                          title: 'Доп. инфо',
                                                                                          hintText: 'дополнительная информация',
                                                                                          controller: list2['info'],
                                                                                        ),
                                                                                        TextFieldCustom(
                                                                                          title: 'Мобильный',
                                                                                          hintText: '7(999)130-40-53',
                                                                                          controller: list2['mobile'],
                                                                                          inputFormatters: [
                                                                                            MaskTextInputFormatter(
                                                                                              mask: '+7(###) ###-##-##',
                                                                                              filter: {
                                                                                                "#": RegExp(r'[0-9]')
                                                                                              },
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                        DropList(
                                                                                          list: getAddPay2(),
                                                                                          type: 'drop',
                                                                                          title: 'Район',
                                                                                          initMail: addpayment2,
                                                                                          onPress: (s) {
                                                                                            if (s != null) {
                                                                                              addpayment2 = s;
                                                                                            }
                                                                                          },
                                                                                        ),
                                                                                        const SizedBox(height: 15),
                                                                                        Row(
                                                                                          children: [
                                                                                            const Spacer(),
                                                                                            GestureDetector(
                                                                                              onTap: () => Get.back(),
                                                                                              child: Container(
                                                                                                padding: const EdgeInsets.only(left: 20, right: 20),
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
                                                                                              onTap: () async {
                                                                                                bool r = await onSave({
                                                                                                  "degres": list2['degres']?.text.length == 0 ? 0 : list2['degres']!.text,
                                                                                                  "payment": list2['payment']?.text.length == 0 ? 0 : list2['payment']!.text,
                                                                                                  "in_adress": list2['in_adress']?.text,
                                                                                                  "out_adress": list2['out_adress']?.text,
                                                                                                  "info": list2['info']?.text,
                                                                                                  "data_full": item2.passengers!.dataFull == null ? null : jsonEncode(item2.passengers!.dataFull!),
                                                                                                  //"count": list['count']?.text,
                                                                                                  "name": list2['name']?.text,
                                                                                                  "mobile": list2['mobile']?.text.replaceAll(RegExp(r'[^0-9]'), ""),
                                                                                                  "id": item2.idpassengers.toString(),
                                                                                                  "additional_payment_idadd_payment":
                                                                                                      // ignore: prefer_null_aware_operators
                                                                                                      getIdAddPay2() != null ? getIdAddPay2().toString() : null
                                                                                                });
                                                                                                if (r == true) {
                                                                                                  Get.back();
                                                                                                }
                                                                                              },
                                                                                              child: Container(
                                                                                                padding: const EdgeInsets.only(left: 20, right: 20),
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
                                                                                                    'Готово',
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
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                        onupdade1();
                                                                        /*
                                                                      await Get.to(
                                                                          () =>
                                                                              ItemPassegerOrder(
                                                                                item.value.listOrderRequests[i],
                                                                                onSave: onSavePassagers,
                                                                                addpayments: addpayments,
                                                                              ));
                                                                      onupdade();
                                                                      */
                                                                      },
                                                                      leading: item1.value.listOrderRequests[i].passengers!.idusers !=
                                                                              null
                                                                          ? const Icon(Icons
                                                                              .mobile_friendly)
                                                                          : const Icon(
                                                                              Icons.window_sharp),
                                                                      title: Text(
                                                                          '${item1.value.listOrderRequests[i].passengers?.name}, мест ${item1.value.listOrderRequests[i].passengers?.count}'),
                                                                      subtitle:
                                                                          Row(
                                                                        children: [
                                                                          Flexible(
                                                                            child:
                                                                                Text('${item1.value.listOrderRequests[i].passengers?.mobile}, от: ${item1.value.listOrderRequests[i].passengers?.inAdress}, до: ${item1.value.listOrderRequests[i].passengers?.outAdress}\n${getCardsMoneyInfo1(item1.value.listOrderRequests[i].id!)}'),
                                                                          ),
                                                                          IconButton(
                                                                            onPressed:
                                                                                () {
                                                                              Clipboard.setData(ClipboardData(text: '${item1.value.listOrderRequests[i].passengers?.name}, мест ${item1.value.listOrderRequests[i].passengers?.count}\n${item1.value.listOrderRequests[i].passengers?.mobile}, от: ${item1.value.listOrderRequests[i].passengers?.inAdress}, до: ${item1.value.listOrderRequests[i].passengers?.outAdress}\n${getCardsMoneyInfo1(item1.value.listOrderRequests[i].id!)}'));
                                                                            },
                                                                            icon:
                                                                                const Icon(Icons.copy),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      trailing:
                                                                          IconButton(
                                                                        onPressed:
                                                                            () async {
                                                                          if (item1.value.listOrderRequests[i].idstate !=
                                                                              2) {
                                                                            bool
                                                                                r =
                                                                                await onRemovePassagers(item1.value.listOrderRequests[i].id.toString(), 2);
                                                                            if (r ==
                                                                                true) {
                                                                              //Get.back();
                                                                            }
                                                                            onupdade1();
                                                                          }
                                                                        },
                                                                        icon: const Icon(
                                                                            Icons.delete),
                                                                      ),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          25),
                                                                ],
                                                              ),
                                                            ),
                                                            Flexible(
                                                              child:
                                                                  ExpansionTile(
                                                                iconColor:
                                                                    const Color(
                                                                        0xff205CBE),
                                                                textColor:
                                                                    const Color(
                                                                        0xff205CBE),
                                                                initiallyExpanded:
                                                                    true,
                                                                title: const Text(
                                                                    'Статусы заказа'),
                                                                children: [
                                                                  for (int i =
                                                                          0;
                                                                      i <
                                                                          item1
                                                                              .value
                                                                              .listOrderDrivers
                                                                              .length;
                                                                      i++)
                                                                    ListTile(
                                                                      title: Text(
                                                                          'ID водителя ${item1.value.listOrderDrivers[i].iddrivers}'),
                                                                      subtitle:
                                                                          Text(
                                                                              '"${getInfoStateDriver1(item1.value.listOrderDrivers[i].idstate!)}"'),
                                                                    ),
                                                                  const SizedBox(
                                                                      height:
                                                                          25),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 25),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        controller.getData(date.value);
                                      },
                                      icon: const Icon(Icons.create),
                                    ),
                                    IconButton(
                                      color: const Color(0xff205CBE),
                                      onPressed: () async {
                                        await newPass(
                                          addpayments1:
                                              controller.listAddPayment,
                                          card1: getCardsIDmodel(controller
                                              .listOrders[j].idcards!)!,
                                          cards1: getCardsName(controller
                                              .listOrders[j].idcards!),
                                          newObj: controller.newOpassager,
                                          order1: controller.listOrders[j],
                                          time1: controller.getTimes(controller
                                              .listOrders[j].idtimes)!,
                                          dop: controller.listDOP,
                                        );
                                        controller.getData(date.value);
                                        return;
                                        ModelOrders order1 =
                                            controller.listOrders[j];
                                        ModelCards card1 = getCardsIDmodel(
                                            controller.listOrders[j].idcards!)!;
                                        String? time1 = controller.getTimes(
                                            controller.listOrders[j].idtimes);
                                        var updInfo1 = false.obs;
                                        String cards1 = getCardsName(
                                            controller.listOrders[j].idcards!);
                                        String addpayment1 = 'Не выбрано';
                                        List<ModelAdditionalPayment>
                                            addpayments1 =
                                            controller.listAddPayment;

                                        Map<String, TextEditingController>
                                            list = {
                                          'in_adress': TextEditingController(),
                                          'out_adress': TextEditingController(),
                                          'info': TextEditingController(),
                                          'count':
                                              TextEditingController(text: '1'),
                                          'name': TextEditingController(),
                                          'mobile': TextEditingController(),
                                          'degres': TextEditingController(),
                                          'payment': TextEditingController(),
                                        };
                                        Future<bool> Function(
                                                Map<String, dynamic>) newObj =
                                            controller.newOpassager;
                                        //--
                                        List<String> getCards1() {
                                          List<String> l = [
                                            '${card1.inMap} - ${card1.outMap}'
                                          ];
                                          for (int i = 0;
                                              i < card1.lisIntertCards.length;
                                              i++) {
                                            l.add(
                                                '${card1.lisIntertCards[i].inMap} - ${card1.lisIntertCards[i].outMap}');
                                          }
                                          return l;
                                        }

                                        int? getIdCardsInter1() {
                                          for (int i = 0;
                                              i < card1.lisIntertCards.length;
                                              i++) {
                                            if (cards1 ==
                                                '${card1.lisIntertCards[i].inMap} - ${card1.lisIntertCards[i].outMap}') {
                                              return card1.lisIntertCards[i].id;
                                            }
                                          }
                                          return null;
                                        }

                                        List<String> getAddPay1() {
                                          List<String> l = ['Не выбрано'];
                                          for (int i = 0;
                                              i < addpayments1.length;
                                              i++) {
                                            l.add(
                                                '${addpayments1[i].text} ${addpayments1[i].payment} руб');
                                          }
                                          return l;
                                        }

                                        int? getIdAddPay1() {
                                          for (int i = 0;
                                              i < addpayments1.length;
                                              i++) {
                                            if (addpayment1 ==
                                                '${addpayments1[i].text} ${addpayments1[i].payment} руб') {
                                              return addpayments1[i].id;
                                            }
                                          }
                                          return null;
                                        }

                                        String getStrCardInter1(int id) {
                                          for (int j = 0;
                                              j < card1.lisIntertCards.length;
                                              j++) {
                                            if (id ==
                                                card1.lisIntertCards[j].id) {
                                              return 'ожидание ${card1.lisIntertCards[j].countMinute} минут'; //, ${card.lisIntertCards[j].inMap}-${card.lisIntertCards[j].outMap}, ${card.lisIntertCards[j].payment} руб';
                                            }
                                          }
                                          return '-';
                                        }

                                        String getStrCard1() {
                                          return '${card1.inMap}-${card1.outMap}, ${card1.payment} руб';
                                        }

                                        int getCardInterMoney1(int id) {
                                          for (int j = 0;
                                              j < card1.lisIntertCards.length;
                                              j++) {
                                            if (id ==
                                                card1.lisIntertCards[j].id) {
                                              return card1.lisIntertCards[j]
                                                      .payment ??
                                                  0;
                                            }
                                          }
                                          return 0;
                                        }

                                        int getCardMoney1() {
                                          return card1.payment ?? 0;
                                        }

                                        int getAddPayMoney1(int id) {
                                          for (int i = 0;
                                              i < addpayments1.length;
                                              i++) {
                                            if (id == addpayments1[i].id) {
                                              return addpayments1[i].payment ??
                                                  0;
                                            }
                                          }
                                          return 0;
                                        }

                                        String getAddPayStr1(int id) {
                                          for (int i = 0;
                                              i < addpayments1.length;
                                              i++) {
                                            if (id == addpayments1[i].id) {
                                              return '${addpayments1[i].text} +${addpayments1[i].payment} руб';
                                            }
                                          }
                                          return '';
                                        }

                                        String getInfoMoney1() {
                                          int res = 0;
                                          int? r = getIdCardsInter1();
                                          if (list['count']!.text.isNotEmpty) {
                                            if (r != null) {
                                              int m = getCardInterMoney1(r);
                                              res = m *
                                                  int.parse(
                                                      list['count']!.text);
                                            } else {
                                              int m = getCardMoney1();
                                              res = m *
                                                  int.parse(
                                                      list['count']!.text);
                                            }
                                            int? r2 = getIdAddPay1();
                                            if (r2 != null) {
                                              int m1 = getAddPayMoney1(r2);
                                              res += (m1 *
                                                  int.parse(
                                                      list['count']!.text));
                                            }
                                          }
                                          //                  " getIdCardsInter(),
                                          //  " getIdAddPay()
                                          return '$res руб';
                                        }

                                        upd1() {
                                          updInfo1.value = !updInfo1.value;
                                          updInfo1.refresh();
                                        }

                                        //--
                                        await showDialog(
                                          context: Get.context!,
                                          builder: (context) {
                                            return SimpleDialog(
                                              alignment: Alignment.center,
                                              clipBehavior: Clip.antiAlias,
                                              title: Text(
                                                'Добавить пассажира, № ${order1.id} ${card1.inMap} - ${card1.outMap}\nДата и время отпраки по основному маршруту $time1 ${order1.date}\nДата  создание заказа ${DateFormat('dd.MM.yyyy H:m').format(DateTime.fromMillisecondsSinceEpoch(int.parse(order1.datetimeCreated!)))}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              children: [
                                                SizedBox(
                                                  height: 600,
                                                  width: 600,
                                                  child: ListView(
                                                    children: [
                                                      //
                                                      Obx(
                                                        () => ListTile(
                                                          enabled:
                                                              updInfo1.value,
                                                          title: Text(
                                                            'Итого ${getInfoMoney1()}',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          subtitle: Text(
                                                              getIdCardsInter1() !=
                                                                      null
                                                                  ? getStrCardInter1(
                                                                      getIdCardsInter1()!)
                                                                  : '-'),
                                                        ),
                                                      ),

                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child: DropList(
                                                              list: getCards1(),
                                                              type: 'drop',
                                                              title: 'Маршрут',
                                                              initMail: cards1,
                                                              onPress: (s) {
                                                                if (s != null) {
                                                                  cards1 = s;
                                                                  upd1();
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child: DropList(
                                                              list:
                                                                  getAddPay1(),
                                                              type: 'drop',
                                                              title: 'Район',
                                                              //initMail: cards,
                                                              onPress: (s) {
                                                                if (s != null) {
                                                                  addpayment1 =
                                                                      s;
                                                                }
                                                                print('object');
                                                                upd1();
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 120,
                                                            child:
                                                                TextFieldCustom(
                                                              title: 'Кол-мест',
                                                              hintText:
                                                                  'кол-мест',
                                                              controller:
                                                                  list['count'],
                                                              inputFormatters: [
                                                                MaskTextInputFormatter(
                                                                  mask: "#",
                                                                  filter: {
                                                                    "#": RegExp(
                                                                        r'[0-9]')
                                                                  },
                                                                ),
                                                              ],
                                                              onChanged: (t) {
                                                                upd1();
                                                              },
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child:
                                                                TextFieldCustom(
                                                              title:
                                                                  'Доп. инфо',
                                                              hintText:
                                                                  'дополнительная информация',
                                                              controller:
                                                                  list['info'],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child:
                                                                TextFieldCustom(
                                                              title: 'Скидка %',
                                                              hintText: '10',
                                                              controller: list[
                                                                  'degres'],
                                                              inputFormatters: [
                                                                MaskTextInputFormatter(
                                                                  mask: "###",
                                                                  filter: {
                                                                    "#": RegExp(
                                                                        r'[0-9]')
                                                                  },
                                                                ),
                                                              ],
                                                              onChanged: (t) {
                                                                upd1();
                                                              },
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child:
                                                                TextFieldCustom(
                                                              title:
                                                                  'Скидка в руб',
                                                              hintText: '100',
                                                              controller: list[
                                                                  'payment'],
                                                              inputFormatters: [
                                                                MaskTextInputFormatter(
                                                                  mask:
                                                                      "######",
                                                                  filter: {
                                                                    "#": RegExp(
                                                                        r'[0-9]')
                                                                  },
                                                                ),
                                                              ],
                                                              onChanged: (t) {
                                                                upd1();
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      TextFieldCustom(
                                                        title: 'Имя',
                                                        hintText:
                                                            'имя пассажира',
                                                        controller:
                                                            list['name'],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Flexible(
                                                            child:
                                                                TextFieldCustom(
                                                              title: 'адрес от',
                                                              hintText:
                                                                  'откуда',
                                                              controller: list[
                                                                  'in_adress'],
                                                            ),
                                                          ),
                                                          Flexible(
                                                            child:
                                                                TextFieldCustom(
                                                              title: 'адрес до',
                                                              hintText: 'куда',
                                                              controller: list[
                                                                  'out_adress'],
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      TextFieldCustom(
                                                        title: 'Мобильный',
                                                        hintText:
                                                            '7(999)130-40-53',
                                                        controller:
                                                            list['mobile'],
                                                        inputFormatters: [
                                                          MaskTextInputFormatter(
                                                            mask:
                                                                '+7(###) ###-##-##',
                                                            filter: {
                                                              "#": RegExp(
                                                                  r'[0-9]')
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                      Row(
                                                        children: [
                                                          const Spacer(),
                                                          GestureDetector(
                                                            onTap: () =>
                                                                Get.back(),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              height: 50,
                                                              width: 200,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color(
                                                                    0xff819fb9),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'Отмена',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              bool r =
                                                                  await newObj({
                                                                "degres": list['degres']
                                                                            ?.text
                                                                            .length ==
                                                                        0
                                                                    ? null
                                                                    : int.parse(
                                                                        list['degres']!
                                                                            .text),
                                                                "payment": list['payment']
                                                                            ?.text
                                                                            .length ==
                                                                        0
                                                                    ? null
                                                                    : int.parse(
                                                                        list['payment']!
                                                                            .text),
                                                                "in_adress":
                                                                    list['in_adress']
                                                                        ?.text,
                                                                "out_adress":
                                                                    list['out_adress']
                                                                        ?.text,
                                                                "info":
                                                                    list['info']
                                                                        ?.text,
                                                                "count": list[
                                                                        'count']
                                                                    ?.text,
                                                                "name":
                                                                    list['name']
                                                                        ?.text,
                                                                "mobile": list[
                                                                        'mobile']
                                                                    ?.text
                                                                    .replaceAll(
                                                                        RegExp(
                                                                            r'[^0-9]'),
                                                                        ""),
                                                                "cards_idcards":
                                                                    order1
                                                                        .idcards,
                                                                "times_idtimes":
                                                                    order1
                                                                        .idtimes,
                                                                "orders_idorders":
                                                                    order1.id,
                                                                "intermediate_cards_idintermediate_cards":
                                                                    getIdCardsInter1(),
                                                                "additional_payment_idadd_payment":
                                                                    getIdAddPay1()
                                                              });
                                                              if (r == true) {
                                                                Get.back();
                                                              }
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              height: 50,
                                                              width: 200,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color(
                                                                    0xff205CBE),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          15),
                                                                ),
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Text(
                                                                  'Добавить',
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        controller.getData(date.value);
                                      },
                                      icon: const Icon(Icons.person_add_alt),
                                    ),
                                    IconButton(
                                      color: const Color(0xff205CBE),
                                      onPressed: () async {
                                        showDialog(
                                          context: Get.context!,
                                          builder: (context) {
                                            return AlertDialog(
                                              alignment: Alignment.bottomCenter,
                                              clipBehavior: Clip.antiAlias,
                                              title: const Text('Уведомление'),
                                              content: const Text(
                                                  'Вы действительно хотите удалить запись?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () async {
                                                    bool r = await controller
                                                        .removeO(controller
                                                            .listOrders[j].id
                                                            .toString());
                                                    if (r == true) {
                                                      Get.back();
                                                      controller
                                                          .getData(date.value);
                                                    }
                                                  },
                                                  child: const Text('Да'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Get.back(),
                                                  child: const Text('Нет'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: const Icon(Icons.delete_outlined),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

newPass(
    {required Future<bool> Function(Map<String, dynamic>) newObj,
    required List<ModelAdditionalPayment> addpayments1,
    required String cards1,
    required ModelOrders order1,
    required ModelCards card1,
    required String time1,
    required List<ModelDop> dop}) async {
  var updInfo1 = false.obs;
  String addpayment1 = 'Не выбрано';

  Map<String, TextEditingController> list = {
    'in_adress': TextEditingController(),
    'out_adress': TextEditingController(),
    'info': TextEditingController(),
    'count': TextEditingController(text: '1'),
    'name': TextEditingController(),
    'mobile': TextEditingController(),
    'degres': TextEditingController(),
    'payment': TextEditingController(),
    'data_full': TextEditingController(),
  };

  //--
  List<String> getCards1() {
    List<String> l = ['${card1.inMap} - ${card1.outMap}'];
    for (int i = 0; i < card1.lisIntertCards.length; i++) {
      l.add(
          '${card1.lisIntertCards[i].inMap} - ${card1.lisIntertCards[i].outMap}');
    }
    return l;
  }

  int? getIdCardsInter1() {
    for (int i = 0; i < card1.lisIntertCards.length; i++) {
      if (cards1 ==
          '${card1.lisIntertCards[i].inMap} - ${card1.lisIntertCards[i].outMap}') {
        return card1.lisIntertCards[i].id;
      }
    }
    return null;
  }

  List<String> getAddPay1() {
    List<String> l = ['Не выбрано'];
    for (int i = 0; i < addpayments1.length; i++) {
      l.add('${addpayments1[i].text} ${addpayments1[i].payment} руб');
    }
    return l;
  }

  int? getIdAddPay1() {
    for (int i = 0; i < addpayments1.length; i++) {
      if (addpayment1 ==
          '${addpayments1[i].text} ${addpayments1[i].payment} руб') {
        return addpayments1[i].id;
      }
    }
    return null;
  }

  String getStrCardInter1(int id) {
    for (int j = 0; j < card1.lisIntertCards.length; j++) {
      if (id == card1.lisIntertCards[j].id) {
        return 'ожидание ${card1.lisIntertCards[j].countMinute} минут'; //, ${card.lisIntertCards[j].inMap}-${card.lisIntertCards[j].outMap}, ${card.lisIntertCards[j].payment} руб';
      }
    }
    return '-';
  }

  String getStrCard1() {
    return '${card1.inMap}-${card1.outMap}, ${card1.payment} руб';
  }

  int getCardInterMoney1(int id) {
    for (int j = 0; j < card1.lisIntertCards.length; j++) {
      if (id == card1.lisIntertCards[j].id) {
        return card1.lisIntertCards[j].payment ?? 0;
      }
    }
    return 0;
  }

  int getCardMoney1() {
    return card1.payment ?? 0;
  }

  int getAddPayMoney1(int id) {
    for (int i = 0; i < addpayments1.length; i++) {
      if (id == addpayments1[i].id) {
        return addpayments1[i].payment ?? 0;
      }
    }
    return 0;
  }

  String getAddPayStr1(int id) {
    for (int i = 0; i < addpayments1.length; i++) {
      if (id == addpayments1[i].id) {
        return '${addpayments1[i].text} +${addpayments1[i].payment} руб';
      }
    }
    return '';
  }

  //fffffff
  int dopMoney() {
    int r = 0;
    var json;
    try {
      json = jsonDecode(list['data_full']!.text);
    } catch (e) {
      print('err json dop');
      return 0;
    }
    for (int d = 0; d < dop.length; d++) {
      if (json[dop[d].name] != null) {
        if (dop[d].id == json[dop[d].name]['id']) {
          if (json[dop[d].name]['enable'] == true) {
            r += dop[d].payment!;
            print(r);
          }
        }
      }
    }
    return r;
  }

  //ffffffff
  String getInfoMoney1() {
    int res = 0;
    int? r = getIdCardsInter1();
    if (list['count']!.text.isNotEmpty) {
      if (r != null) {
        int m = getCardInterMoney1(r);
        res = m * int.parse(list['count']!.text);
      } else {
        int m = getCardMoney1();
        res = m * int.parse(list['count']!.text);
      }
      int? r2 = getIdAddPay1();
      if (r2 != null) {
        int m1 = getAddPayMoney1(r2);
        res += (m1 * int.parse(list['count']!.text));
      }
    }
    //                  " getIdCardsInter(),
    //  " getIdAddPay()

    int deg = 0, pay = 0;
    if (list['degres']!.text.length != 0) {
      try {
        deg = int.parse(list['degres']!.text);
      } catch (e) {
        //
      }
    }
    if (list['payment']!.text.length != 0) {
      try {
        pay = int.parse(list['payment']!.text);
      } catch (e) {
        //
        print('err2');
      }
    }
    res = res + dopMoney();

    if (pay != 0) {
      res = res - pay;
    }
    if (deg != 0) {
      //сумма/100×%
      try {
        double dz = ((res / 100) * deg);
        res = res - dz.toInt();
      } catch (e) {
        //
        print('err1');
      }
    }

    return '$res руб';
  }

  upd1() {
    updInfo1.value = !updInfo1.value;
    updInfo1.refresh();
  }

  //--
  await showDialog(
    context: Get.context!,
    builder: (context) {
      return SimpleDialog(
        alignment: Alignment.center,
        insetPadding: const EdgeInsets.all(5),
        clipBehavior: Clip.antiAlias,
        title: Text(
          'Добавить пассажира, № ${order1.id} ${card1.inMap} - ${card1.outMap}\nДата и время отпраки по основному маршруту $time1 ${order1.date}\nДата  создание заказа ${DateFormat('dd.MM.yyyy H:m').format(DateTime.fromMillisecondsSinceEpoch(int.parse(order1.datetimeCreated!)))}',
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
        children: [
          Obx(
            () => ListTile(
              enabled: updInfo1.value,
              title: Text(
                'Итого ${getInfoMoney1()}',
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(getIdCardsInter1() != null
                  ? getStrCardInter1(getIdCardsInter1()!)
                  : '-'),
            ),
          ),
          DropList(
            list: getCards1(),
            type: 'drop',
            title: 'Маршрут',
            initMail: cards1,
            onPress: (s) {
              if (s != null) {
                cards1 = s;
                upd1();
              }
            },
          ),
          DropList(
            list: getAddPay1(),
            type: 'drop',
            title: 'Район',
            //initMail: cards,
            onPress: (s) {
              if (s != null) {
                addpayment1 = s;
              }
              print('object');
              upd1();
            },
          ),
          Row(
            children: [
              SizedBox(
                width: 120,
                child: TextFieldCustom(
                  title: 'Кол-мест',
                  hintText: 'кол-мест',
                  controller: list['count'],
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: "#",
                      filter: {"#": RegExp(r'[0-9]')},
                    ),
                  ],
                  onChanged: (t) {
                    upd1();
                  },
                ),
              ),
              Flexible(
                child: TextFieldCustom(
                  title: 'Доп. инфо',
                  hintText: 'дополнительная информация',
                  controller: list['info'],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 15,
            ),
            child: DropList2Check(
              title: 'Доп. платы',
              listID: [for (int y = 0; y < dop.length; y++) dop[y].id!],
              list: [for (int y = 0; y < dop.length; y++) dop[y].name!],
              color: const Color(0xffF0F2F0),
              onChange: (l, m) {
                print(l);
                print(m);
                list['data_full']!.text = jsonEncode(m);
                upd1();
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: TextFieldCustom(
                  title: 'Скидка %',
                  hintText: '10',
                  controller: list['degres'],
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: "###",
                      filter: {"#": RegExp(r'[0-9]')},
                    ),
                  ],
                  onChanged: (t) {
                    upd1();
                  },
                ),
              ),
              Flexible(
                child: TextFieldCustom(
                  title: 'Скидка в руб',
                  hintText: '100',
                  controller: list['payment'],
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: "######",
                      filter: {"#": RegExp(r'[0-9]')},
                    ),
                  ],
                  onChanged: (t) {
                    upd1();
                  },
                ),
              ),
            ],
          ),
          TextFieldCustom(
            title: 'Имя',
            hintText: 'имя пассажира',
            controller: list['name'],
          ),
          Row(
            children: [
              Flexible(
                child: TextFieldCustom(
                  title: 'адрес от',
                  hintText: 'откуда',
                  controller: list['in_adress'],
                ),
              ),
              Flexible(
                child: TextFieldCustom(
                  title: 'адрес до',
                  hintText: 'куда',
                  controller: list['out_adress'],
                ),
              ),
            ],
          ),
          TextFieldCustom(
            title: 'Мобильный',
            hintText: '7(999)130-40-53',
            controller: list['mobile'],
            inputFormatters: [
              MaskTextInputFormatter(
                mask: '+7(###) ###-##-##',
                filter: {"#": RegExp(r'[0-9]')},
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Spacer(),
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  height: 50,
                  width: 150,
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
                onTap: () async {
                  bool r = await newObj({
                    "degres": list['degres']?.text.length == 0
                        ? 0
                        : int.parse(list['degres']!.text),
                    "payment": list['payment']?.text.length == 0
                        ? 0
                        : int.parse(list['payment']!.text),
                    "in_adress": list['in_adress']?.text,
                    "data_full": list['data_full']!.text.length == 0
                        ? null
                        : jsonDecode(list['data_full']!.text),
                    "out_adress": list['out_adress']?.text,
                    "info": list['info']?.text,
                    "count": list['count']?.text,
                    "name": list['name']?.text,
                    "mobile":
                        list['mobile']?.text.replaceAll(RegExp(r'[^0-9]'), ""),
                    "cards_idcards": order1.idcards,
                    "times_idtimes": order1.idtimes,
                    "orders_idorders": order1.id,
                    "intermediate_cards_idintermediate_cards":
                        getIdCardsInter1(),
                    "additional_payment_idadd_payment": getIdAddPay1()
                  });
                  if (r == true) {
                    Get.back();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  height: 50,
                  width: 150,
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
}

class ViewOrders2 extends StatelessWidget {
  final controller = Get.put(OrdersController());
  var date = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;
  var cards = ''.obs;
  List<String> getDate() {
    List<String> l = [];
    DateTime now = DateTime.now();
    now = now.add(const Duration(days: -10));
    var formatter = DateFormat('yyyy-MM-dd');
    for (int i = 0; i < 20; i++) {
      l.add(formatter.format(now));
      now = now.add(const Duration(days: 1));
    }
    return l;
  }

  var filterOne = false.obs;
  var filterTwo = false.obs;
  var filterFree = false.obs;
  filterOneSend(bool b) {
    if (b == true) {
      filterTwo.value = false;
      filterTwo.refresh();
      filterFree.value = false;
      filterFree.refresh();
    }
    filterOne.value = b;
    filterOne.refresh();
  }

  filterTwoSend(bool b) {
    if (b == true) {
      filterFree.value = false;
      filterFree.refresh();
      filterOne.value = false;
      filterOne.refresh();
    }
    filterTwo.value = b;
    filterTwo.refresh();
  }

  filterFreeSend(bool b) {
    if (b == true) {
      filterTwo.value = false;
      filterTwo.refresh();
      filterOne.value = false;
      filterOne.refresh();
    }
    filterFree.value = b;
    filterFree.refresh();
  }

  List<String> getCards(ModelCards card) {
    List<String> l = ['${card.inMap} - ${card.outMap}'];
    for (int i = 0; i < card.lisIntertCards.length; i++) {
      l.add(
          '${card.lisIntertCards[i].inMap} - ${card.lisIntertCards[i].outMap}');
    }
    return l;
  }

  ModelIntermediateCards? getCardsInter(ModelCards card) {
    for (int i = 0; i < card.lisIntertCards.length; i++) {
      if (cards.value ==
          '${card.lisIntertCards[i].inMap} - ${card.lisIntertCards[i].outMap}') {
        return card.lisIntertCards[i];
      }
    }
    return null;
  }

  String? getTimeCards(int? idtimes, ModelCards card) {
    ModelIntermediateCards? cM = getCardsInter(card);
    ModelTimes? tM1 = controller.getTimesModel(idtimes);

    String? init = controller.getTimes(idtimes);
    if (tM1 != null) {
      if (cM != null) {
        if (tM1.minute != null && cM.countMinute != null) {
          int m = tM1.minute! + cM.countMinute!;
          String r = Duration(minutes: m).toString().substring(0, 5);
          if (r[4] == ':') {
            r = r.substring(0, 4);
          }
          return r;
        }
      }
    }
    return init;
  }

  ViewOrders2({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: controller.listCards.length,
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            title: const Text(
              'Заказы',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 28,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  controller.getData(date.value);
                },
                icon: const Icon(Icons.update),
              ),
            ],
            bottom: TabBar(
              isScrollable: true,
              labelColor: Colors.black,
              indicatorColor: Colors.black,
              tabs: [
                for (int i = 0; i < controller.listCards.length; i++)
                  SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        "${controller.listCards[i].inMap} - ${controller.listCards[i].outMap}",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              for (int i = 0; i < controller.listCards.length; i++)
                ListView(
                  children: [
                    ListTile(
                      leading: IconButton(
                        onPressed: () async {
                          await Get.to(() => NewItemOrder(
                                date: date.value,
                                newObj: controller.newO,
                                card: controller.listCards[i],
                                listTimes: controller.listTimes,
                              ));
                          controller.getData(date.value);
                        },
                        icon: const Icon(Icons.add),
                      ),
                      title: const Text('рейсы'),
                    ),
                    ExpansionTile(
                      title: const Text('Пойск'),
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: DropList(
                                list: getDate(),
                                type: 'drop',
                                title: 'Дата',
                                initMail: date.value,
                                onPress: (s) {
                                  if (s != null) {
                                    date.value = s;
                                    date.refresh();
                                  }
                                },
                              ),
                            ),
                            Flexible(
                              child: DropList(
                                list: getCards(controller.listCards[i]),
                                type: 'drop',
                                title: 'Промежуточный Маршрут',
                                initMail: cards.value,
                                onPress: (s) {
                                  if (s != null) {
                                    // ignore: avoid_print
                                    print(s);
                                    cards.value = s;
                                    cards.refresh();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        ButtonCustom(
                            onPressed: () {
                              controller.getData(date.value);
                            },
                            title: ' Пойск'),
                        Row(
                          children: [
                            Flexible(
                              child: SwitchListTile(
                                title: const Text('Свободными местами'),
                                onChanged: (v) {
                                  filterOneSend(v);
                                },
                                value: filterOne.value,
                              ),
                            ),
                            Flexible(
                              child: SwitchListTile(
                                title: const Text(
                                    'Свободные только с пассажирами'),
                                onChanged: (v) {
                                  filterFreeSend(v);
                                },
                                value: filterFree.value,
                              ),
                            ),
                            Flexible(
                              child: SwitchListTile(
                                title: const Text('Где нет мест'),
                                onChanged: (v) {
                                  filterTwoSend(v);
                                },
                                value: filterTwo.value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    for (int j = 0; j < controller.listOrders.length; j++)
                      if (controller.listOrders[j].idcards ==
                          controller.listCards[i].id)
                        Visibility(
                          visible: filterOne.value == true
                              ? controller.listOrders[j].countPassagers() <
                                      controller.listOrders[j].countMest!
                                  ? true
                                  : false
                              : filterTwo.value == true
                                  ? controller.listOrders[j].countPassagers() ==
                                          controller.listOrders[j].countMest
                                      ? true
                                      : false
                                  : filterFree.value == true
                                      ? controller.listOrders[j]
                                                      .countPassagers() !=
                                                  0 &&
                                              controller.listOrders[j]
                                                      .countMest! >
                                                  controller.listOrders[j]
                                                      .countPassagers()
                                          ? true
                                          : false
                                      : true,
                          child: ListTile(
                            onTap: () async {
                              await Get.to(() => ItemOrder(
                                    cards: controller.listCards,
                                    controller.listOrders[j],
                                    controller.listDrivers,
                                    controller.removeOpassager,
                                    addpayments: controller.listAddPayment,
                                    onUpdate: controller.getIdhashData,
                                    onRemove: controller.removeO,
                                    onSave: controller.updateO,
                                    onRemoveDriver: controller.removeODriver,
                                    onSaveDriver: controller.newODriver,
                                    onSavePassagers: controller.updateOpassager,
                                    time: controller.getTimes(
                                      controller.listOrders[j].idtimes,
                                    ),
                                    onNewPassagers: () async {
                                      await Get.to(() => NewPassengetsOrder(
                                            cards: cards.value,
                                            time: controller.getTimes(controller
                                                .listOrders[j].idtimes),
                                            card: controller.listCards[i],
                                            order: controller.listOrders[j],
                                            addpayments:
                                                controller.listAddPayment,
                                            newObj: controller.newOpassager,
                                          ));
                                    },
                                  ));
                              controller.getData(date.value);
                            },
                            leading: Text('№ ${controller.listOrders[j].id}'),
                            title: Text(
                                '${getTimeCards(controller.listOrders[j].idtimes, controller.listCards[i]) /*controller.getTimes(controller.listOrders[j].idtimes)*/} ${controller.listOrders[j].date}'),
                            subtitle: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                      'Занято ${controller.listOrders[j].countPassagers()} из ${controller.listOrders[j].countMest}'),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                      'Статус поездки: \n${controller.getStateOrder(controller.listOrders[j])}'),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                      'Водитель: \n${controller.getInfoDriver(controller.listOrders[j])}'),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                      'Заказ с приложения: \n${controller.getStateAppClient(controller.listOrders[j]) == true ? "Да" : "Нет"}'),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                      'Промежуточные: \n${controller.getStateCards(controller.listOrders[j])}'),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                      'Сумма: \n${controller.getMoneyOrder(controller.listOrders[j])}'),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: () async {
                                await Get.to(() => NewPassengetsOrder(
                                      cards: cards.value,
                                      time: controller.getTimes(
                                          controller.listOrders[j].idtimes),
                                      card: controller.listCards[i],
                                      order: controller.listOrders[j],
                                      addpayments: controller.listAddPayment,
                                      newObj: controller.newOpassager,
                                    ));
                                controller.getData(date.value);
                              },
                              icon: const Icon(Icons.person_add),
                            ),
                          ),
                        ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
