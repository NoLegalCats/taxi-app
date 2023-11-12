import 'dart:convert';

import 'package:admin_panel/widgets/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// ignore: must_be_immutable
class DropList extends StatelessWidget {
  List<String>? list;
  Function(String?)? onPress;
  IconData? icon;
  var dropdownValue = ''.obs;
  String? title;
  double? width;
  CrossAxisAlignment? crossAxisAlignment;

  /// drop , show
  String? type;

  DropList({
    this.crossAxisAlignment,
    this.width,
    super.key,
    this.title,
    this.icon,
    this.onPress,
    String? initMail,
    required this.list,
    this.type,
  }) {
    if (list == null) return;
    dropdownValue.value = list!.first;
    if (initMail != null) {
      bool res = false;
      for (int i = 0; i < list!.length; i++) {
        if (initMail == list![i]) {
          res = true;
          break;
        }
      }
      if (res == true) {
        dropdownValue.value = initMail;
        if (onPress != null) onPress!(dropdownValue.value);
      }
    }
  }
  //var v = 'Yandex'.obs;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 2),
          child: Text(
            title ?? 'Выберите Компанию',
            style: const TextStyle(
              color: Color(0xff0B486B),
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Obx(
          () => Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Container(
              clipBehavior: Clip.antiAlias,
              height: 50,
              width: width ?? context.width,
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(color: Color(0xff0B486B), spreadRadius: .1)
                  ],
                  color: Color(0xffF0F2F0), //Color(0xffFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              //child: Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: type == 'drop'
                          ? DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: const Color(0xfff6f7f7),
                              itemHeight: 64,
                              value: dropdownValue.value,
                              icon: const Icon(
                                Icons.list,
                                color: Colors.transparent,
                              ),
                              elevation: 16,
                              underline: Container(height: 0),
                              style: const TextStyle(
                                //overflow: TextOverflow.ellipsis,

                                color: Color(0xff061234),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              ),
                              onChanged: (String? value) {
                                //print('d $value');
                                // This is called when the user selects an item.
                                //setState(() {
                                dropdownValue.value = value!;
                                dropdownValue.refresh();
                                if (onPress != null)
                                // ignore: curly_braces_in_flow_control_structures
                                /*if (list![0] == value) {
                                    onPress!(null);
                                  } else */
                                {
                                  onPress!(value);
                                }

                                //});
                              },
                              items: list!.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      color: Color(0xff061234),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              }).toList(),
                            )
                          : GestureDetector(
                              child: Container(
                                height: 60,
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      dropdownValue.value,
                                      textAlign: TextAlign.left,
                                      style: const TextStyle(
                                        color: Color(0xff061234),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                String? curr = await Get.to(() => ShowItem(
                                      init: dropdownValue.value,
                                      list: list,
                                      title: title,
                                      onItemCurect: onPress,
                                    ));
                                if (curr != null) {
                                  dropdownValue.value = curr;
                                  dropdownValue.refresh();
                                }
                              },
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      icon ?? Icons.list, //keyboard_arrow_down_rounded,
                      size: 30,

                      color: const Color(0xff3B4371),
                    ),
                  ),
                ],
              ),
              //),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ShowItem extends StatelessWidget {
  String? title;
  List<String>? list;
  Function(String?)? onItemCurect;
  String? init;
  var curr = ''.obs;
  ShowItem({
    super.key,
    required this.list,
    required this.title,
    required this.onItemCurect,
    required this.init,
  }) {
    curr.value = init!;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
        actions: [
          IconButton(
              onPressed: () {
                Get.back(result: curr.value);
              },
              icon: const Icon(Icons.check)),
          const SizedBox(width: 15),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list!.length,
              itemBuilder: (context, index) {
                return Obx(
                  () => Column(
                    children: [
                      ListTile(
                        trailing: Checkbox(
                          checkColor: Colors.white,
                          activeColor: const Color(0xffF3904F),
                          // /hoverColor:const Color(0xffF3904F),
                          fillColor:
                              const MaterialStatePropertyAll(Color(0xffF3904F)),
                          shape: const CircleBorder(),
                          value: curr.value == list![index] ? true : false,
                          onChanged: (v) {
                            curr.value = list![index];
                            curr.refresh();
                            if (onItemCurect != null) {
                              onItemCurect!(list![index]);
                            }
                          },
                        ),
                        contentPadding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 20, right: 20),
                        title: Text(
                          list![index],
                          style: const TextStyle(
                            color: Color(0xff000C40),
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 1.2,
                          ),
                        ),
                        onTap: () {
                          curr.value = list![index];
                          curr.refresh();
                          if (onItemCurect != null) onItemCurect!(list![index]);
                        },
                      ),
                      Container(
                        height: 0.2,
                        color: Colors.grey,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          ButtonCustom(
            onPressed: () {
              Get.back(result: curr.value);
            },
            title: 'Готово',
          ),
        ],
      ),
    );
  }
}

class DropList2Check extends StatelessWidget {
  List<String> list = [];
  List<int> listID = [];
  var map = {}.obs;

  Function(List<String>, dynamic)? onChange;
  IconData? icon;
  late Color color;
  var updValue = true.obs;
  String title;

  upd() {
    updValue.value = !updValue.value;
    updValue.refresh();
    return true;
  }

  DropList2Check(
      {super.key,
      required this.title,
      required this.list,
      required this.listID,
      dynamic m,
      this.onChange,
      this.icon,
      this.color = Colors.white}) {
    if (m == null) {
      for (int i = 0; i < list.length; i++) {
        map[list[i]] = {'enable': false, 'id': listID[i]};
      }
    } else {
      dynamic e = m;
      try{
        e = jsonDecode(e);
        m =e;
      }catch(e){
        print('eeer jsondecode');
      }
      for (int i = 0; i < list.length; i++) {
        try {
          if (m[list[i]] != null) {
            if (m[list[i]]['id'] != null) {
              if (m[list[i]]['enable'] != null) {
                map[list[i]] = m[list[i]];
              }
            }
          }
        } catch (e) {
          map[list[i]] = {'enable': false, 'id': listID[i]};
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: const Color(0xff205CBE),
            width: .8,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 15),
            Row(
              children: [
                if (icon != null)
                  Icon(
                    icon,
                    color: const Color(0xff205CBE),
                  ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xff393939),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
      onTap: () async {
        await showDialog(
            context: Get.context!,
            builder: (context) {
              return SimpleDialog(
                alignment: Alignment.center,
                clipBehavior: Clip.antiAlias,
                title: Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(color: Color(0xff205CBE)),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {
                          if (onChange != null) {
                            onChange!(list, map.value);
                          }
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xff205CBE),
                        ))
                  ],
                ),
                children: [
                  SizedBox(
                    height: Get.height * .8,
                    width: Get.width * .3,
                    child: ListView(
                      children: [
                        for (int i = 0; i < list.length; i++)
                          Obx(
                            () => CheckboxListTile(
                              value: map[list[i]]['enable'],
                              onChanged: (v) {
                                if (v != null) {
                                  map[list[i]]['enable'] = v;
                                }
                                map.refresh();
                                if (onChange != null) {
                                  onChange!(list, map.value);
                                }
                              },
                              dense: true,
                              title: Text(
                                list[i],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff393939),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ButtonCustom(
                            onPressed: () {
                              if (onChange != null) {
                                onChange!(list, map.value);
                                Get.back();
                              }
                            },
                            title: 'Готово'),
                      ],
                    ),
                  ),
                ],
              );
            });
      },
    );
  }
}
