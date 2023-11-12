import 'dart:math';

import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/controllers/controllers_drivers.dart';
import 'package:admin_panel/models/model_drivers.dart';
import 'package:admin_panel/views/items/item_driver.dart';
import 'package:admin_panel/views/view_map_drivers.dart';
import 'package:admin_panel/widgets/drop_company.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ViewDrivers extends StatelessWidget {
  final controller = Get.put(DriversController());
  var degress = '0'.obs;

  List<String> listDegress() {
    List<String> l = ['0'];
    for (int i = 1; i < 101; i++) {
      l.add(i.toString());
    }
    return l;
  }

  String getSummDegress(String s) {
    try {
      if (s != '0' && degress.value != '0') {
        return ((int.parse(s) / 100) * int.parse(degress.value)).toString();
      }
      return '0';
    } catch (e) {
      return 'error';
    }
  }

  ViewDrivers({super.key});
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    if (AppConfig.mobile == true) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Водители'),
          actions: [
            IconButton(
              onPressed: () async {
                Map<String, TextEditingController> list = {};
                Future<bool> Function(Map<String, dynamic>) newObj =
                    controller.newO;
                list['name'] = TextEditingController();
                list['mobile'] = TextEditingController();
                list['password'] =
                    TextEditingController(text: generateRandomString(8));
                list['carinfo'] = TextEditingController(text: '0');
                list['count'] = TextEditingController();
                list['marka_model'] = TextEditingController();
                list['color'] = TextEditingController();
                list['year'] = TextEditingController();
                list['number'] = TextEditingController();
                await showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return SimpleDialog(
                      insetPadding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      title: const Text('Добавить водителя'),
                      children: [
                        TextFieldCustom(
                          title: 'ФИО',
                          hintText: '',
                          controller: list['name'],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFieldCustom(
                                title: 'Мобильный',
                                hintText: '+7(999)111-22-33',
                                controller: list['mobile'],
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: '+7(###) ###-##-##',
                                    filter: {"#": RegExp(r'[0-9]')},
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: TextFieldCustom(
                                title: 'Пароль',
                                hintText: 'Пароль входа',
                                controller: list['password'],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFieldCustom(
                                title: 'Баланс',
                                hintText: '100',
                                controller: list['carinfo'],
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: '######',
                                    filter: {"#": RegExp('[-0-9]')},
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: TextFieldCustom(
                                title: 'Кол-во мест',
                                hintText: '4',
                                controller: list['count'],
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: "#",
                                    filter: {"#": RegExp(r'[0-9]')},
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFieldCustom(
                                title: 'Марка модель',
                                hintText: 'ВАЗ 2114',
                                controller: list['marka_model'],
                              ),
                            ),
                            Flexible(
                              child: TextFieldCustom(
                                title: 'Цвет',
                                hintText: 'белый',
                                controller: list['color'],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextFieldCustom(
                                title: 'Гос. номер',
                                hintText: 'к120кк102',
                                controller: list['number'],
                              ),
                            ),
                            Flexible(
                              child: TextFieldCustom(
                                title: 'Год выпуска',
                                hintText: '1999',
                                controller: list['year'],
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: "####",
                                    filter: {"#": RegExp(r'[0-9]')},
                                  ),
                                ],
                              ),
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
                                    const EdgeInsets.only(left: 20, right: 20),
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
                                  "car_info": list['carinfo']?.text,
                                  "mobile": list['mobile']
                                      ?.text
                                      .replaceAll(RegExp(r'[^0-9]'), ""),
                                  "password": list['password']?.text,
                                  "name": list['name']?.text,
                                  "marka_model": list['marka_model']?.text,
                                  "color": list['color']?.text,
                                  "year": list['year']?.text,
                                  "number": list['number']?.text,
                                  "count": list['count']?.text,
                                });
                                if (r == true) {
                                  Get.back();
                                }
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
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
                controller.getData();
              },
              color: const Color(0xff819fb9),
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                controller.getData();
              },
              color: const Color(0xff819fb9),
              icon: const Icon(Icons.update),
            ),
          ],
        ),
        body: Obx(() => ListView(
              children: [
                for (int i = 0; i < controller.list.length; i++)
                  ExpansionTile(
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    collapsedBackgroundColor:
                        i.isEven == true ? Colors.white : Colors.grey[200],
                    backgroundColor:
                        i.isEven == true ? Colors.white : Colors.grey[200],
                    leading: Text('№ ${controller.list[i].id}'),
                    title: Text('${controller.list[i].name}'),
                    subtitle: Text('${controller.list[i].mobile}'),
                    children: [
                      //
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MapDriver()));
                          },
                              child: Text("Посмотреть где водитель", style: TextStyle(color:  const Color(0xff205CBE)),)),
                          const Spacer(),
                          IconButton(
                            color: const Color(0xff205CBE),
                            onPressed: () async {
                              //
                              ModelDrivers item = controller.list[i];
                              var list = <String, TextEditingController>{}.obs;
                              Future<ModelDrivers?> Function(String? idhash)
                                  onUpdate = controller.getIdhashData;
                              Future<bool> Function(Map<String, dynamic>)?
                                  onSave = controller.updateO;
                              list['name'] =
                                  TextEditingController(text: item.name);
                              list['mobile'] =
                                  TextEditingController(text: item.mobile);
                              list['password'] =
                                  TextEditingController(text: item.password);
                              list['carinfo'] =
                                  TextEditingController(text: item.carInfo);

                              list['count'] = TextEditingController(
                                  text: '${item.count ?? 4}');
                              list['marka_model'] =
                                  TextEditingController(text: item.markaModel);
                              list['color'] =
                                  TextEditingController(text: item.color);
                              list['year'] = TextEditingController(
                                  text: '${item.year ?? ''}');
                              list['number'] =
                                  TextEditingController(text: item.number);
                              list.refresh();
                              await showDialog(
                                context: Get.context!,
                                builder: (context) {
                                  return SimpleDialog(
                                    insetPadding: const EdgeInsets.all(5),
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.antiAlias,
                                    title: Text(
                                        'Редактирование водителя ID${item.id}'),
                                    children: [
                                      SizedBox(
                                        width: 500,
                                        height: 550,
                                        child: ListView(
                                          children: [
                                            DropList(
                                              list: const [
                                                'Работает',
                                                'Заблокирован'
                                              ],
                                              type: 'drop',
                                              title: 'Статус',
                                              initMail: item.idstate == 1
                                                  ? 'Работает'
                                                  : 'Заблокирован',
                                              onPress: (s) {
                                                if (s == 'Работает') {
                                                  item.idstate = 1;
                                                }
                                                if (s == 'Заблокирован') {
                                                  item.idstate = 3;
                                                }
                                              },
                                            ),
                                            TextFieldCustom(
                                              title: 'ФИО',
                                              hintText: '',
                                              controller: list['name'],
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: TextFieldCustom(
                                                    title: 'Мобильный',
                                                    hintText: '7(999)111-22-33',
                                                    controller: list['mobile'],
                                                    inputFormatters: [
                                                      MaskTextInputFormatter(
                                                        mask:
                                                            '+7(###) ###-##-##',
                                                        filter: {
                                                          "#": RegExp(r'[0-9]')
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: TextFieldCustom(
                                                    title: 'Пароль',
                                                    hintText: 'Пароль входа',
                                                    controller:
                                                        list['password'],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: TextFieldCustom(
                                                    title: 'Баланс',
                                                    hintText: '100',
                                                    controller: list['carinfo'],
                                                    inputFormatters: [
                                                      MaskTextInputFormatter(
                                                        mask: '######',
                                                        filter: {
                                                          "#": RegExp('[-0-9]')
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 150,
                                                  child: TextFieldCustom(
                                                    title: 'Кол-во мест',
                                                    hintText: '4',
                                                    controller: list['count'],
                                                    inputFormatters: [
                                                      MaskTextInputFormatter(
                                                        mask: "#",
                                                        filter: {
                                                          "#": RegExp(r'[0-9]')
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: TextFieldCustom(
                                                    title: 'Марка модель',
                                                    hintText: 'ВАЗ 2114',
                                                    controller:
                                                        list['marka_model'],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: TextFieldCustom(
                                                    title: 'Цвет',
                                                    hintText: 'белый',
                                                    controller: list['color'],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Flexible(
                                                  child: TextFieldCustom(
                                                    title: 'Гос. номер',
                                                    hintText: 'к120кк102',
                                                    controller: list['number'],
                                                  ),
                                                ),
                                                Flexible(
                                                  child: TextFieldCustom(
                                                    title: 'Год выпуска',
                                                    hintText: '1999',
                                                    controller: list['year'],
                                                    inputFormatters: [
                                                      MaskTextInputFormatter(
                                                        mask: "####",
                                                        filter: {
                                                          "#": RegExp(r'[0-9]')
                                                        },
                                                      ),
                                                    ],
                                                  ),
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
                                                      color: Color(0xff819fb9),
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
                                                    bool r = await onSave({
                                                      "car_info":
                                                          list['carinfo']?.text,
                                                      "mobile": list['mobile']
                                                          ?.text
                                                          .replaceAll(
                                                              RegExp(r'[^0-9]'),
                                                              ""),
                                                      "password":
                                                          list['password']
                                                              ?.text,
                                                      "name":
                                                          list['name']?.text,
                                                      "idhash": item.idhash,
                                                      "idstate": item.idstate
                                                          .toString(),
                                                      "marka_model":
                                                          list['marka_model']
                                                              ?.text,
                                                      "color":
                                                          list['color']?.text,
                                                      "year":
                                                          list['year']?.text,
                                                      "number":
                                                          list['number']?.text,
                                                      "count":
                                                          list['count']?.text,
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
                                                      color: Color(0xff205CBE),
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              controller.getData();
                            },
                            icon: const Icon(Icons.create),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            color: const Color(0xff205CBE),
                            onPressed: () async {
                              await showDialog(
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
                                              controller.list[i].idhash);
                                          if (r == true) {
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
                              controller.getData();
                            },
                            icon: const Icon(Icons.delete_outlined),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
              ],
            )),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Водители',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 28,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.getData();
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
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () async {
                    Map<String, TextEditingController> list = {};
                    Future<bool> Function(Map<String, dynamic>) newObj =
                        controller.newO;
                    list['name'] = TextEditingController();
                    list['mobile'] = TextEditingController();
                    list['password'] =
                        TextEditingController(text: generateRandomString(8));
                    list['carinfo'] = TextEditingController(text: '0');
                    list['count'] = TextEditingController();
                    list['marka_model'] = TextEditingController();
                    list['color'] = TextEditingController();
                    list['year'] = TextEditingController();
                    list['number'] = TextEditingController();
                    await showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return SimpleDialog(
                          alignment: Alignment.center,
                          clipBehavior: Clip.antiAlias,
                          title: const Text('Добавить водителя'),
                          children: [
                            TextFieldCustom(
                              title: 'ФИО',
                              hintText: '',
                              controller: list['name'],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextFieldCustom(
                                    title: 'Мобильный',
                                    hintText: '+7(999)111-22-33',
                                    controller: list['mobile'],
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: '+7(###) ###-##-##',
                                        filter: {"#": RegExp(r'[0-9]')},
                                      ),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: TextFieldCustom(
                                    title: 'Пароль',
                                    hintText: 'Пароль входа',
                                    controller: list['password'],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextFieldCustom(
                                    title: 'Баланс',
                                    hintText: '100',
                                    controller: list['carinfo'],
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: '######',
                                        filter: {"#": RegExp('[-0-9]')},
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: TextFieldCustom(
                                    title: 'Кол-во мест',
                                    hintText: '4',
                                    controller: list['count'],
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: "#",
                                        filter: {"#": RegExp(r'[0-9]')},
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextFieldCustom(
                                    title: 'Марка модель',
                                    hintText: 'ВАЗ 2114',
                                    controller: list['marka_model'],
                                  ),
                                ),
                                Flexible(
                                  child: TextFieldCustom(
                                    title: 'Цвет',
                                    hintText: 'белый',
                                    controller: list['color'],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: TextFieldCustom(
                                    title: 'Гос. номер',
                                    hintText: 'к120кк102',
                                    controller: list['number'],
                                  ),
                                ),
                                Flexible(
                                  child: TextFieldCustom(
                                    title: 'Год выпуска',
                                    hintText: '1999',
                                    controller: list['year'],
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: "####",
                                        filter: {"#": RegExp(r'[0-9]')},
                                      ),
                                    ],
                                  ),
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
                                    bool r = await newObj({
                                      "car_info": list['carinfo']?.text,
                                      "mobile": list['mobile']
                                          ?.text
                                          .replaceAll(RegExp(r'[^0-9]'), ""),
                                      "password": list['password']?.text,
                                      "name": list['name']?.text,
                                      "marka_model": list['marka_model']?.text,
                                      "color": list['color']?.text,
                                      "year": list['year']?.text,
                                      "number": list['number']?.text,
                                      "count": list['count']?.text,
                                    });
                                    if (r == true) {
                                      Get.back();
                                    }
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
                    controller.getData();
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
                            'Добавить водителя',
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
                columnWidths: const {
                  0: FixedColumnWidth(30),
                  1: FixedColumnWidth(300), //FlexColumnWidth(),
                  2: FixedColumnWidth(80), //FlexColumnWidth(),
                  3: FixedColumnWidth(120), //FlexColumnWidth(),
                  4: FixedColumnWidth(200), //FlexColumnWidth(),
                  5: FixedColumnWidth(150), //FlexColumnWidth(),
                  6: FixedColumnWidth(200),
                },
                children: [
                  TableRow(
                    children: [
                      const SizedBox(
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
                      const SizedBox(
                        child: Center(
                          child: Text(
                            'ФИО/Телефон',
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
                              'Баланс\n($degress %)',
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
                      const SizedBox(
                        child: Center(
                          child: Text(
                            'Пароль',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff80A0B9),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        child: Center(
                          child: Text(
                            'Параметры машины',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff80A0B9),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        child: Center(
                          child: Text(
                            'Кол-во мест',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff80A0B9),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        child: Center(
                          child: Text(
                            'Статус',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xff80A0B9),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
                      /*
                      1: IntrinsicColumnWidth(),
                      2: IntrinsicColumnWidth(),
                      3: FlexColumnWidth(),
                      */
                      0: FixedColumnWidth(30),
                      1: IntrinsicColumnWidth(), //FlexColumnWidth(),
                      2: IntrinsicColumnWidth(), //FlexColumnWidth(),
                      3: IntrinsicColumnWidth(), //FlexColumnWidth(),
                      4: IntrinsicColumnWidth(), //FlexColumnWidth(),
                      5: IntrinsicColumnWidth(), //FlexColumnWidth(),
                      6: IntrinsicColumnWidth(), //FlexColumnWidth(),
                      //7: FixedColumnWidth(120), //FlexColumnWidth(),
                      //8: FixedColumnWidth(280) //IntrinsicColumnWidth(),
                    },
                    children: [
                      TableRow(
                        children: [
                          const SizedBox(
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
                          const SizedBox(
                            child: Center(
                              child: Text(
                                'ФИО/Телефон',
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
                                  'Баланс\n($degress %)',
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
                          const SizedBox(
                            child: Center(
                              child: Text(
                                'Пароль',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xff80A0B9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            child: Center(
                              child: Text(
                                'Параметры машины',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xff80A0B9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            child: Center(
                              child: Text(
                                'Кол-во мест',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xff80A0B9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            child: Center(
                              child: Text(
                                'Статус',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xff80A0B9),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      for (int j = 0; j < controller.list.length; j++)
                        TableRow(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Text(
                                '${controller.list[j].id}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393939),
                                ),
                              ),
                            ),
                            Text(
                              '${controller.list[j].name}\n${controller.list[j].mobile}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393939),
                              ),
                            ),
                            Text(
                              '${controller.list[j].carInfo} р\n ${getSummDegress(controller.list[j].carInfo!)} р (%)',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393939),
                              ),
                            ),
                            Text(
                              '${controller.list[j].password}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff205CBE),
                              ),
                            ),
                            Text(
                              '${controller.list[j].markaModel}/${controller.list[j].color}\n${controller.list[j].number}/${controller.list[j].year} г.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393939),
                              ),
                            ),
                            Text(
                              '${controller.list[j].count}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393939),
                              ),
                            ),
                            Row(
                              //crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${controller.list[j].idstate == 1 ? 'Работает' : 'Заблокирован'} ',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff393939),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  color: const Color(0xff205CBE),
                                  onPressed: () async {
                                    //
                                    ModelDrivers item = controller.list[j];
                                    var list =
                                        <String, TextEditingController>{}.obs;
                                    Future<ModelDrivers?> Function(
                                            String? idhash) onUpdate =
                                        controller.getIdhashData;
                                    Future<bool> Function(Map<String, dynamic>)?
                                        onSave = controller.updateO;
                                    list['name'] =
                                        TextEditingController(text: item.name);
                                    list['mobile'] = TextEditingController(
                                        text: item.mobile);
                                    list['password'] = TextEditingController(
                                        text: item.password);
                                    list['carinfo'] = TextEditingController(
                                        text: item.carInfo);

                                    list['count'] = TextEditingController(
                                        text: '${item.count ?? 4}');
                                    list['marka_model'] = TextEditingController(
                                        text: item.markaModel);
                                    list['color'] =
                                        TextEditingController(text: item.color);
                                    list['year'] = TextEditingController(
                                        text: '${item.year ?? ''}');
                                    list['number'] = TextEditingController(
                                        text: item.number);
                                    list.refresh();
                                    await showDialog(
                                      context: Get.context!,
                                      builder: (context) {
                                        return SimpleDialog(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.antiAlias,
                                          title: Text(
                                              'Редактирование водителя ID${item.id}'),
                                          children: [
                                            SizedBox(
                                              width: 500,
                                              height: 550,
                                              child: ListView(
                                                children: [
                                                  DropList(
                                                    list: const [
                                                      'Работает',
                                                      'Заблокирован'
                                                    ],
                                                    type: 'drop',
                                                    title: 'Статус',
                                                    initMail: item.idstate == 1
                                                        ? 'Работает'
                                                        : 'Заблокирован',
                                                    onPress: (s) {
                                                      if (s == 'Работает') {
                                                        item.idstate = 1;
                                                      }
                                                      if (s == 'Заблокирован') {
                                                        item.idstate = 3;
                                                      }
                                                    },
                                                  ),
                                                  TextFieldCustom(
                                                    title: 'ФИО',
                                                    hintText: '',
                                                    controller: list['name'],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: TextFieldCustom(
                                                          title: 'Мобильный',
                                                          hintText:
                                                              '7(999)111-22-33',
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
                                                      ),
                                                      Flexible(
                                                        child: TextFieldCustom(
                                                          title: 'Пароль',
                                                          hintText:
                                                              'Пароль входа',
                                                          controller:
                                                              list['password'],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: TextFieldCustom(
                                                          title: 'Баланс',
                                                          hintText: '100',
                                                          controller:
                                                              list['carinfo'],
                                                          inputFormatters: [
                                                            MaskTextInputFormatter(
                                                              mask: '######',
                                                              filter: {
                                                                "#": RegExp(
                                                                    '[-0-9]')
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: TextFieldCustom(
                                                          title: 'Кол-во мест',
                                                          hintText: '4',
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
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: TextFieldCustom(
                                                          title: 'Марка модель',
                                                          hintText: 'ВАЗ 2114',
                                                          controller: list[
                                                              'marka_model'],
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: TextFieldCustom(
                                                          title: 'Цвет',
                                                          hintText: 'белый',
                                                          controller:
                                                              list['color'],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Flexible(
                                                        child: TextFieldCustom(
                                                          title: 'Гос. номер',
                                                          hintText: 'к120кк102',
                                                          controller:
                                                              list['number'],
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: TextFieldCustom(
                                                          title: 'Год выпуска',
                                                          hintText: '1999',
                                                          controller:
                                                              list['year'],
                                                          inputFormatters: [
                                                            MaskTextInputFormatter(
                                                              mask: "####",
                                                              filter: {
                                                                "#": RegExp(
                                                                    r'[0-9]')
                                                              },
                                                            ),
                                                          ],
                                                        ),
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
                                                              style: TextStyle(
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
                                                      GestureDetector(
                                                        onTap: () async {
                                                          bool r =
                                                              await onSave({
                                                            "car_info":
                                                                list['carinfo']
                                                                    ?.text,
                                                            "mobile": list[
                                                                    'mobile']
                                                                ?.text
                                                                .replaceAll(
                                                                    RegExp(
                                                                        r'[^0-9]'),
                                                                    ""),
                                                            "password":
                                                                list['password']
                                                                    ?.text,
                                                            "name": list['name']
                                                                ?.text,
                                                            "idhash":
                                                                item.idhash,
                                                            "idstate": item
                                                                .idstate
                                                                .toString(),
                                                            "marka_model": list[
                                                                    'marka_model']
                                                                ?.text,
                                                            "color":
                                                                list['color']
                                                                    ?.text,
                                                            "year": list['year']
                                                                ?.text,
                                                            "number":
                                                                list['number']
                                                                    ?.text,
                                                            "count":
                                                                list['count']
                                                                    ?.text,
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
                                                                  right: 20),
                                                          height: 50,
                                                          width: 200,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: Color(
                                                                0xff205CBE),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                              Radius.circular(
                                                                  15),
                                                            ),
                                                          ),
                                                          child: const Center(
                                                            child: Text(
                                                              'Готово',
                                                              style: TextStyle(
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
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    controller.getData();
                                  },
                                  icon: const Icon(Icons.create),
                                ),
                                IconButton(
                                  color: const Color(0xff205CBE),
                                  onPressed: () async {
                                    await showDialog(
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
                                                        .list[j].idhash);
                                                if (r == true) {
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
                                    controller.getData();
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

class ViewDrivers2 extends StatelessWidget {
  final controller = Get.put(DriversController());

  ViewDrivers2({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Водители'),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(() => NewItemDriver(
                    newObj: controller.newO,
                  ));
              controller.getData();
            },
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {
              controller.getData();
            },
            icon: const Icon(Icons.update),
          ),
        ],
      ),
      body: Obx(
        () => ListView(
          children: [
            for (int i = 0; i < controller.list.length; i++)
              ListTile(
                onTap: () async {
                  await Get.to(() => ItemDriver(
                        controller.list[i],
                        onSave: controller.updateO,
                        onRemove: controller.removeO,
                        onUpdate: controller.getIdhashData,
                      ));
                  controller.getData();
                },
                title: Text('${controller.list[i].name}'),
                subtitle: Text('${controller.list[i].mobile}'),
                leading: Text(
                  '№ ${controller.list[i].id}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
