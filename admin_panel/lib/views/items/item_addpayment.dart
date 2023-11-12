
import 'package:admin_panel/widgets/button_custom.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NewItemAddpayment extends StatelessWidget {
  Map<String, TextEditingController> list = {};
  Future<bool> Function(Map<String, dynamic>)? newObj;
  NewItemAddpayment({super.key, this.newObj}) {
    onInitTextController();
  }
  onInitTextController() {
    //
    list['text'] = TextEditingController();
    list['payment'] = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание доп. платы'),
      ),
      body: ListView(
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
          ),
          ButtonCustom(
            onPressed: () async {
              if (newObj != null) {
                bool r = await newObj!({
                  "text": list['text']?.text,
                  "payment": list['payment']?.text,
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
