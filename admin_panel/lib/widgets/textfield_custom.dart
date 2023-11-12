import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: must_be_immutable
class TextFieldCustom extends StatelessWidget {
  int? maxLength;
  String? hintText;
  String? title;
  TextEditingController? controller;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  Function(String)? onChanged;
  Function(PointerDownEvent)?onTapOutside;
  Function(String)?onSubmitted;
  int? maxLines;
  String? errorText;

  TextFieldCustom(
      {super.key,
      this.onSubmitted,
      this.onTapOutside,
      this.keyboardType,
      this.onChanged,
      this.errorText,
      this.maxLength,
      this.hintText,
      required this.title,
      this.controller,
      this.inputFormatters,
      this.maxLines});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 2),
          child: Text(
            title!,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color(0xff0B486B),
              fontSize: 12,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: TextField(
            onSubmitted: onSubmitted,
            onTapOutside: onTapOutside,
            minLines: 1,
            maxLines: maxLines,
            onChanged: onChanged,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            controller: controller,
            maxLength: maxLength,
            cursorColor: const Color(0xff3B4371),
            decoration: InputDecoration(
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: .1),
                borderRadius: BorderRadius.circular(10),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red, width: .1),
                borderRadius: BorderRadius.circular(5),
              ),
              prefixIconColor: Colors.black,
              hintText: hintText,
              errorText: errorText,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              fillColor: const Color(
                  0xffF0F2F0), //Color(0xffFFFFFF),//fromARGB(255, 247, 247, 247),//255, 255, 243, 224),
              filled: true,

              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color:Colors.transparent,// Color(0xffec6f66),
                    /* Color.fromARGB(255, 5, 5, 5),*/
                    width: .1,),
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color:Colors.transparent,// Color(0xff0B486B),
                  width: .1,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 1.2),
          ),
        ),
      ],
    );
  }
}
