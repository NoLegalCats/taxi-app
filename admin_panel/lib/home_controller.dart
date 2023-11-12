import 'package:admin_panel/controllers/controller_dop.dart';
import 'package:admin_panel/controllers/controller_promocode.dart';
import 'package:admin_panel/controllers/controllers_additional_payment.dart';
import 'package:admin_panel/controllers/controllers_cards.dart';
import 'package:admin_panel/controllers/controllers_drivers.dart';
import 'package:admin_panel/controllers/controllers_ordes.dart';
import 'package:admin_panel/controllers/controllers_times.dart';
import 'package:admin_panel/views/view_add_payments.dart';
import 'package:admin_panel/views/view_cards.dart';
import 'package:admin_panel/views/view_dop.dart';
import 'package:admin_panel/views/view_drivers.dart';
import 'package:admin_panel/views/view_orders.dart';
import 'package:admin_panel/views/view_promocode.dart';
import 'package:admin_panel/views/view_setting.dart';
import 'package:admin_panel/views/view_times.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var visibleBottom = true.obs;

  int get index => currentIndex.value;
  void onTapItem(int i) {
    currentIndex.value = i;
    currentIndex.refresh();
  }

  Widget bodyWidget() {
    switch (index) {
      case 0:
        Get.delete<OrdersController>();
        return ViewOrders(); //ViewOrders2();//const Center(child: Text('Заказы'));
      /*case 1:
        return const ViewSetting();*/
      case 1:
        Get.delete<DriversController>();
        return ViewDrivers();
      case 2:
        Get.delete<AddpaymentController>();
        return ViewAddpayment();
      case 3:
        Get.delete<TimesController>();
        return ViewTimes();
      case 4:
        Get.delete<CardsController>();
        return ViewCards();

      case 5:
        Get.delete<PromocodeController>();
        return ViewPromocode();
      case 6:
        Get.delete<DopController>();
        return ViewDop();
      /*case 6:
        return const Center(child: Text('Брони'));*/

      default:
        return const Center(child: Text('Ошибка отображения'));
    }
  }
}
