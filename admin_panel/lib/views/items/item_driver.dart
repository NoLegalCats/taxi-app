import 'dart:math';

import 'package:admin_panel/models/model_drivers.dart';
import 'package:admin_panel/widgets/button_custom.dart';
import 'package:admin_panel/widgets/drop_company.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ItemDriver extends StatelessWidget {
  ModelDrivers item;
  var list = <String, TextEditingController>{}.obs;
  Future<ModelDrivers?> Function(String? idhash)? onUpdate;
  Future<bool> Function(Map<String, dynamic>)? onSave;
  Future<bool> Function(String? idhash)? onRemove;

  ItemDriver(this.item,
      {super.key, this.onUpdate, this.onSave, this.onRemove}) {
    onInitTextController();
  }

  onInitTextController() {
    //
    list['name'] = TextEditingController(text: item.name);
    list['mobile'] = TextEditingController(text: item.mobile);
    list['password'] = TextEditingController(text: item.password);
    list['carinfo'] = TextEditingController(text: item.carInfo);

    list['count'] = TextEditingController(text: '${item.count ?? 4}');
    list['marka_model'] = TextEditingController(text: item.markaModel);
    list['color'] = TextEditingController(text: item.color);
    list['year'] = TextEditingController(text: '${item.year ?? ''}');
    list['number'] = TextEditingController(text: item.number);
    list.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Водитель ID ${item.id}'),
        actions: [
          IconButton(
            onPressed: () async {
              if (onUpdate != null) {
                ModelDrivers? o = await onUpdate!(item.idhash);
                if (o != null) {
                  item = o;
                }
                onInitTextController();
              }
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
                            bool r = await onRemove!(item.idhash);
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
              DropList(
                list: const ['Работает', 'Заблокирован'],
                type: 'drop',
                title: 'Статус',
                initMail: item.idstate == 1 ? 'Работает' : 'Заблокирован',
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
              TextFieldCustom(
                title: 'Мобильный',
                hintText: '7(999)111-22-33',
                controller: list['mobile'],
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: '+7(###) ###-##-##',
                    filter: {"#": RegExp(r'[0-9]')},
                  ),
                ],
              ),
              TextFieldCustom(
                title: 'Пароль',
                hintText: 'Пароль входа',
                controller: list['password'],
              ),
              TextFieldCustom(
                title: 'О машине',
                hintText: 'Опишите все про машину',
                controller: list['carinfo'],
              ),
              TextFieldCustom(
                title: 'Марка модель',
                hintText: 'ВАЗ 2114',
                controller: list['marka_model'],
              ),
              TextFieldCustom(
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
              TextFieldCustom(
                title: 'Цвет',
                hintText: 'белый',
                controller: list['color'],
              ),
              TextFieldCustom(
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
              TextFieldCustom(
                title: 'Гос. номер',
                hintText: 'к120кк102',
                controller: list['number'],
              ),
              ButtonCustom(
                onPressed: () async {
                  if (onSave != null) {
                    bool r = await onSave!({
                      "car_info": list['carinfo']?.text,
                      "mobile": list['mobile']
                          ?.text
                          .replaceAll(RegExp(r'[^0-9]'), ""),
                      "password": list['password']?.text,
                      "name": list['name']?.text,
                      "idhash": item.idhash,
                      "idstate": item.idstate.toString(),
                      "marka_model": list['marka_model']?.text,
                      "color": list['color']?.text,
                      "year": list['year']?.text,
                      "number": list['number']?.text,
                      "count": list['count']?.text,
                    });
                    if (r == true) {
                      Get.back();
                    }
                  }
                },
                title: 'Готово',
              ),
              const SizedBox(height: 50),
            ],
          )),
    );
  }
}

class NewItemDriver extends StatelessWidget {
  Map<String, TextEditingController> list = {};
  Future<bool> Function(Map<String, dynamic>)? newObj;
  NewItemDriver({super.key, this.newObj}) {
    onInitTextController();
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  onInitTextController() {
    //
    list['name'] = TextEditingController();
    list['mobile'] = TextEditingController();
    list['password'] = TextEditingController(text: generateRandomString(8));
    list['carinfo'] = TextEditingController();
    list['count'] = TextEditingController();
    list['marka_model'] = TextEditingController();
    list['color'] = TextEditingController();
    list['year'] = TextEditingController();
    list['number'] = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание водителя'),
      ),
      body: ListView(
        children: [
          TextFieldCustom(
            title: 'ФИО',
            hintText: '',
            controller: list['name'],
          ),
          TextFieldCustom(
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
          TextFieldCustom(
            title: 'Пароль',
            hintText: 'Пароль входа',
            controller: list['password'],
          ),
          TextFieldCustom(
            title: 'О машине',
            hintText: 'Опишите все про машину',
            controller: list['carinfo'],
          ),
          TextFieldCustom(
            title: 'Марка модель',
            hintText: 'ВАЗ 2114',
            controller: list['marka_model'],
          ),
          TextFieldCustom(
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
          TextFieldCustom(
            title: 'Цвет',
            hintText: 'белый',
            controller: list['color'],
          ),
          TextFieldCustom(
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
          TextFieldCustom(
            title: 'Гос. номер',
            hintText: 'к120кк102',
            controller: list['number'],
          ),
          ButtonCustom(
            onPressed: () async {
              if (newObj != null) {
                bool r = await newObj!({
                  "car_info": list['carinfo']?.text,
                  "mobile":
                      list['mobile']?.text.replaceAll(RegExp(r'[^0-9]'), ""),
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
              }
            },
            title: 'Готово',
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
