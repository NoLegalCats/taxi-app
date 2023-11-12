import 'package:admin_panel/widgets/button_custom.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NewItemCard extends StatelessWidget {
  Map<String, TextEditingController> list = {};
  Future<bool> Function(Map<String, dynamic>)? newObj;
  NewItemCard({super.key, this.newObj}) {
    onInitTextController();
  }
  onInitTextController() {
    //
    list['in'] = TextEditingController();
    list['out'] = TextEditingController();
    list['payment'] = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание Маршрута'),
      ),
      body: ListView(
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
            title: 'Цена',
            hintText: 'цена в руб',
            controller: list['payment'],
          ),

          ButtonCustom(
            onPressed: () async {
              if (newObj != null) {
                bool r = await newObj!({
                  "in": list['in']?.text,
                  "out": list['out']?.text,
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

class NewItemInterCard extends StatelessWidget {
  int idcards;
  Map<String, TextEditingController> list = {};
  Future<bool> Function(Map<String, dynamic>)? newObj;
  NewItemInterCard(this.idcards,{super.key, this.newObj}) {
    onInitTextController();
  }
  onInitTextController() {
    //
    list['in'] = TextEditingController();
    list['out'] = TextEditingController();
    list['payment'] = TextEditingController();
    list['count_minute'] = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание Маршрута'),
      ),
      body: ListView(
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
            title: 'Цена',
            hintText: 'цена в рублях',
            controller: list['payment'],
          ),
          TextFieldCustom(
            title: 'Минуты',
            hintText: '+ ожидание в минатах от основного маршрута',
            controller: list['count_minute'],
          ),
          ButtonCustom(
            onPressed: () async {
              if (newObj != null) {
                bool r = await newObj!({
                  "in": list['in']?.text,
                  "out": list['out']?.text,
                  "payment": list['payment']?.text,
                  "count_minute": list['count_minute']?.text,
                  "cards_idcards":idcards,
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
