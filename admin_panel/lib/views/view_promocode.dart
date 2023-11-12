import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/controllers/controller_promocode.dart';
import 'package:admin_panel/controllers/controllers_times.dart';
import 'package:admin_panel/views/items/item_times.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ViewPromocode extends StatelessWidget {
  final controller = Get.put(PromocodeController());

  ViewPromocode({super.key});
  @override
  Widget build(BuildContext context) {
    if (AppConfig.mobile == true) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Промокоды'),
          actions: [
            IconButton(
              onPressed: () async {
                Map<String, TextEditingController> list = {};
                Future<bool> Function(Map<String, dynamic>) newObj =
                    controller.newO;
                list['name'] = TextEditingController();
                list['code'] = TextEditingController();
                list['degres'] = TextEditingController();
                list['payment'] = TextEditingController();
                list['count'] = TextEditingController();

                await showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return SimpleDialog(
                      alignment: Alignment.center,
                      insetPadding: const EdgeInsets.all(5),
                      clipBehavior: Clip.antiAlias,
                      title: const Text('Добавить промокод'),
                      children: [
                        SizedBox(
                          height: Get.height - 150,
                          width: Get.width - 10,
                          child: ListView(
                            children: [
                              TextFieldCustom(
                                title: 'Краткое название',
                                hintText: 'Промо тест',
                                controller: list['name'],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: TextFieldCustom(
                                      title: 'Промокод',
                                      hintText: 'PROMOWIN',
                                      controller: list['code'],
                                    ),
                                  ),
                                  Flexible(
                                    child: TextFieldCustom(
                                      title: 'Кол-во использования',
                                      hintText: '3',
                                      controller: list['count'],
                                      inputFormatters: [
                                        MaskTextInputFormatter(
                                          mask: '###',
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
                                      title: '% скидки',
                                      hintText: '0',
                                      controller: list['degres'],
                                      inputFormatters: [
                                        MaskTextInputFormatter(
                                          mask: '###',
                                          filter: {"#": RegExp(r'[0-9]')},
                                        ),
                                      ],
                                    ),
                                  ),
                                  Flexible(
                                    child: TextFieldCustom(
                                      title: 'Cкидка в руб',
                                      hintText: '100',
                                      controller: list['payment'],
                                      inputFormatters: [
                                        MaskTextInputFormatter(
                                          mask: '######',
                                          filter: {"#": RegExp(r'[0-9]')},
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                                  "name": list['name']?.text,
                                  "code": list['code']?.text,
                                  "degres": int.parse(list['degres']!.text),
                                  "payment": int.parse(list['payment']!.text),
                                  "count": int.parse(list['count']!.text),
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
        body: Obx(
          () => ListView(
            //isEven
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
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text('Название'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      child: TextField(
                        controller: TextEditingController(
                            text: '${controller.list[i].name}'),
                        onChanged: (v) {
                          controller.list[i].name = v;
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text('Код'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      child: TextField(
                        controller: TextEditingController(
                            text: '${controller.list[i].code}'),
                        onChanged: (v) {
                          controller.list[i].code = v;
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text('Скидка в %'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      child: TextField(
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '####',
                            filter: {"#": RegExp(r'[0-9]')},
                          ),
                        ],
                        controller: TextEditingController(
                            text: '${controller.list[i].degres}'),
                        onChanged: (v) {
                          if (v.length != 0) {
                            controller.list[i].degres = int.parse(v);
                          } else {
                            controller.list[i].degres = 0;
                          }
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text('Скидка в руб'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      child: TextField(
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '#######',
                            filter: {"#": RegExp(r'[0-9]')},
                          ),
                        ],
                        controller: TextEditingController(
                            text: '${controller.list[i].payment}'),
                        onChanged: (v) {
                          if (v.length != 0) {
                            controller.list[i].payment = int.parse(v);
                          } else {
                            controller.list[i].payment = 0;
                          }
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text('Кол-во использования'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 15),
                      child: TextField(
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '####',
                            filter: {"#": RegExp(r'[0-9]')},
                          ),
                        ],
                        controller: TextEditingController(
                            text: '${controller.list[i].count}'),
                        onChanged: (v) {
                          if (v.length != 0) {
                            controller.list[i].count = int.parse(v);
                          } else {
                            controller.list[i].count = 0;
                          }
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text('Статус выкл/вкл'),
                    ),
                    Switch(
                      value: controller.list[i].active == 1 ? true : false,
                      onChanged: (v) {
                        controller.list[i].active = v == true ? 1 : 2;
                        controller.list.refresh();
                      },
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          color: const Color(0xff205CBE),
                          onPressed: () async {
                            var r = await controller.updateO({
                              "id": controller.list[i].id.toString(),
                              "name": controller.list[i].name.toString(),
                              "code": controller.list[i].code.toString(),
                              "active": controller.list[i].active.toString(),
                              "degres": controller.list[i].degres.toString(),
                              "payment": controller.list[i].payment.toString(),
                              "count": controller.list[i].count.toString(),
                              //"minute":
                              //  controller.list[i].minute.toString(),
                            });
                            if (r == true) {
                              controller.getData();
                            }
                          },
                          icon: const Icon(Icons.save),
                        ),
                        const SizedBox(height: 15),
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
                                            controller.list[i].id.toString());
                                        if (r == true) {
                                          Get.back();
                                          controller.getData();
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
                        const SizedBox(height: 15),
                      ],
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Промокоды',
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
                    list['code'] = TextEditingController();
                    list['degres'] = TextEditingController();
                    list['payment'] = TextEditingController();
                    list['count'] = TextEditingController();

                    await showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return SimpleDialog(
                          alignment: Alignment.center,
                          clipBehavior: Clip.antiAlias,
                          title: const Text('Добавить промокод'),
                          children: [
                            SizedBox(
                              height: 250,
                              width: 500,
                              child: ListView(
                                children: [
                                  TextFieldCustom(
                                    title: 'Краткое название',
                                    hintText: 'Промо тест',
                                    controller: list['name'],
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: TextFieldCustom(
                                          title: 'Промокод',
                                          hintText: 'PROMOWIN',
                                          controller: list['code'],
                                        ),
                                      ),
                                      Flexible(
                                        child: TextFieldCustom(
                                          title: 'Кол-во использования',
                                          hintText: '3',
                                          controller: list['count'],
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                              mask: '###',
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
                                          title: '% скидки',
                                          hintText: '0',
                                          controller: list['degres'],
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                              mask: '###',
                                              filter: {"#": RegExp(r'[0-9]')},
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        child: TextFieldCustom(
                                          title: 'Cкидка в руб',
                                          hintText: '100',
                                          controller: list['payment'],
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                              mask: '######',
                                              filter: {"#": RegExp(r'[0-9]')},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                                      "name": list['name']?.text,
                                      "code": list['code']?.text,
                                      "degres": int.parse(list['degres']!.text),
                                      "payment":
                                          int.parse(list['payment']!.text),
                                      "count": int.parse(list['count']!.text),
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
                            'Добавить промокод',
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
            SizedBox(
              child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(40),
                  1: FixedColumnWidth(200),
                  2: FixedColumnWidth(100),
                  3: FixedColumnWidth(60),
                  4: FixedColumnWidth(60),
                  5: FixedColumnWidth(60),
                  6: FlexColumnWidth(), //FixedColumnWidth(200), //FlexColumnWidth(),
                },
                children: const [
                  TableRow(
                    children: [
                      SizedBox(
                        child: Text(
                          '№',
                          //textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff80A0B9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'Название',
                          //textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff80A0B9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'Промо',
                          //textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff80A0B9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          '%',
                          //textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff80A0B9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'Руб',
                          //textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff80A0B9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'Ко-во',
                          //textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff80A0B9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'Статус',
                          //textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color(0xff80A0B9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                children: [
                  Table(
                    columnWidths: const {
                      0: FixedColumnWidth(40), //id
                      1: FixedColumnWidth(200), //name
                      2: FixedColumnWidth(100), //code
                      3: FixedColumnWidth(60), //%
                      4: FixedColumnWidth(60), //payment
                      5: FixedColumnWidth(60), //count
                      6: FlexColumnWidth(), // state FixedColumnWidth(200), //FlexColumnWidth(),
                    },
                    children: [
                      for (int i = 0; i < controller.list.length; i++)
                        TableRow(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Text(
                                '${controller.list[i].id}',
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393939),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                Flexible(
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: '${controller.list[i].name}'),
                                    onChanged: (v) {
                                      controller.list[i].name = v;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                Flexible(
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: '${controller.list[i].code}'),
                                    onChanged: (v) {
                                      controller.list[i].code = v;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                Flexible(
                                  child: TextField(
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: '####',
                                        filter: {"#": RegExp(r'[0-9]')},
                                      ),
                                    ],
                                    controller: TextEditingController(
                                        text: '${controller.list[i].degres}'),
                                    onChanged: (v) {
                                      if (v.length != 0) {
                                        controller.list[i].degres =
                                            int.parse(v);
                                      } else {
                                        controller.list[i].degres = 0;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                Flexible(
                                  child: TextField(
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: '#######',
                                        filter: {"#": RegExp(r'[0-9]')},
                                      ),
                                    ],
                                    controller: TextEditingController(
                                        text: '${controller.list[i].payment}'),
                                    onChanged: (v) {
                                      if (v.length != 0) {
                                        controller.list[i].payment =
                                            int.parse(v);
                                      } else {
                                        controller.list[i].payment = 0;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 5),
                                Flexible(
                                  child: TextField(
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: '####',
                                        filter: {"#": RegExp(r'[0-9]')},
                                      ),
                                    ],
                                    controller: TextEditingController(
                                        text: '${controller.list[i].count}'),
                                    onChanged: (v) {
                                      if (v.length != 0) {
                                        controller.list[i].count = int.parse(v);
                                      } else {
                                        controller.list[i].count = 0;
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                            ),
                            Row(
                              children: [
                                Switch(
                                  value: controller.list[i].active == 1
                                      ? true
                                      : false,
                                  onChanged: (v) {
                                    controller.list[i].active =
                                        v == true ? 1 : 2;
                                    controller.list.refresh();
                                  },
                                ),
                                IconButton(
                                  color: const Color(0xff205CBE),
                                  onPressed: () async {
                                    var r = await controller.updateO({
                                      "id": controller.list[i].id.toString(),
                                      "name":
                                          controller.list[i].name.toString(),
                                      "code":
                                          controller.list[i].code.toString(),
                                      "active":
                                          controller.list[i].active.toString(),
                                      "degres":
                                          controller.list[i].degres.toString(),
                                      "payment":
                                          controller.list[i].payment.toString(),
                                      "count":
                                          controller.list[i].count.toString(),
                                      //"minute":
                                      //  controller.list[i].minute.toString(),
                                    });
                                    if (r == true) {
                                      controller.getData();
                                    }
                                  },
                                  icon: const Icon(Icons.save),
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
                                                bool r =
                                                    await controller.removeO(
                                                        controller.list[i].id
                                                            .toString());
                                                if (r == true) {
                                                  Get.back();
                                                  controller.getData();
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
