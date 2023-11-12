import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/controllers/controllers_times.dart';
import 'package:admin_panel/views/items/item_times.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ViewTimes extends StatelessWidget {
  final controller = Get.put(TimesController());

  ViewTimes({super.key});
  @override
  Widget build(BuildContext context) {
    if (AppConfig.mobile == true) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Расписание'),
          actions: [
            IconButton(
              onPressed: () async {
                Map<String, TextEditingController> list = {};
                Future<bool> Function(Map<String, dynamic>) newObj =
                    controller.newO;
                list['minute'] = TextEditingController();

                await showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return SimpleDialog(
                      insetPadding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      title: const Text('Добавить расписание'),
                      children: [
                        SizedBox(
                          height: Get.height - 150,
                          width: Get.width - 10,
                          child: ListView(
                            children: [
                              TextFieldCustom(
                                title: 'Минуты',
                                hintText: '0 - 1440 минут (24 часа)',
                                controller: list['minute'],
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: '####',
                                    filter: {"#": RegExp(r'[0-9]')},
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
                                  "minute": list['minute']?.text,
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
                    title:
                        Text('${controller.getTimes(controller.list[i].id)} ч'),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Кол-минут',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          controller: TextEditingController(
                              text: '${controller.list[i].minute}'),
                          onChanged: (v) {
                            controller.list[i].minute = int.parse(v);
                          },
                          inputFormatters: [
                            MaskTextInputFormatter(
                              mask: '####',
                              filter: {"#": RegExp(r'[0-9]')},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            iconSize: 35,
                            color: const Color(0xff205CBE),
                            onPressed: () async {
                              var r = await controller.updateO({
                                "id": controller.list[i].id.toString(),
                                "minute": controller.list[i].minute.toString(),
                              });
                              if (r == true) {
                                controller.getData();
                              }
                            },
                            icon: const Icon(Icons.save),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            iconSize: 35,
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
          'Расписание',
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
                    list['minute'] = TextEditingController();

                    await showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return SimpleDialog(
                          alignment: Alignment.center,
                          clipBehavior: Clip.antiAlias,
                          title: const Text('Добавить расписание'),
                          children: [
                            SizedBox(
                              height: 150,
                              width: 500,
                              child: ListView(
                                children: [
                                  TextFieldCustom(
                                    title: 'Минуты',
                                    hintText: '0 - 1440 минут (24 часа)',
                                    controller: list['minute'],
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: '####',
                                        filter: {"#": RegExp(r'[0-9]')},
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
                                      "minute": list['minute']?.text,
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
                            'Добавить расписание',
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
                  1: FixedColumnWidth(100), //FlexColumnWidth(),
                  2: FlexColumnWidth() //FixedColumnWidth(200), //FlexColumnWidth(),
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
                          'Время',
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
                          'Время в минутах',
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
                      0: FixedColumnWidth(40),
                      1: FixedColumnWidth(100), //FlexColumnWidth(),
                      2: FlexColumnWidth() // FixedColumnWidth(200), //FlexColumnWidth(),
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
                            Text(
                              '${controller.getTimes(controller.list[i].id)} ч',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393939),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: '${controller.list[i].minute}'),
                                    onChanged: (v) {
                                      controller.list[i].minute = int.parse(v);
                                    },
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: '####',
                                        filter: {"#": RegExp(r'[0-9]')},
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  color: const Color(0xff205CBE),
                                  onPressed: () async {
                                    var r = await controller.updateO({
                                      "id": controller.list[i].id.toString(),
                                      "minute":
                                          controller.list[i].minute.toString(),
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

class ViewTimes2 extends StatelessWidget {
  final controller = Get.put(TimesController());

  ViewTimes2({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Расписание'),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(() => NewItemTimes(
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
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
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
                                    .removeO(controller.list[i].id.toString());
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
                ),

                title: Text('${controller.getTimes(controller.list[i].id)} ч'),
                subtitle: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: TextEditingController(
                            text: '${controller.list[i].minute}'),
                        onChanged: (v) {
                          controller.list[i].minute = int.parse(v);
                        },
                      ),
                    ),
                    const Text('В минутах'),
                    TextButton(
                        onPressed: () async {
                          var r = await controller.updateO({
                            "id": controller.list[i].id.toString(),
                            "minute": controller.list[i].minute.toString(),
                          });
                          if (r == true) {
                            controller.getData();
                          }
                        },
                        child: const Text('Сохранить изменения'))
                  ],
                ),
                leading: Text(
                  '№ ${controller.list[i].id}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
                //children: [],
              ),
          ],
        ),
      ),
    );
  }
}
