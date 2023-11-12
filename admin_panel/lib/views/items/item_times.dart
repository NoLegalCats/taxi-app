import 'package:admin_panel/widgets/button_custom.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewItemTimes extends StatelessWidget {
  Map<String, TextEditingController> list = {};
  Future<bool> Function(Map<String, dynamic>)? newObj;
  NewItemTimes({super.key, this.newObj}) {
    onInitTextController();
  }
  onInitTextController() {
    //
    list['minute'] = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание расписания'),
      ),
      body: ListView(
        children: [
          TextFieldCustom(
            title: 'Минуты',
            hintText: '0 - 1440 минут (24 часа)',
            controller: list['minute'],
          ),
          
          ButtonCustom(
            onPressed: () async {
              if (newObj != null) {
                bool r = await newObj!({
                  "minute": list['minute']?.text,
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
