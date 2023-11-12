import 'package:flutter/material.dart';

class NoElement extends StatelessWidget {
  Function()? onPress;
  NoElement({super.key, this.onPress});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Cписок пуст',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xff283048),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: onPress,
            child: const Text('Обновить'),
          ),
        ],
      ),
    );
  }
}
