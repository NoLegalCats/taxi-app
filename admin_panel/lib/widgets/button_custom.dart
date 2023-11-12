import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ButtonCustom extends StatelessWidget {
  Function()? onPressed;
  String? title;
  ButtonCustom({super.key, required this.onPressed, required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15, top: 10),
      child: ElevatedButton(
        style: const ButtonStyle(
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15)))),
          backgroundColor: MaterialStatePropertyAll(Color(0xdf3B4371)),
          padding: MaterialStatePropertyAll(
              EdgeInsets.only(top: 24, bottom: 24, left: 12, right: 12)),
        ),
        onPressed: onPressed,
        child: Text(
          title!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w100,
            color: Color(0xffF0F2F0),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
