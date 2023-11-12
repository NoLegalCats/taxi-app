import 'package:admin_panel/models/model_additional_payment.dart';
import 'package:admin_panel/models/model_cards.dart';
import 'package:admin_panel/models/model_drivers.dart';
import 'package:admin_panel/models/model_order_requests.dart';
import 'package:admin_panel/models/model_orders.dart';
import 'package:admin_panel/models/model_times.dart';
import 'package:admin_panel/widgets/button_custom.dart';
import 'package:admin_panel/widgets/drop_company.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ItemOrder extends StatelessWidget {
  var item = ModelOrders().obs;
  var driver = ''.obs;
  late String? time;
  late List<ModelAdditionalPayment> addpayments;
  var list = <String, TextEditingController>{}.obs;
  List<ModelDrivers> listDrivers;
  List<ModelCards> cards;
  Future<ModelOrders?> Function(String? idhash)? onUpdate;
  Future<bool> Function(Map<String, dynamic>)? onSave;
  Future<bool> Function(Map<String, dynamic>)? onSavePassagers;
  Future<bool> Function(String? idhash)? onRemove;
  Future<bool> Function(String? idhash, int state)? onRemovePassagers;
  Future<bool> Function(String? idorders, String? idhashdrivers)?
      onUpdateDriver;
  Future<bool> Function(Map<String, dynamic>)? onSaveDriver;
  Future<bool> Function(String? idhash)? onRemoveDriver;
  Future Function()? onNewPassagers;
  ItemOrder(ModelOrders itemInit, this.listDrivers, this.onRemovePassagers,
      {super.key,
      this.onNewPassagers,
      this.onUpdate,
      this.onSave,
      this.onRemove,
      this.onSavePassagers,
      required this.addpayments,
      this.onSaveDriver,
      this.onRemoveDriver,
      required this.cards,
      this.time}) {
    item.value = itemInit;
    item.refresh();
    //getInitIdDriver();
    onInitTextController();
  }
  onupdade() async {
    if (onUpdate != null) {
      ModelOrders? o = await onUpdate!(item.value.id.toString());
      if (o != null) {
        item.value = o;
        item.refresh();
      }
      onInitTextController();
    }
  }

  String getInfoStateDriver(int id) {
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

  onInitTextController() {
    getInitIdDriver();
    list['count_mest'] =
        TextEditingController(text: item.value.countMest.toString());
    list['driver_mobile'] =
        TextEditingController(text: item.value.driverMobile);
    list['driver_info'] = TextEditingController(text: item.value.driverInfo);

    list.refresh();
  }

  List<String> getDriver() {
    List<String> l = ['Не выбрано'];
    for (int i = 0; i < listDrivers.length; i++) {
      if (listDrivers[i].idstate == 1) {
        l.add(
            'ID ${listDrivers[i].id} ${listDrivers[i].name}, ${listDrivers[i].mobile}');
      }
    }
    return l;
  }

  String? getInitIdDriver() {
    driver.value = '';
    driver.refresh();
    int? id;
    if (item.value.listOrderDrivers.isNotEmpty) {
      if (item.value.listOrderDrivers.last.idstate != 2) {
        id = item.value.listOrderDrivers.last.iddrivers;
      }
    }
    //print('id $id');

    if (id != null) {
      for (int i = 0; i < listDrivers.length; i++) {
        if (id == listDrivers[i].id) {
          String r =
              'ID ${listDrivers[i].id} ${listDrivers[i].name}, ${listDrivers[i].mobile}';
          driver.value = r;
          driver.refresh();
          //print (r);
          return r;
        }
      }
    }
    return null;
  }

  String? getInfoIdDriver() {
    int? id;
    if (item.value.listOrderDrivers.isNotEmpty) {
      if (item.value.listOrderDrivers.last.idstate != 2) {
        id = item.value.listOrderDrivers.last.iddrivers;
      }
    }
    //print('id $id');

    if (id != null) {
      for (int i = 0; i < listDrivers.length; i++) {
        if (id == listDrivers[i].id) {
          String r =
              'ID ${listDrivers[i].id} ${listDrivers[i].name}, ${listDrivers[i].mobile}\nМашина ${listDrivers[i].markaModel} ${listDrivers[i].color} ${listDrivers[i].number}, мест: ${listDrivers[i].count}';
          //print (r);
          return r;
        }
      }
    }
    return null;
  }

  int? getIdDriver() {
    for (int i = 0; i < listDrivers.length; i++) {
      if (driver.value ==
          'ID ${listDrivers[i].id} ${listDrivers[i].name}, ${listDrivers[i].mobile}') {
        return listDrivers[i].id;
      }
    }
    return null;
  }

  String getStrCardInter(int idcard, int id) {
    for (int i = 0; i < cards.length; i++) {
      if (idcard == cards[i].id) {
        for (int j = 0; j < cards[i].lisIntertCards.length; j++) {
          if (id == cards[i].lisIntertCards[j].id) {
            return 'ожидание ${cards[i].lisIntertCards[j].countMinute} минут, ${cards[i].lisIntertCards[j].inMap}-${cards[i].lisIntertCards[j].outMap}, ${cards[i].lisIntertCards[j].payment} руб';
          }
        }
      }
    }
    return '-';
  }

  String getStrCard(int id) {
    for (int i = 0; i < cards.length; i++) {
      if (id == cards[i].id) {
        return '${cards[i].inMap}-${cards[i].outMap}, ${cards[i].payment} руб';
      }
    }
    return '-';
  }

  int getCardInterMoney(int idcard, int id) {
    for (int i = 0; i < cards.length; i++) {
      if (idcard == cards[i].id) {
        for (int j = 0; j < cards[i].lisIntertCards.length; j++) {
          if (id == cards[i].lisIntertCards[j].id) {
            return cards[i].lisIntertCards[j].payment ?? 0;
          }
        }
      }
    }
    return 0;
  }

  int getCardMoney(int id) {
    for (int i = 0; i < cards.length; i++) {
      if (id == cards[i].id) {
        return cards[i].payment ?? 0;
      }
    }
    return 0;
  }

  int getAddPayMoney(int id) {
    for (int i = 0; i < addpayments.length; i++) {
      if (id == addpayments[i].id) {
        return addpayments[i].payment ?? 0;
      }
    }
    return 0;
  }

  String getAddPayStr(int id) {
    for (int i = 0; i < addpayments.length; i++) {
      if (id == addpayments[i].id) {
        return '${addpayments[i].text} +${addpayments[i].payment} руб';
      }
    }
    return '';
  }

  String getCardsMoneyInfo(int id) {
    for (int i = 0; i < item.value.listOrderRequests.length; i++) {
      if (item.value.listOrderRequests[i].id == id) {
        int dop = 0;
        String dopStr = '';
        if (item.value.listOrderRequests[i].passengers!.idaddPAyment != null) {
          dop = getAddPayMoney(
              item.value.listOrderRequests[i].passengers!.idaddPAyment!);
          dopStr = getAddPayStr(
              item.value.listOrderRequests[i].passengers!.idaddPAyment!);
        }
        if (item.value.listOrderRequests[i].idintermediateCards != null) {
          //item.value.listOrderRequests[i].idintermediateCards
          return '$dopStr${dopStr.isNotEmpty ? '\n' : ''}${getStrCardInter(item.value.listOrderRequests[i].idcards!, item.value.listOrderRequests[i].idintermediateCards!)} = ${((getCardInterMoney(item.value.listOrderRequests[i].idcards!, item.value.listOrderRequests[i].idintermediateCards!) * item.value.listOrderRequests[i].passengers!.count!) + dop)} руб';
        } else {
          //item.value.listOrderRequests[i].idcards
          return '$dopStr${dopStr.isNotEmpty ? '\n' : ''}${getStrCard(item.value.listOrderRequests[i].idcards!)} = ${((getCardMoney(item.value.listOrderRequests[i].idcards!) * item.value.listOrderRequests[i].passengers!.count!) + dop)} руб';
        }
      }
    }
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('№ ${item.value.id}'),
        actions: [
          IconButton(
            onPressed: () async {
              if (onNewPassagers != null) {
                await onNewPassagers!();
                onupdade();
              }
            },
            icon: const Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: () async {
              onupdade();
            },
            icon: const Icon(Icons.update),
          ),
          IconButton(
            onPressed: () async {
              if (onRemove != null) {
                showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return AlertDialog(
                      alignment: Alignment.bottomCenter,
                      clipBehavior: Clip.antiAlias,
                      title: const Text('Уведомление'),
                      content:
                          const Text('Вы действительно хотите удалить запись?'),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            bool r = await onRemove!(item.value.id.toString());
                            if (r == true) {
                              Get.back();
                              Get.back();
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
              }
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Obx(() => ListView(
            children: [
              ListTile(
                title: Text(
                    'Дата и время отпраки по основному маршруту\n$time ${item.value.date}'),
                subtitle: Text(
                    'Дата  создание заказа ${DateFormat('dd.MM.yyyy H:m').format(DateTime.fromMillisecondsSinceEpoch(int.parse(item.value.datetimeCreated!)))}'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  getInfoIdDriver() ?? 'Водитель: -',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              DropList(
                list: getDriver(),
                type: 'drop',
                title: 'Водитель',
                initMail: driver.value,
                onPress: (s) {
                  if (s != null) {
                    driver.value = s;
                    driver.refresh();
                  }
                },
              ),
              Row(
                children: [
                  ButtonCustom(
                    onPressed: () async {
                      if (onSaveDriver != null) {
                        if (getIdDriver() != null) {
                          bool r = await onSaveDriver!({
                            "iddriver": getIdDriver(),
                            "idorders": item.value.id,
                          });
                          if (r == true) {
                            onupdade();
                          }
                        }
                      }
                    },
                    title: 'Назначить водителя',
                  ),
                  ButtonCustom(
                    onPressed: () async {
                      if (onRemoveDriver != null) {
                        bool r = await onRemoveDriver!(
                            item.value.listOrderDrivers.last.id.toString());
                        if (r == true) {
                          onupdade();
                        }
                      }
                    },
                    title: 'Убрать назначение водителя',
                  ),
                ],
              ),
              TextFieldCustom(
                title: 'Кол-во мест',
                hintText: 'кол-мест',
                controller: list['count_mest'],
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: "#",
                    filter: {"#": RegExp(r'[0-9]')},
                  ),
                ],
              ),
              /*TextFieldCustom(
                title: 'Номер водителя',
                hintText: '7(999)111-22-33',
                controller: list['driver_mobile'],
              ),
              TextFieldCustom(
                title: 'Водитель',
                hintText: 'Инфонмация об авто',
                controller: list['driver_info'],
              ),*/
              const SizedBox(height: 20),
              ExpansionTile(
                title: const Text('Пассажиры'),
                children: [
                  for (int i = 0; i < item.value.listOrderRequests.length; i++)
                    ListTile(
                      dense: item.value.listOrderRequests[i].idstate != 2
                          ? false
                          : true,
                      enabled: item.value.listOrderRequests[i].idstate != 2
                          ? true
                          : false,
                      onTap: () async {
                        await Get.to(() => ItemPassegerOrder(
                              item.value.listOrderRequests[i],
                              onSave: onSavePassagers,
                              addpayments: addpayments,
                            ));
                        onupdade();
                      },
                      leading:
                          item.value.listOrderRequests[i].passengers!.idusers !=
                                  null
                              ? const Icon(Icons.mobile_friendly)
                              : const Icon(Icons.window_sharp),
                      title: Text(
                          '${item.value.listOrderRequests[i].passengers?.name}, мест ${item.value.listOrderRequests[i].passengers?.count}'),
                      subtitle: Row(
                        children: [
                          Flexible(
                            child: Text(
                                '${item.value.listOrderRequests[i].passengers?.mobile}, от: ${item.value.listOrderRequests[i].passengers?.inAdress}, до: ${item.value.listOrderRequests[i].passengers?.outAdress}\n${getCardsMoneyInfo(item.value.listOrderRequests[i].id!)}'),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text:
                                      '${item.value.listOrderRequests[i].passengers?.name}, мест ${item.value.listOrderRequests[i].passengers?.count}\n${item.value.listOrderRequests[i].passengers?.mobile}, от: ${item.value.listOrderRequests[i].passengers?.inAdress}, до: ${item.value.listOrderRequests[i].passengers?.outAdress}\n${getCardsMoneyInfo(item.value.listOrderRequests[i].id!)}'));
                            },
                            icon: const Icon(Icons.copy),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          if (item.value.listOrderRequests[i].idstate != 2) {
                            if (onRemovePassagers != null) {
                              bool r = await onRemovePassagers!(
                                  item.value.listOrderRequests[i].id.toString(),
                                  2);
                              if (r == true) {
                                Get.back();
                              }
                            }
                            onupdade();
                          }
                        },
                        icon: const Icon(Icons.delete),
                      ),
                    ),
                ],
              ),
              ExpansionTile(
                title: const Text('Статусы заказа'),
                children: [
                  for (int i = 0; i < item.value.listOrderDrivers.length; i++)
                    ListTile(
                      leading: Text(
                          'ID водителя ${item.value.listOrderDrivers[i].iddrivers}'),
                      title: Text(
                          '"${getInfoStateDriver(item.value.listOrderDrivers[i].idstate!)}"'),
                    ),
                ],
              ),
              Row(
                children: [
                  ButtonCustom(
                    onPressed: () async {
                      Get.back();
                    },
                    title: 'Закрыть',
                  ),
                  ButtonCustom(
                    onPressed: () async {
                      if (onSave != null) {
                        bool r = await onSave!({
                          "count_mest": list['count_mest']?.text,
                          "driver_mobile": list['driver_mobile']?.text,
                          "driver_info": list['driver_info']?.text,
                          "id": item.value.id.toString()
                        });
                        if (r == true) {
                          Get.back();
                        }
                      }
                    },
                    title: 'Готово',
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          )),
    );
  }
}

class ItemPassegerOrder extends StatelessWidget {
  ModelOrderRequests item;
  String addpayment = 'Не выбрано';
  late List<ModelAdditionalPayment> addpayments;
  var list = <String, TextEditingController>{}.obs;
  Future<ModelDrivers?> Function(String? idhash)? onUpdate;
  Future<bool> Function(Map<String, dynamic>)? onSave;
  Future<bool> Function(String? idhash)? onRemove;

  ItemPassegerOrder(
    this.item, {
    super.key,
    this.onUpdate,
    this.onSave,
    this.onRemove,
    required this.addpayments,
  }) {
    onInitTextController();
  }

  List<String> getAddPay() {
    List<String> l = ['Не выбрано'];
    for (int i = 0; i < addpayments.length; i++) {
      l.add('${addpayments[i].text} ${addpayments[i].payment} руб');
    }
    return l;
  }

  String? getStrAddPayment(int? id) {
    if (id != null) {
      for (int i = 0; i < addpayments.length; i++) {
        if (id == addpayments[i].id) {
          return '${addpayments[i].text} ${addpayments[i].payment} руб';
        }
      }
    }
    return null;
  }

  int? getIdAddPay() {
    for (int i = 0; i < addpayments.length; i++) {
      if (addpayment ==
          '${addpayments[i].text} ${addpayments[i].payment} руб') {
        return addpayments[i].id;
      }
    }
    return null;
  }

  onInitTextController() {
    list['in_adress'] = TextEditingController(text: item.passengers?.inAdress);
    list['out_adress'] =
        TextEditingController(text: item.passengers?.outAdress);
    list['info'] = TextEditingController(text: item.passengers?.info);
    list['name'] = TextEditingController(text: item.passengers?.name);
    list['mobile'] = TextEditingController(text: item.passengers?.mobile);
    addpayment =
        getStrAddPayment(item.passengers?.idaddPAyment) ?? 'Не выбрано';
    list.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заказ ID ${item.id}, пассажир ID ${item.passengers?.id}'),
      ),
      body: Obx(() => ListView(
            children: [
              TextFieldCustom(
                title: 'Имя',
                hintText: 'имя пассажира',
                controller: list['name'],
              ),
              TextFieldCustom(
                title: 'адрес от',
                hintText: 'откуда',
                controller: list['in_adress'],
              ),
              TextFieldCustom(
                title: 'адрес до',
                hintText: 'куда',
                controller: list['out_adress'],
              ),
              TextFieldCustom(
                title: 'Доп. инфо',
                hintText: 'дополнительная информация',
                controller: list['info'],
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
              DropList(
                list: getAddPay(),
                type: 'drop',
                title: 'Район города и доп. Опции',
                initMail: addpayment,
                onPress: (s) {
                  if (s != null) {
                    addpayment = s;
                  }
                },
              ),
              Row(
                children: [
                  ButtonCustom(
                    onPressed: () async {
                      Get.back();
                    },
                    title: 'Закрыть',
                  ),
                  ButtonCustom(
                    onPressed: () async {
                      if (onSave != null) {
                        bool r = await onSave!({
                          "in_adress": list['in_adress']?.text,
                          "out_adress": list['out_adress']?.text,
                          "info": list['info']?.text,
                          //"count": list['count']?.text,
                          "name": list['name']?.text,
                          "mobile": list['mobile']
                              ?.text
                              .replaceAll(RegExp(r'[^0-9]'), ""),
                          "id": item.idpassengers.toString(),
                          "additional_payment_idadd_payment":
                              // ignore: prefer_null_aware_operators
                              getIdAddPay() != null
                                  ? getIdAddPay().toString()
                                  : null
                        });
                        if (r == true) {
                          Get.back();
                        }
                      }
                    },
                    title: 'Готово',
                  ),
                ],
              ),
              const SizedBox(height: 50),
            ],
          )),
    );
  }
}

class NewItemOrder extends StatelessWidget {
  List<ModelTimes> listTimes;
  late ModelCards card;
  String date; // = DateFormat('dd-MM-yyyy').format(DateTime.now());
  String time = '';
  String cards = '';
  var full = false.obs;

  Map<String, TextEditingController> list = {};
  Future<bool> Function(Map<String, dynamic>)? newObj;
  NewItemOrder(
      {required this.date,
      super.key,
      this.newObj,
      required this.card,
      required this.listTimes}) {
    time = getTime()[0]; //listTimes[0].minute.toString();
    cards = '${card.inMap} - ${card.outMap}';
    onInitTextController();
  }
  List<String> getDate() {
    List<String> l = [];
    DateTime now = DateTime.now();
    //now = now.add(const Duration(days: -10));
    var formatter = DateFormat('yyyy-MM-dd');
    for (int i = 0; i < 20; i++) {
      l.add(formatter.format(now));
      now = now.add(const Duration(days: 1));
    }
    return l;
  }

  List<String> getTime() {
    List<String> l = [];
    for (int i = 0; i < listTimes.length; i++) {
      String r =
          Duration(minutes: listTimes[i].minute!).toString().substring(0, 5);
      if (r[4] == ':') {
        r = r.substring(0, 4);
      }
      l.add(r);
    }
    return l;
  }

  int? getTimeId(String str) {
    for (int i = 0; i < listTimes.length; i++) {
      String r =
          Duration(minutes: listTimes[i].minute!).toString().substring(0, 5);
      if (r[4] == ':') {
        r = r.substring(0, 4);
      }
      if (r == str) {
        return listTimes[i].id;
      }
    }
    return null;
  }

  onInitTextController() {
    //
    list['date'] = TextEditingController();
    list['count_mest'] = TextEditingController(text: '4');
    list['count_day'] = TextEditingController(text: '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание рейса ${card.inMap} - ${card.outMap}'),
      ),
      body: Obx(
        () => ListView(
          children: [
            DropList(
              list: getDate(),
              type: 'drop',
              title: 'Дата',
              initMail: date,
              onPress: (s) {
                if (s != null) {
                  date = s;
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
            const SizedBox(height: 15),
            SwitchListTile(
              title: const Text('Создать рейсы по всему расписанию'),
              value: full.value,
              onChanged: (v) {
                full.value = v;
                full.refresh();
              },
            ),
            Visibility(
              visible: !full.value,
              child: DropList(
                list: getTime(),
                type: 'drop',
                title: 'Время',
                initMail: time,
                onPress: (s) {
                  if (s != null) {
                    time = s;
                  }
                },
              ),
            ),
            /*DropList(
            list: getCards(),
            type: 'drop',
            title: 'Маршрут',
            initMail: cards,
            onPress: (s) {
              if (s != null) {
                cards = s;
              }
            },
          ),*/
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
            Row(
              children: [
                ButtonCustom(
                  onPressed: () async {
                    Get.back();
                  },
                  title: 'Закрыть',
                ),
                ButtonCustom(
                  onPressed: () async {
                    if (newObj != null) {
                      int c = 1;
                      try {
                        c = int.parse(list['count_day']!.text);
                        c++;
                      } catch (e) {
                        print(e);
                      }

                      for (int j = 0; j < c; j++) {
                        var formatter = DateFormat('yyyy-MM-dd');

                        var d = DateTime.parse(date);
                        d = d.add(Duration(days: j));
                        print(formatter.format(d));

                        if (full.value == true) {
                          for (int i = 0; i < listTimes.length; i++) {
                            await newObj!({
                              "count_mest": list['count_mest']?.text,
                              "date": formatter.format(d),
                              "times_idtimes": listTimes[i].id,
                              "cards_idcards": card.id,
                            });
                          }

                          Get.back();
                        } else {
                          bool r = await newObj!({
                            "count_mest": list['count_mest']?.text,
                            "date": formatter.format(d),
                            "times_idtimes": getTimeId(time),
                            "cards_idcards": card.id,
                          });
                          if (r == true) {
                            Get.back();
                          }
                        }
                      }
                    }
                  },
                  title: 'Готово',
                ),
              ],
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class NewPassengetsOrder extends StatelessWidget {
  late ModelOrders order;
  late ModelCards card;
  late String? time;
  var updInfo = false.obs;
  String cards = '';
  String addpayment = 'Не выбрано';
  late List<ModelAdditionalPayment> addpayments;

  Map<String, TextEditingController> list = {};
  Future<bool> Function(Map<String, dynamic>)? newObj;
  NewPassengetsOrder(
      {required this.addpayments,
      required this.time,
      super.key,
      this.newObj,
      required this.card,
      required this.order,
      required this.cards}) {
    //cards = '${card.inMap} - ${card.outMap}';
    onInitTextController();
  }

  List<String> getCards() {
    List<String> l = ['${card.inMap} - ${card.outMap}'];
    for (int i = 0; i < card.lisIntertCards.length; i++) {
      l.add(
          '${card.lisIntertCards[i].inMap} - ${card.lisIntertCards[i].outMap}');
    }
    return l;
  }

  int? getIdCardsInter() {
    for (int i = 0; i < card.lisIntertCards.length; i++) {
      if (cards ==
          '${card.lisIntertCards[i].inMap} - ${card.lisIntertCards[i].outMap}') {
        return card.lisIntertCards[i].id;
      }
    }
    return null;
  }

  List<String> getAddPay() {
    List<String> l = ['Не выбрано'];
    for (int i = 0; i < addpayments.length; i++) {
      l.add('${addpayments[i].text} ${addpayments[i].payment} руб');
    }
    return l;
  }

  int? getIdAddPay() {
    for (int i = 0; i < addpayments.length; i++) {
      if (addpayment ==
          '${addpayments[i].text} ${addpayments[i].payment} руб') {
        return addpayments[i].id;
      }
    }
    return null;
  }

  onInitTextController() {
    //
    list['in_adress'] = TextEditingController();
    list['out_adress'] = TextEditingController();
    list['info'] = TextEditingController();
    list['count'] = TextEditingController(text: '1');
    list['name'] = TextEditingController();
    list['mobile'] = TextEditingController();
  }

  String getStrCardInter(int id) {
    for (int j = 0; j < card.lisIntertCards.length; j++) {
      if (id == card.lisIntertCards[j].id) {
        return 'ожидание ${card.lisIntertCards[j].countMinute} минут'; //, ${card.lisIntertCards[j].inMap}-${card.lisIntertCards[j].outMap}, ${card.lisIntertCards[j].payment} руб';
      }
    }
    return '-';
  }

  String getStrCard() {
    return '${card.inMap}-${card.outMap}, ${card.payment} руб';
  }

  int getCardInterMoney(int id) {
    for (int j = 0; j < card.lisIntertCards.length; j++) {
      if (id == card.lisIntertCards[j].id) {
        return card.lisIntertCards[j].payment ?? 0;
      }
    }
    return 0;
  }

  int getCardMoney() {
    return card.payment ?? 0;
  }

  int getAddPayMoney(int id) {
    for (int i = 0; i < addpayments.length; i++) {
      if (id == addpayments[i].id) {
        return addpayments[i].payment ?? 0;
      }
    }
    return 0;
  }

  String getAddPayStr(int id) {
    for (int i = 0; i < addpayments.length; i++) {
      if (id == addpayments[i].id) {
        return '${addpayments[i].text} +${addpayments[i].payment} руб';
      }
    }
    return '';
  }

  String getInfoMoney() {
    int res = 0;
    int? r = getIdCardsInter();
    if (list['count']!.text.isNotEmpty) {
      if (r != null) {
        int m = getCardInterMoney(r);
        res = m * int.parse(list['count']!.text);
      } else {
        int m = getCardMoney();
        res = m * int.parse(list['count']!.text);
      }
      int? r2 = getIdAddPay();
      if (r2 != null) {
        int m1 = getAddPayMoney(r2);
        res += m1;
      }
    }
    //                  " getIdCardsInter(),
    //  " getIdAddPay()
    return '$res руб';
  }

  upd() {
    updInfo.value = !updInfo.value;
    updInfo.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Создание пассажира ${card.inMap} - ${card.outMap}'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Text('№ ${order.id}'),
            title: Text(
                'Дата и время отпраки по основному маршруту\n$time ${order.date}'),
            subtitle: Text(
                'Дата  создание заказа ${DateFormat('dd.MM.yyyy H:m').format(DateTime.fromMillisecondsSinceEpoch(int.parse(order.datetimeCreated!)))}'),
          ),
          DropList(
            list: getCards(),
            type: 'drop',
            title: 'Маршрут',
            initMail: cards,
            onPress: (s) {
              if (s != null) {
                cards = s;
              }
            },
          ),
          TextFieldCustom(
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
              upd();
            },
          ),
          TextFieldCustom(
            title: 'Имя',
            hintText: 'имя пассажира',
            controller: list['name'],
          ),
          TextFieldCustom(
            title: 'адрес от',
            hintText: 'откуда',
            controller: list['in_adress'],
          ),
          TextFieldCustom(
            title: 'адрес до',
            hintText: 'куда',
            controller: list['out_adress'],
          ),
          TextFieldCustom(
            title: 'Доп. инфо',
            hintText: 'дополнительная информация',
            controller: list['info'],
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
          DropList(
            list: getAddPay(),
            type: 'drop',
            title: 'Район города и доп. Опции',
            //initMail: cards,
            onPress: (s) {
              if (s != null) {
                addpayment = s;
              }
              print('object');
              upd();
            },
          ),
          Obx(
            () => ListTile(
              enabled: updInfo.value,
              title: Text(
                'Итого ${getInfoMoney()}',
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
          Row(
            children: [
              ButtonCustom(
                onPressed: () async {
                  Get.back();
                },
                title: 'Закрыть',
              ),
              ButtonCustom(
                onPressed: () async {
                  if (newObj != null) {
                    bool r = await newObj!({
                      "in_adress": list['in_adress']?.text,
                      "out_adress": list['out_adress']?.text,
                      "info": list['info']?.text,
                      "count": list['count']?.text,
                      "name": list['name']?.text,
                      "mobile": list['mobile']
                          ?.text
                          .replaceAll(RegExp(r'[^0-9]'), ""),
                      "cards_idcards": order.idcards,
                      "times_idtimes": order.idtimes,
                      "orders_idorders": order.id,
                      "intermediate_cards_idintermediate_cards":
                          getIdCardsInter(),
                      "additional_payment_idadd_payment": getIdAddPay()
                    });
                    if (r == true) {
                      Get.back();
                    }
                  }
                },
                title: 'Готово',
              ),
            ],
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
