import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatelessWidget {
  final controller = Get.put(HomeController());
  var m = 0.obs;

  Home({super.key}) {
    AppConfig.getProfile().then((value) {
      if (value != null) {
        if (value['balanc'] != null) {
          m.value = value['balanc'];
          m.refresh();
        }
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if (AppConfig.mobile == true) {
      return Scaffold(
        appBar: AppBar(),
        body: Obx(() => controller.bodyWidget()),
        drawer: Obx(
          () => Drawer(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Баланс ${m.value} руб'),
                  trailing: IconButton(
                    onPressed: () {
                      AppConfig.getProfile().then((value) {
                        if (value != null) {
                          if (value['balanc'] != null) {
                            m.value = value['balanc'];
                            m.refresh();
                          }
                        }
                      });
                    },
                    icon: const Icon(Icons.update),
                  ),
                ),
                ListTile(
                  dense: true,
                  minVerticalPadding: 5,
                  contentPadding: const EdgeInsets.all(5),
                  title: Text(
                    'Заказы',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: controller.currentIndex.value == 0
                          ? const Color(0xff205cbe)
                          : const Color(0xff80A0B9),
                    ),
                  ),
                  leading: Icon(
                    Icons.line_style_rounded,
                    color: controller.currentIndex.value == 0
                        ? const Color(0xff205cbe)
                        : const Color(0xff80A0B9),
                  ),
                  trailing: Visibility(
                    visible: controller.currentIndex.value == 0 ? true : false,
                    child: Container(
                      height: 48,
                      width: 8,
                      decoration: const BoxDecoration(
                          color: Color(0xff205CBE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                    ),
                  ),
                  onTap: () {
                    controller.onTapItem(0);
                    Get.back();
                  },
                ),
                ListTile(
                  dense: true,
                  minVerticalPadding: 5,
                  contentPadding: const EdgeInsets.all(5),
                  title: Text(
                    'Водители',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: controller.currentIndex.value == 1
                          ? const Color(0xff205cbe)
                          : const Color(0xff80A0B9),
                    ),
                  ),
                  leading: Icon(
                    Icons.drive_eta_rounded,
                    color: controller.currentIndex.value == 1
                        ? const Color(0xff205cbe)
                        : const Color(0xff80A0B9),
                  ),
                  trailing: Visibility(
                    visible: controller.currentIndex.value == 1 ? true : false,
                    child: Container(
                      height: 48,
                      width: 8,
                      decoration: const BoxDecoration(
                          color: Color(0xff205CBE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                    ),
                  ),
                  onTap: () {
                    controller.onTapItem(1);
                    Get.back();
                  },
                ),
                ListTile(
                  dense: true,
                  minVerticalPadding: 5,
                  contentPadding: const EdgeInsets.all(5),
                  title: Text(
                    'Районы',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: controller.currentIndex.value == 2
                          ? const Color(0xff205cbe)
                          : const Color(0xff80A0B9),
                    ),
                  ),
                  leading: Icon(
                    Icons.add_location_alt_outlined,
                    color: controller.currentIndex.value == 2
                        ? const Color(0xff205cbe)
                        : const Color(0xff80A0B9),
                  ),
                  trailing: Visibility(
                    visible: controller.currentIndex.value == 2 ? true : false,
                    child: Container(
                      height: 48,
                      width: 8,
                      decoration: const BoxDecoration(
                          color: Color(0xff205CBE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                    ),
                  ),
                  onTap: () {
                    controller.onTapItem(2);
                    Get.back();
                  },
                ),
                ListTile(
                  dense: true,
                  minVerticalPadding: 5,
                  contentPadding: const EdgeInsets.all(5),
                  title: Text(
                    'Расписание',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: controller.currentIndex.value == 3
                          ? const Color(0xff205cbe)
                          : const Color(0xff80A0B9),
                    ),
                  ),
                  leading: Icon(
                    Icons.calendar_month,
                    color: controller.currentIndex.value == 3
                        ? const Color(0xff205cbe)
                        : const Color(0xff80A0B9),
                  ),
                  trailing: Visibility(
                    visible: controller.currentIndex.value == 3 ? true : false,
                    child: Container(
                      height: 48,
                      width: 8,
                      decoration: const BoxDecoration(
                          color: Color(0xff205CBE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                    ),
                  ),
                  onTap: () {
                    controller.onTapItem(3);
                    Get.back();
                  },
                ),
                ListTile(
                  dense: true,
                  minVerticalPadding: 5,
                  contentPadding: const EdgeInsets.all(5),
                  title: Text(
                    'Маршруты',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: controller.currentIndex.value == 4
                          ? const Color(0xff205cbe)
                          : const Color(0xff80A0B9),
                    ),
                  ),
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: controller.currentIndex.value == 4
                        ? const Color(0xff205cbe)
                        : const Color(0xff80A0B9),
                  ),
                  trailing: Visibility(
                    visible: controller.currentIndex.value == 4 ? true : false,
                    child: Container(
                      height: 48,
                      width: 8,
                      decoration: const BoxDecoration(
                          color: Color(0xff205CBE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                    ),
                  ),
                  onTap: () {
                    controller.onTapItem(4);
                    Get.back();
                  },
                ),
                //5
                ListTile(
                  dense: true,
                  minVerticalPadding: 5,
                  contentPadding: const EdgeInsets.all(5),
                  title: Text(
                    'Промокоды',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: controller.currentIndex.value == 5
                          ? const Color(0xff205cbe)
                          : const Color(0xff80A0B9),
                    ),
                  ),
                  leading: Icon(
                    Icons.shopify_rounded,
                    color: controller.currentIndex.value == 5
                        ? const Color(0xff205cbe)
                        : const Color(0xff80A0B9),
                  ),
                  trailing: Visibility(
                    visible: controller.currentIndex.value == 5 ? true : false,
                    child: Container(
                      height: 48,
                      width: 8,
                      decoration: const BoxDecoration(
                          color: Color(0xff205CBE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                    ),
                  ),
                  onTap: () {
                    controller.onTapItem(5);
                    Get.back();
                  },
                ),
                //6
                ListTile(
                  dense: true,
                  minVerticalPadding: 5,
                  contentPadding: const EdgeInsets.all(5),
                  title: Text(
                    'Доп. опции',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: controller.currentIndex.value == 6
                          ? const Color(0xff205cbe)
                          : const Color(0xff80A0B9),
                    ),
                  ),
                  leading: Icon(
                    Icons.add_chart_rounded,
                    color: controller.currentIndex.value == 6
                        ? const Color(0xff205cbe)
                        : const Color(0xff80A0B9),
                  ),
                  trailing: Visibility(
                    visible: controller.currentIndex.value == 6 ? true : false,
                    child: Container(
                      height: 48,
                      width: 8,
                      decoration: const BoxDecoration(
                          color: Color(0xff205CBE),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5))),
                    ),
                  ),
                  onTap: () {
                    controller.onTapItem(6);
                    Get.back();
                  },
                ),

                ListTile(
                  dense: true,
                  minVerticalPadding: 5,
                  contentPadding: const EdgeInsets.all(5),
                  title: const Text(
                    'Выход',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xff80A0B9),
                    ),
                  ),
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Color(0xff80A0B9),
                  ),
                  onTap: () => AppConfig.exit(),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  width: 198,
                  child: ListView(
                    children: [
                      ListTile(
                        title: Text('Баланс ${m.value} руб'),
                        trailing: IconButton(
                          onPressed: () {
                            AppConfig.getProfile().then((value) {
                              if (value != null) {
                                if (value['balanc'] != null) {
                                  m.value = value['balanc'];
                                  m.refresh();
                                }
                              }
                            });
                          },
                          icon: const Icon(Icons.update),
                        ),
                      ),
                      ListTile(
                        dense: true,
                        minVerticalPadding: 5,
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(
                          'Заказы',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: controller.currentIndex.value == 0
                                ? const Color(0xff205cbe)
                                : const Color(0xff80A0B9),
                          ),
                        ),
                        leading: Icon(
                          Icons.line_style_rounded,
                          color: controller.currentIndex.value == 0
                              ? const Color(0xff205cbe)
                              : const Color(0xff80A0B9),
                        ),
                        trailing: Visibility(
                          visible:
                              controller.currentIndex.value == 0 ? true : false,
                          child: Container(
                            height: 48,
                            width: 8,
                            decoration: const BoxDecoration(
                                color: Color(0xff205CBE),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                          ),
                        ),
                        onTap: () => controller.onTapItem(0),
                      ),
                      ListTile(
                        dense: true,
                        minVerticalPadding: 5,
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(
                          'Водители',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: controller.currentIndex.value == 1
                                ? const Color(0xff205cbe)
                                : const Color(0xff80A0B9),
                          ),
                        ),
                        leading: Icon(
                          Icons.drive_eta_rounded,
                          color: controller.currentIndex.value == 1
                              ? const Color(0xff205cbe)
                              : const Color(0xff80A0B9),
                        ),
                        trailing: Visibility(
                          visible:
                              controller.currentIndex.value == 1 ? true : false,
                          child: Container(
                            height: 48,
                            width: 8,
                            decoration: const BoxDecoration(
                                color: Color(0xff205CBE),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                          ),
                        ),
                        onTap: () => controller.onTapItem(1),
                      ),
                      ListTile(
                        dense: true,
                        minVerticalPadding: 5,
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(
                          'Районы',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: controller.currentIndex.value == 2
                                ? const Color(0xff205cbe)
                                : const Color(0xff80A0B9),
                          ),
                        ),
                        leading: Icon(
                          Icons.add_location_alt_outlined,
                          color: controller.currentIndex.value == 2
                              ? const Color(0xff205cbe)
                              : const Color(0xff80A0B9),
                        ),
                        trailing: Visibility(
                          visible:
                              controller.currentIndex.value == 2 ? true : false,
                          child: Container(
                            height: 48,
                            width: 8,
                            decoration: const BoxDecoration(
                                color: Color(0xff205CBE),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                          ),
                        ),
                        onTap: () => controller.onTapItem(2),
                      ),
                      ListTile(
                        dense: true,
                        minVerticalPadding: 5,
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(
                          'Расписание',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: controller.currentIndex.value == 3
                                ? const Color(0xff205cbe)
                                : const Color(0xff80A0B9),
                          ),
                        ),
                        leading: Icon(
                          Icons.calendar_month,
                          color: controller.currentIndex.value == 3
                              ? const Color(0xff205cbe)
                              : const Color(0xff80A0B9),
                        ),
                        trailing: Visibility(
                          visible:
                              controller.currentIndex.value == 3 ? true : false,
                          child: Container(
                            height: 48,
                            width: 8,
                            decoration: const BoxDecoration(
                                color: Color(0xff205CBE),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                          ),
                        ),
                        onTap: () => controller.onTapItem(3),
                      ),
                      ListTile(
                        dense: true,
                        minVerticalPadding: 5,
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(
                          'Маршруты',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: controller.currentIndex.value == 4
                                ? const Color(0xff205cbe)
                                : const Color(0xff80A0B9),
                          ),
                        ),
                        leading: Icon(
                          Icons.location_on_outlined,
                          color: controller.currentIndex.value == 4
                              ? const Color(0xff205cbe)
                              : const Color(0xff80A0B9),
                        ),
                        trailing: Visibility(
                          visible:
                              controller.currentIndex.value == 4 ? true : false,
                          child: Container(
                            height: 48,
                            width: 8,
                            decoration: const BoxDecoration(
                                color: Color(0xff205CBE),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                          ),
                        ),
                        onTap: () => controller.onTapItem(4),
                      ),
                      //5
                      ListTile(
                        dense: true,
                        minVerticalPadding: 5,
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(
                          'Промокоды',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: controller.currentIndex.value == 5
                                ? const Color(0xff205cbe)
                                : const Color(0xff80A0B9),
                          ),
                        ),
                        leading: Icon(
                          Icons.shopify_rounded,
                          color: controller.currentIndex.value == 5
                              ? const Color(0xff205cbe)
                              : const Color(0xff80A0B9),
                        ),
                        trailing: Visibility(
                          visible:
                              controller.currentIndex.value == 5 ? true : false,
                          child: Container(
                            height: 48,
                            width: 8,
                            decoration: const BoxDecoration(
                                color: Color(0xff205CBE),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                          ),
                        ),
                        onTap: () => controller.onTapItem(5),
                      ),
                      //6
                      ListTile(
                        dense: true,
                        minVerticalPadding: 5,
                        contentPadding: const EdgeInsets.all(5),
                        title: Text(
                          'Доп. опции',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: controller.currentIndex.value == 6
                                ? const Color(0xff205cbe)
                                : const Color(0xff80A0B9),
                          ),
                        ),
                        leading: Icon(
                          Icons.add_chart_rounded,
                          color: controller.currentIndex.value == 6
                              ? const Color(0xff205cbe)
                              : const Color(0xff80A0B9),
                        ),
                        trailing: Visibility(
                          visible:
                              controller.currentIndex.value == 6 ? true : false,
                          child: Container(
                            height: 48,
                            width: 8,
                            decoration: const BoxDecoration(
                                color: Color(0xff205CBE),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5))),
                          ),
                        ),
                        onTap: () => controller.onTapItem(6),
                      ),

                      ListTile(
                        dense: true,
                        minVerticalPadding: 5,
                        contentPadding: const EdgeInsets.all(5),
                        title: const Text(
                          'Выход',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Color(0xff80A0B9),
                          ),
                        ),
                        leading: const Icon(
                          Icons.exit_to_app,
                          color: Color(0xff80A0B9),
                        ),
                        onTap: () => AppConfig.exit(),
                      ),
                    ],
                  )),
              Flexible(
                child: controller.bodyWidget(),
              ),
            ],
          )),
      /*Obx(() => controller.bodyWidget()),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Заказы',
            ),
            /*BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Настройки',
            ),*/
            BottomNavigationBarItem(
              icon: Icon(Icons.drive_eta_rounded),
              label: 'Водители',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: 'Район города и доп. Опции',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_sharp),
              label: 'Расписание',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Маршруты',
            ),
            /*BottomNavigationBarItem(
              icon: Icon(Icons.book_online),
              label: 'Брони',
            ),*/
          ],
          currentIndex: controller.currentIndex.value,
          onTap: (i) {
            if (controller.visibleBottom.value) {
              controller.onTapItem(i);
            }
          },
        ),
      ),*/
    );
  }
}
