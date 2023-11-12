import 'package:flutter/material.dart';

class Teg extends StatelessWidget {
  late String text;
  Function()? onDelete;
  Function(String)? onInsert;
  Color? backColor;
  Color? textColor;
  Teg({super.key, 
    required this.text,
    this.onDelete,
    this.backColor,
    this.textColor,
    this.onInsert,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 7, right: 7, top: 3, bottom: 3),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.all(Radius.circular(onDelete == null ? 15 : 20)),
        color: backColor ??
            const Color(0x2fff9068), //Color.fromARGB(255, 227, 212, 228),
        border: Border.all(
          color: Colors.grey,
          width: 0.15,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '#$text',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor ?? const Color(0xff283048), //Color(0xfffd746c),
              letterSpacing: 0.8,
              fontSize: onDelete != null ? 16 : 16,
            ),
          ),
          if (onDelete != null) const SizedBox(width: 5),
          if (onDelete != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.clear_rounded,
                  color: textColor ?? const Color(0xffec6f66),
                  size: 20,
                ),
              ),
            ),
          if (onInsert != null) const SizedBox(width: 5),
          if (onInsert != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 2),
              child: GestureDetector(
                onTap: () => onInsert!(text),
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: textColor ?? const Color(0xffec6f66),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
