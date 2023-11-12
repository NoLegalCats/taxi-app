import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/controllers/controllers_cards.dart';
import 'package:admin_panel/views/items/item_card.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ViewCards extends StatelessWidget {
  final controller = Get.put(CardsController());

  ViewCards({super.key}) {
    //
  }
  @override
  Widget build(BuildContext context) {
    if (AppConfig.mobile == true) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Маршруты'),
            actions: [
              IconButton(
                onPressed: () async {
                  Map<String, TextEditingController> list = {};
                  Future<bool> Function(Map<String, dynamic>) newObj =
                      controller.newO;
                  list['in'] = TextEditingController();
                  list['out'] = TextEditingController();
                  list['payment'] = TextEditingController();
                  list['orderIn'] = TextEditingController(text: '1');
                  list['orderOut'] = TextEditingController(text: '2');
                  await showDialog(
                    context: Get.context!,
                    builder: (context) {
                      return SimpleDialog(
                        alignment: Alignment.center,
                        clipBehavior: Clip.antiAlias,
                        insetPadding: const EdgeInsets.all(5),
                        title: const Text('Добавить маршрут'),
                        children: [
                          SizedBox(
                            height: Get.height - 150,
                            width: Get.width - 10,
                            child: ListView(
                              children: [
                                TextFieldCustom(
                                  title: 'Откуда',
                                  hintText: 'откуда',
                                  controller: list['in'],
                                ),
                                TextFieldCustom(
                                  title: 'Куда',
                                  hintText: 'куда',
                                  controller: list['out'],
                                ),
                                TextFieldCustom(
                                  title: '№ порядковый Откуда',
                                  hintText: '1',
                                  keyboardType: TextInputType.number,
                                  controller: list['orderIn'],
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                      mask: "###",
                                      filter: {"#": RegExp(r'[0-9]')},
                                    ),
                                  ],
                                ),
                                TextFieldCustom(
                                  title: '№ порядковый Куда',
                                  hintText: '2',
                                  controller: list['orderOut'],
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                      mask: "###",
                                      filter: {"#": RegExp(r'[0-9]')},
                                    ),
                                  ],
                                ),
                                TextFieldCustom(
                                  title: 'Цена',
                                  hintText: 'цена в руб',
                                  controller: list['payment'],
                                  inputFormatters: [
                                    MaskTextInputFormatter(
                                      mask: '######',
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
                                  bool r = await newObj!({
                                    "in": list['in']?.text,
                                    "out": list['out']?.text,
                                    "payment": list['payment']?.text,
                                    "orderIn":
                                        int.parse(list['orderIn']?.text ?? '1'),
                                    "orderOut": int.parse(
                                        list['orderOut']?.text ?? '2'),
                                  });
                                  if (r == true) {
                                    Get.back();
                                  }
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
                    title: Text(
                        '${controller.list[i].inMap}(${controller.list[i].orderIn}) - ${controller.list[i].outMap}(${controller.list[i].orderOut})'),
                    subtitle: Text('${controller.list[i].payment} руб'),
                    children: [
                      //
                      Row(
                        children: [
                          const Spacer(),
                          IconButton(
                            iconSize: 35,
                            color: const Color(0xff205CBE),
                            onPressed: () async {
                              var r = await controller.updateO({
                                "payment":
                                    controller.list[i].payment.toString(),
                                "in": controller.list[i].inMap,
                                "out": controller.list[i].outMap,
                                "orderIn":
                                    controller.list[i].orderIn.toString(),
                                "orderOut":
                                    controller.list[i].orderOut.toString(),
                                "id": controller.list[i].id.toString(),
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
                            onPressed: () {
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
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text('От - До'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: TextField(
                                controller: TextEditingController(
                                    text: '${controller.list[i].inMap}'),
                                onChanged: (v) {
                                  controller.list[i].inMap = v;
                                },
                              ),
                            ),
                            const Text(
                              ' - ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393939),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextField(
                                controller: TextEditingController(
                                    text: '${controller.list[i].outMap}'),
                                onChanged: (v) {
                                  controller.list[i].outMap = v;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text('Номер позиции, От - До'),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: TextField(
                                controller: TextEditingController(
                                    text: '${controller.list[i].orderIn}'),
                                onChanged: (v) {
                                  controller.list[i].orderIn = int.parse(v);
                                },
                              ),
                            ),
                            const Text(
                              ' - ',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff393939),
                              ),
                            ),
                            SizedBox(
                              width: 120,
                              child: TextField(
                                controller: TextEditingController(
                                    text: '${controller.list[i].orderOut}'),
                                onChanged: (v) {
                                  controller.list[i].orderOut = int.parse(v);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text('Цена в руб'),
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
                              mask: '#######',
                              filter: {"#": RegExp(r'[0-9]')},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Text('Промежуточные маршруты'),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () async {
                          int idcards = controller.list[i].id!;
                          Map<String, TextEditingController> list = {};
                          Future<bool> Function(Map<String, dynamic>) newObj =
                              controller.newO1;
                          list['in'] = TextEditingController();
                          list['out'] = TextEditingController();
                          list['payment'] = TextEditingController();
                          list['orderIn'] = TextEditingController();
                          list['orderOut'] = TextEditingController();
                          list['count_minute'] = TextEditingController();
                          await showDialog(
                            context: Get.context!,
                            builder: (context) {
                              return SimpleDialog(
                                alignment: Alignment.center,
                                insetPadding: const EdgeInsets.all(5),
                                clipBehavior: Clip.antiAlias,
                                title: Text(
                                    'Добавить промежуточный маршрут к\n${controller.list[i].inMap}-${controller.list[i].outMap}'),
                                children: [
                                  SizedBox(
                                    height: Get.height - 150,
                                    width: Get.width - 10,
                                    child: ListView(
                                      children: [
                                        TextFieldCustom(
                                          title: 'Откуда',
                                          hintText: 'откуда',
                                          controller: list['in'],
                                        ),
                                        TextFieldCustom(
                                          title: 'Куда',
                                          hintText: 'куда',
                                          controller: list['out'],
                                        ),
                                        TextFieldCustom(
                                          title: '№ порядковый Откуда',
                                          hintText: '1',
                                          keyboardType: TextInputType.number,
                                          controller: list['orderIn'],
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                              mask: "###",
                                              filter: {"#": RegExp(r'[0-9]')},
                                            ),
                                          ],
                                        ),
                                        TextFieldCustom(
                                          title: '№ порядковый Куда',
                                          hintText: '2',
                                          controller: list['orderOut'],
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                              mask: "###",
                                              filter: {"#": RegExp(r'[0-9]')},
                                            ),
                                          ],
                                        ),
                                        TextFieldCustom(
                                          title: 'Цена',
                                          hintText: 'цена в рублях',
                                          controller: list['payment'],
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                              mask: '#####',
                                              filter: {"#": RegExp(r'[0-9]')},
                                            ),
                                          ],
                                        ),
                                        TextFieldCustom(
                                          title: 'Минуты',
                                          hintText:
                                              '+ ожидание в минатах от основного маршрута',
                                          controller: list['count_minute'],
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                              mask: '###',
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
                                            "in": list['in']?.text,
                                            "out": list['out']?.text,
                                            "payment": list['payment']?.text,
                                            "count_minute":
                                                list['count_minute']?.text,
                                            "cards_idcards": idcards,
                                            "orderIn": int.parse(
                                                list['orderIn']?.text ?? '0'),
                                            "orderOut": int.parse(
                                                list['orderOut']?.text ?? '0'),
                                          });
                                          if (r == true) {
                                            Get.back();
                                          }
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
                                  )
                                ],
                              );
                            },
                          );
                          controller.getData();
                        },
                        child: const Row(
                          children: [
                            Icon(
                              Icons.add_circle_outline_sharp,
                              color: Color(0xff205CBE),
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Добавить промежуточный маршрут',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff205CBE),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),
                      for (int j = 0;
                          j < controller.list[i].lisIntertCards.length;
                          j++)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 15),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: .5,
                                  color: Colors.black87,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        '№ ${controller.list[i].lisIntertCards[j].id}'),
                                    const Spacer(),
                                    IconButton(
                                      color: const Color(0xff205CBE),
                                      onPressed: () async {
                                        var r = await controller.updateO1({
                                          "payment": controller
                                              .list[i].lisIntertCards[j].payment
                                              .toString(),
                                          "in": controller
                                              .list[i].lisIntertCards[j].inMap,
                                          "out": controller
                                              .list[i].lisIntertCards[j].outMap,
                                          "id": controller
                                              .list[i].lisIntertCards[j].id
                                              .toString(),
                                          "count_minute": controller.list[i]
                                              .lisIntertCards[j].countMinute
                                              .toString(),
                                          "orderIn": controller
                                              .list[i].lisIntertCards[j].orderIn
                                              .toString(),
                                          "orderOut": controller.list[i]
                                              .lisIntertCards[j].orderOut
                                              .toString(),
                                        });
                                        if (r == true) {
                                          controller.getData();
                                        }
                                      },
                                      icon: const Icon(Icons.save),
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
                                                    bool r = await controller
                                                        .removeO1(controller
                                                            .list[i]
                                                            .lisIntertCards[j]
                                                            .id
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
                                const SizedBox(height: 15),
                                const Text('От - До'),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TextField(
                                        controller: TextEditingController(
                                            text:
                                                '${controller.list[i].lisIntertCards[j].inMap}'),
                                        onChanged: (v) {
                                          controller.list[i].lisIntertCards[j]
                                              .inMap = v;
                                        },
                                      ),
                                    ),
                                    const Text(' - '),
                                    SizedBox(
                                      width: 120,
                                      child: TextField(
                                        controller: TextEditingController(
                                            text:
                                                '${controller.list[i].lisIntertCards[j].outMap}'),
                                        onChanged: (v) {
                                          controller.list[i].lisIntertCards[j]
                                              .outMap = v;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                const Text('Номер позиции, От - До'),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      child: TextField(
                                        controller: TextEditingController(
                                            text:
                                                '${controller.list[i].lisIntertCards[j].orderIn}'),
                                        onChanged: (v) {
                                          controller.list[i].lisIntertCards[j]
                                              .orderIn = int.parse(v);
                                        },
                                      ),
                                    ),
                                    const Text(' - '),
                                    SizedBox(
                                      width: 120,
                                      child: TextField(
                                        controller: TextEditingController(
                                            text:
                                                '${controller.list[i].lisIntertCards[j].orderOut}'),
                                        onChanged: (v) {
                                          controller.list[i].lisIntertCards[j]
                                              .orderOut = int.parse(v);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                const Text('Цена в руб и время ожидания в мин'),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 90,
                                      child: TextField(
                                        inputFormatters: [
                                          MaskTextInputFormatter(
                                            mask: '#######',
                                            filter: {"#": RegExp(r'[0-9]')},
                                          ),
                                        ],
                                        controller: TextEditingController(
                                            text:
                                                '${controller.list[i].lisIntertCards[j].payment}'),
                                        onChanged: (v) {
                                          controller.list[i].lisIntertCards[j]
                                              .payment = int.parse(v);
                                        },
                                      ),
                                    ),
                                    const Text(' , '),
                                    SizedBox(
                                      width: 90,
                                      child: TextField(
                                        inputFormatters: [
                                          MaskTextInputFormatter(
                                            mask: '###',
                                            filter: {"#": RegExp(r'[0-9]')},
                                          ),
                                        ],
                                        controller: TextEditingController(
                                            text:
                                                '${controller.list[i].lisIntertCards[j].countMinute}'),
                                        onChanged: (v) {
                                          controller.list[i].lisIntertCards[j]
                                              .countMinute = int.parse(v);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                    ],
                  ),
              ],
            ),
          ));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Маршруты',
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
                    list['in'] = TextEditingController();
                    list['out'] = TextEditingController();
                    list['payment'] = TextEditingController();
                    list['orderIn'] = TextEditingController(text: '1');
                    list['orderOut'] = TextEditingController(text: '2');
                    await showDialog(
                      context: Get.context!,
                      builder: (context) {
                        return SimpleDialog(
                          alignment: Alignment.center,
                          clipBehavior: Clip.antiAlias,
                          title: const Text('Добавить маршрут'),
                          children: [
                            SizedBox(
                              height: 350,
                              width: 500,
                              child: ListView(
                                children: [
                                  TextFieldCustom(
                                    title: 'Откуда',
                                    hintText: 'откуда',
                                    controller: list['in'],
                                  ),
                                  TextFieldCustom(
                                    title: 'Куда',
                                    hintText: 'куда',
                                    controller: list['out'],
                                  ),
                                  TextFieldCustom(
                                    title: '№ порядковый Откуда',
                                    hintText: '1',
                                    keyboardType: TextInputType.number,
                                    controller: list['orderIn'],
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: "###",
                                        filter: {"#": RegExp(r'[0-9]')},
                                      ),
                                    ],
                                  ),
                                  TextFieldCustom(
                                    title: '№ порядковый Куда',
                                    hintText: '2',
                                    controller: list['orderOut'],
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: "###",
                                        filter: {"#": RegExp(r'[0-9]')},
                                      ),
                                    ],
                                  ),
                                  TextFieldCustom(
                                    title: 'Цена',
                                    hintText: 'цена в руб',
                                    controller: list['payment'],
                                    inputFormatters: [
                                      MaskTextInputFormatter(
                                        mask: '######',
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
                                    bool r = await newObj!({
                                      "in": list['in']?.text,
                                      "out": list['out']?.text,
                                      "payment": list['payment']?.text,
                                      "orderIn": int.parse(
                                          list['orderIn']?.text ?? '1'),
                                      "orderOut": int.parse(
                                          list['orderOut']?.text ?? '2'),
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
                            'Добавить маршрут',
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
                  0: FixedColumnWidth(30),
                  1: FixedColumnWidth(300),
                  2: FixedColumnWidth(300), //FlexColumnWidth(),
                  3: FixedColumnWidth(300), //FlexColumnWidth(),
                  4: FixedColumnWidth(200),
                },
                children: const [
                  TableRow(
                    children: [
                      SizedBox(
                        height: 40,
                        child: Text(
                          '№',
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xff80A0B9),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          'Маршрут',
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
                          'Промежуточнный маршруты',
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
                          'Сумма',
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
                          'Ожидание (в минутах)',
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
                      0: FixedColumnWidth(30),
                      1: FixedColumnWidth(300),
                      2: FixedColumnWidth(300), //FlexColumnWidth(),
                      3: FixedColumnWidth(300), //FlexColumnWidth(),
                      4: FixedColumnWidth(200), //FlexColumnWidth(),
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
                                //textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xff393939),
                                ),
                              ),
                            ),
                            SizedBox(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: TextField(
                                          controller: TextEditingController(
                                              text:
                                                  '${controller.list[i].inMap}'),
                                          onChanged: (v) {
                                            controller.list[i].inMap = v;
                                          },
                                        ),
                                      ),
                                      const Text(
                                        ' - ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff393939),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: TextField(
                                          controller: TextEditingController(
                                              text:
                                                  '${controller.list[i].outMap}'),
                                          onChanged: (v) {
                                            controller.list[i].outMap = v;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 120,
                                        child: TextField(
                                          controller: TextEditingController(
                                              text:
                                                  '${controller.list[i].orderIn}'),
                                          onChanged: (v) {
                                            controller.list[i].orderIn =
                                                int.parse(v);
                                          },
                                        ),
                                      ),
                                      const Text(
                                        ' - ',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff393939),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: TextField(
                                          controller: TextEditingController(
                                              text:
                                                  '${controller.list[i].orderOut}'),
                                          onChanged: (v) {
                                            controller.list[i].orderOut =
                                                int.parse(v);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 90,
                                        child: TextField(
                                          controller: TextEditingController(
                                              text:
                                                  '${controller.list[i].payment}'),
                                          onChanged: (v) {
                                            controller.list[i].payment =
                                                int.parse(v);
                                          },
                                          inputFormatters: [
                                            MaskTextInputFormatter(
                                              mask: '#######',
                                              filter: {"#": RegExp(r'[0-9]')},
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Text(
                                        ' р',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff393939),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      IconButton(
                                        color: const Color(0xff205CBE),
                                        onPressed: () async {
                                          var r = await controller.updateO({
                                            "payment": controller
                                                .list[i].payment
                                                .toString(),
                                            "in": controller.list[i].inMap,
                                            "out": controller.list[i].outMap,
                                            "orderIn": controller
                                                .list[i].orderIn
                                                .toString(),
                                            "orderOut": controller
                                                .list[i].orderOut
                                                .toString(),
                                            "id": controller.list[i].id
                                                .toString(),
                                          });
                                          if (r == true) {
                                            controller.getData();
                                          }
                                        },
                                        icon: const Icon(Icons.save),
                                      ),
                                      IconButton(
                                        color: const Color(0xff205CBE),
                                        onPressed: () {
                                          showDialog(
                                            context: Get.context!,
                                            builder: (context) {
                                              return AlertDialog(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                clipBehavior: Clip.antiAlias,
                                                title:
                                                    const Text('Уведомление'),
                                                content: const Text(
                                                    'Вы действительно хотите удалить запись?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      bool r = await controller
                                                          .removeO(controller
                                                              .list[i].id
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
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (int j = 0;
                                    j <
                                        controller
                                            .list[i].lisIntertCards.length;
                                    j++)
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: TextField(
                                              controller: TextEditingController(
                                                  text:
                                                      '${controller.list[i].lisIntertCards[j].inMap}'),
                                              onChanged: (v) {
                                                controller
                                                    .list[i]
                                                    .lisIntertCards[j]
                                                    .inMap = v;
                                              },
                                            ),
                                          ),
                                          const Text(' - '),
                                          SizedBox(
                                            width: 120,
                                            child: TextField(
                                              controller: TextEditingController(
                                                  text:
                                                      '${controller.list[i].lisIntertCards[j].outMap}'),
                                              onChanged: (v) {
                                                controller
                                                    .list[i]
                                                    .lisIntertCards[j]
                                                    .outMap = v;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 120,
                                            child: TextField(
                                              controller: TextEditingController(
                                                  text:
                                                      '${controller.list[i].lisIntertCards[j].orderIn}'),
                                              onChanged: (v) {
                                                controller
                                                    .list[i]
                                                    .lisIntertCards[j]
                                                    .orderIn = int.parse(v);
                                              },
                                            ),
                                          ),
                                          const Text(' - '),
                                          SizedBox(
                                            width: 120,
                                            child: TextField(
                                              controller: TextEditingController(
                                                  text:
                                                      '${controller.list[i].lisIntertCards[j].orderOut}'),
                                              onChanged: (v) {
                                                controller
                                                    .list[i]
                                                    .lisIntertCards[j]
                                                    .orderOut = int.parse(v);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),

                                      /*SizedBox(
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                            '${controller.list[i].lisIntertCards[j].inMap}-${controller.list[i].lisIntertCards[j].outMap}',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: Color(0xff393939),
                                            ),
                                          ),
                                        ),
                                      ),*/
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                TextButton(
                                  onPressed: () async {
                                    int idcards = controller.list[i].id!;
                                    Map<String, TextEditingController> list =
                                        {};
                                    Future<bool> Function(Map<String, dynamic>)
                                        newObj = controller.newO1;
                                    list['in'] = TextEditingController();
                                    list['out'] = TextEditingController();
                                    list['payment'] = TextEditingController();
                                    list['orderIn'] = TextEditingController();
                                    list['orderOut'] = TextEditingController();
                                    list['count_minute'] =
                                        TextEditingController();
                                    await showDialog(
                                      context: Get.context!,
                                      builder: (context) {
                                        return SimpleDialog(
                                          alignment: Alignment.center,
                                          clipBehavior: Clip.antiAlias,
                                          title: Text(
                                              'Добавить промежуточный маршрут к\n${controller.list[i].inMap}-${controller.list[i].outMap}'),
                                          children: [
                                            SizedBox(
                                              height: 350,
                                              width: 500,
                                              child: ListView(
                                                children: [
                                                  TextFieldCustom(
                                                    title: 'Откуда',
                                                    hintText: 'откуда',
                                                    controller: list['in'],
                                                  ),
                                                  TextFieldCustom(
                                                    title: 'Куда',
                                                    hintText: 'куда',
                                                    controller: list['out'],
                                                  ),
                                                  TextFieldCustom(
                                                    title:
                                                        '№ порядковый Откуда',
                                                    hintText: '1',
                                                    keyboardType:
                                                        TextInputType.number,
                                                    controller: list['orderIn'],
                                                    inputFormatters: [
                                                      MaskTextInputFormatter(
                                                        mask: "###",
                                                        filter: {
                                                          "#": RegExp(r'[0-9]')
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  TextFieldCustom(
                                                    title: '№ порядковый Куда',
                                                    hintText: '2',
                                                    controller:
                                                        list['orderOut'],
                                                    inputFormatters: [
                                                      MaskTextInputFormatter(
                                                        mask: "###",
                                                        filter: {
                                                          "#": RegExp(r'[0-9]')
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  TextFieldCustom(
                                                    title: 'Цена',
                                                    hintText: 'цена в рублях',
                                                    controller: list['payment'],
                                                    inputFormatters: [
                                                      MaskTextInputFormatter(
                                                        mask: '#####',
                                                        filter: {
                                                          "#": RegExp(r'[0-9]')
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  TextFieldCustom(
                                                    title: 'Минуты',
                                                    hintText:
                                                        '+ ожидание в минатах от основного маршрута',
                                                    controller:
                                                        list['count_minute'],
                                                    inputFormatters: [
                                                      MaskTextInputFormatter(
                                                        mask: '###',
                                                        filter: {
                                                          "#": RegExp(r'[0-9]')
                                                        },
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
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    height: 50,
                                                    width: 200,
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
                                                    bool r = await newObj({
                                                      "in": list['in']?.text,
                                                      "out": list['out']?.text,
                                                      "payment":
                                                          list['payment']?.text,
                                                      "count_minute":
                                                          list['count_minute']
                                                              ?.text,
                                                      "cards_idcards": idcards,
                                                      "orderIn": int.parse(
                                                          list['orderIn']
                                                                  ?.text ??
                                                              '0'),
                                                      "orderOut": int.parse(
                                                          list['orderOut']
                                                                  ?.text ??
                                                              '0'),
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
                                                    width: 200,
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
                                                        'Добавить',
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
                                            )
                                          ],
                                        );
                                      },
                                    );
                                    controller.getData();
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.add_circle_outline_sharp,
                                        color: Color(0xff205CBE),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Добавить промежуточный маршрут',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff205CBE),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (int j = 0;
                                    j <
                                        controller
                                            .list[i].lisIntertCards.length;
                                    j++)
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 90,
                                            child: TextField(
                                              inputFormatters: [
                                                MaskTextInputFormatter(
                                                  mask: '#######',
                                                  filter: {
                                                    "#": RegExp(r'[0-9]')
                                                  },
                                                ),
                                              ],
                                              controller: TextEditingController(
                                                  text:
                                                      '${controller.list[i].lisIntertCards[j].payment}'),
                                              onChanged: (v) {
                                                controller
                                                    .list[i]
                                                    .lisIntertCards[j]
                                                    .payment = int.parse(v);
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 40,
                                            child: Center(
                                              child: Text(
                                                ' р',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xff393939),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 65,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (int j = 0;
                                    j <
                                        controller
                                            .list[i].lisIntertCards.length;
                                    j++)
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            child: TextField(
                                              inputFormatters: [
                                                MaskTextInputFormatter(
                                                  mask: '###',
                                                  filter: {
                                                    "#": RegExp(r'[0-9]')
                                                  },
                                                ),
                                              ],
                                              controller: TextEditingController(
                                                  text:
                                                      '${controller.list[i].lisIntertCards[j].countMinute}'),
                                              onChanged: (v) {
                                                controller
                                                    .list[i]
                                                    .lisIntertCards[j]
                                                    .countMinute = int.parse(v);
                                              },
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            color: const Color(0xff205CBE),
                                            onPressed: () async {
                                              var r =
                                                  await controller.updateO1({
                                                "payment": controller.list[i]
                                                    .lisIntertCards[j].payment
                                                    .toString(),
                                                "in": controller.list[i]
                                                    .lisIntertCards[j].inMap,
                                                "out": controller.list[i]
                                                    .lisIntertCards[j].outMap,
                                                "id": controller.list[i]
                                                    .lisIntertCards[j].id
                                                    .toString(),
                                                "count_minute": controller
                                                    .list[i]
                                                    .lisIntertCards[j]
                                                    .countMinute
                                                    .toString(),
                                                "orderIn": controller.list[i]
                                                    .lisIntertCards[j].orderIn
                                                    .toString(),
                                                "orderOut": controller.list[i]
                                                    .lisIntertCards[j].orderOut
                                                    .toString(),
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
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    title: const Text(
                                                        'Уведомление'),
                                                    content: const Text(
                                                        'Вы действительно хотите удалить запись?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          bool r = await controller
                                                              .removeO1(controller
                                                                  .list[i]
                                                                  .lisIntertCards[
                                                                      j]
                                                                  .id
                                                                  .toString());
                                                          if (r == true) {
                                                            Get.back();
                                                            controller
                                                                .getData();
                                                          }
                                                        },
                                                        child: const Text('Да'),
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
                                                Icons.delete_outlined),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 65,
                                      ),
                                    ],
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

class ViewCards2 extends StatelessWidget {
  final controller = Get.put(CardsController());

  ViewCards2({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Маршруты'),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(() => NewItemCard(
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
              ExpansionTile(
                title: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: TextEditingController(
                            text: '${controller.list[i].inMap}'),
                        onChanged: (v) {
                          controller.list[i].inMap = v;
                        },
                      ),
                    ),
                    const Text(' - '),
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: TextEditingController(
                            text: '${controller.list[i].outMap}'),
                        onChanged: (v) {
                          controller.list[i].outMap = v;
                        },
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: TextField(
                        controller: TextEditingController(
                            text: '${controller.list[i].payment}'),
                        onChanged: (v) {
                          controller.list[i].payment = int.parse(v);
                        },
                      ),
                    ),
                    const Text(' цена в руб '),
                    TextButton(
                        onPressed: () async {
                          var r = await controller.updateO({
                            "payment": controller.list[i].payment.toString(),
                            "in": controller.list[i].inMap,
                            "out": controller.list[i].outMap,
                            "id": controller.list[i].id.toString(),
                          });
                          if (r == true) {
                            controller.getData();
                          }
                        },
                        child: const Text('Сохранить изменения'))
                  ],
                ),
                /*title: Text(
                    '${controller.list[i].inMap} - ${controller.list[i].outMap}'),
                subtitle: Text('${controller.list[i].payment} руб'),
                */
                leading: IconButton(
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
                children: [
                  ListTile(
                    title: const Text('Промежуточные маршруты'),
                    leading: IconButton(
                      onPressed: () async {
                        await Get.to(() => NewItemInterCard(
                              controller.list[i].id!,
                              newObj: controller.newO1,
                            ));
                        controller.getData();
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ),
                  for (int j = 0;
                      j < controller.list[i].lisIntertCards.length;
                      j++)
                    ListTile(
                      title: Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextField(
                              controller: TextEditingController(
                                  text:
                                      '${controller.list[i].lisIntertCards[j].inMap}'),
                              onChanged: (v) {
                                controller.list[i].lisIntertCards[j].inMap = v;
                              },
                            ),
                          ),
                          const Text(' - '),
                          SizedBox(
                            width: 120,
                            child: TextField(
                              controller: TextEditingController(
                                  text:
                                      '${controller.list[i].lisIntertCards[j].outMap}'),
                              onChanged: (v) {
                                controller.list[i].lisIntertCards[j].outMap = v;
                              },
                            ),
                          ),
                        ],
                      ),

                      /*Text(
                          '${controller.list[i].lisIntertCards[j].inMap} - ${controller.list[i].lisIntertCards[j].outMap}'),
                      */
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 120,
                                child: TextField(
                                  controller: TextEditingController(
                                      text:
                                          '${controller.list[i].lisIntertCards[j].payment}'),
                                  onChanged: (v) {
                                    controller.list[i].lisIntertCards[j]
                                        .payment = int.parse(v);
                                  },
                                ),
                              ),
                              const Text(' цена в руб, '),
                              SizedBox(
                                width: 120,
                                child: TextField(
                                  controller: TextEditingController(
                                      text:
                                          '${controller.list[i].lisIntertCards[j].countMinute}'),
                                  onChanged: (v) {
                                    controller.list[i].lisIntertCards[j]
                                        .countMinute = int.parse(v);
                                  },
                                ),
                              ),
                              const Text('ожидание в минутах'),
                            ],
                          ),
                          TextButton(
                              onPressed: () async {
                                var r = await controller.updateO1({
                                  "payment": controller
                                      .list[i].lisIntertCards[j].payment
                                      .toString(),
                                  "in": controller
                                      .list[i].lisIntertCards[j].inMap,
                                  "out": controller
                                      .list[i].lisIntertCards[j].outMap,
                                  "id": controller.list[i].lisIntertCards[j].id
                                      .toString(),
                                  "count_minute": controller
                                      .list[i].lisIntertCards[j].countMinute
                                      .toString(),
                                });
                                if (r == true) {
                                  controller.getData();
                                }
                              },
                              child: const Text('Сохранить изменения'))
                        ],
                      ),
                      /*subtitle: Text(
                          '${controller.list[i].lisIntertCards[j].payment} руб, ожидание в минутах ${controller.list[i].lisIntertCards[j].countMinute}'),
                      */
                      leading: IconButton(
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
                                      bool r = await controller.removeO1(
                                          controller
                                              .list[i].lisIntertCards[j].id
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
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
