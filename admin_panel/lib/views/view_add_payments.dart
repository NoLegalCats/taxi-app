import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/controllers/controllers_additional_payment.dart';
import 'package:admin_panel/views/items/item_addpayment.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ViewAddpayment extends StatelessWidget {
  final controller = Get.put(AddpaymentController());

  ViewAddpayment({super.key});
  @override
  Widget build(BuildContext context) {
    if (AppConfig.mobile == true) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Районы'),
          actions: [
            IconButton(
              onPressed: () async {
                Map<String, TextEditingController> list = {};
                Future<bool> Function(Map<String, dynamic>) newObj =
                    controller.newO;
                list['text'] = TextEditingController();
                list['payment'] = TextEditingController();

                await showDialog(
                  context: Get.context!,
                  builder: (context) {
                    return SimpleDialog(
                      insetPadding: const EdgeInsets.all(5),
                      alignment: Alignment.center,
                      clipBehavior: Clip.antiAlias,
                      title: const Text('Добавить район'),
                      children: [
                        SizedBox(
                          height: Get.height - 150,
                          width: Get.width - 10,
                          child: ListView(
                            children: [
                              TextFieldCustom(
                                title: 'Название',
                                hintText: 'Название доп. оплаты',
                                controller: list['text'],
                              ),
                              TextFieldCustom(
                                title: 'Цена',
                                hintText: '100 руб',
                                controller: list['payment'],
                                inputFormatters: [
                                  MaskTextInputFormatter(
                                    mask: '#####',
                                    filter: {"#": RegExp('[-0-9]')},
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
                                  "text": list['text']?.text,
                                  "payment": list['payment']?.text,
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
                    title: Text('${controller.list[i].text}'),
                    subtitle: Text('${controller.list[i].payment} руб'),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Название',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          //width: 200,
                          child: TextField(
                            controller: TextEditingController(
                                text: controller.list[i].text),
                            onChanged: (v) {
                              controller.list[i].text = v;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          'Цена в руб',
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          controller: TextEditingController(
                              text: '${controller.list[i].payment}'),
                          onChanged: (v) {
                            controller.list[i].payment = int.parse(v);
                          },
                          inputFormatters: [
                            MaskTextInputFormatter(
                              mask: '#####',
                              filter: {"#": RegExp('[-0-9]')},
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
                                "text": controller.list[i].text,
                                "payment":
                                    controller.list[i].payment.toString(),
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
          'Районы',
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
                    list['text'] = TextEditingController();
                    list['payment'] = TextEditingController();

                    await showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return SimpleDialog(
                          alignment: Alignment.center,
                          clipBehavior: Clip.antiAlias,
                          title: const Text('Добавить район'),
                          children: [
                            SizedBox(
                              height: 350,
                              width: 500,
                              child: ListView(
                                children: [
                                  TextFieldCustom(
                                    title: 'Название',
                                    hintText: 'Название доп. оплаты',
                                    controller: list['text'],
                                  ),
                                  TextFieldCustom(
                                    title: 'Цена',
                                    hintText: '100 руб',
                                    controller: list['payment'],
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: '#####',
                                        filter: {"#": RegExp('[-0-9]')},
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
                                      "text": list['text']?.text,
                                      "payment": list['payment']?.text,
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
                            'Добавить район',
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
                  1: FixedColumnWidth(450), //FlexColumnWidth(),
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
                          'Цена',
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
                      1: FixedColumnWidth(450), //FlexColumnWidth(),
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
                            Padding(
                              padding: const EdgeInsets.only(right: 50),
                              child: SizedBox(
                                //width: 200,
                                child: TextField(
                                  controller: TextEditingController(
                                      text: controller.list[i].text),
                                  onChanged: (v) {
                                    controller.list[i].text = v;
                                  },
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: TextField(
                                    controller: TextEditingController(
                                        text: '${controller.list[i].payment}'),
                                    onChanged: (v) {
                                      controller.list[i].payment = int.parse(v);
                                    },
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: '#####',
                                        filter: {"#": RegExp('[-0-9]')},
                                      ),
                                    ],
                                  ),
                                ),
                                const Text(
                                  'р',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393939),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                IconButton(
                                  color: const Color(0xff205CBE),
                                  onPressed: () async {
                                    var r = await controller.updateO({
                                      "id": controller.list[i].id.toString(),
                                      "text": controller.list[i].text,
                                      "payment":
                                          controller.list[i].payment.toString(),
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

class ViewAddpayment2 extends StatelessWidget {
  final controller = Get.put(AddpaymentController());

  ViewAddpayment2({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Район города и доп. Опции'),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(() => NewItemAddpayment(
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
                title: Row(
                  children: [
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: TextEditingController(
                            text: controller.list[i].text),
                        onChanged: (v) {
                          controller.list[i].text = v;
                        },
                      ),
                    ),
                  ],
                ), //Text('${controller.list[i].text}'),
                subtitle: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: TextEditingController(
                            text: '${controller.list[i].payment}'),
                        onChanged: (v) {
                          controller.list[i].payment = int.parse(v);
                        },
                      ),
                    ),
                    const Text('руб'),
                    TextButton(
                        onPressed: () async {
                          var r = await controller.updateO({
                            "id": controller.list[i].id.toString(),
                            "text": controller.list[i].text,
                            "payment": controller.list[i].payment.toString(),
                          });
                          if (r == true) {
                            controller.getData();
                          }
                        },
                        child: const Text('Сохранить изменения'))
                  ],
                ),
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
