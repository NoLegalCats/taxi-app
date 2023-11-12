
  import 'package:flutter/material.dart';

loadingindicator() {
    return const Text('Загрузка..',
        style: TextStyle(
            color: Colors.grey, fontFamily: 'SourceSansPro-SemiBold'));
  }

  completeindicator() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children:  <Widget>[
        Icon(
          Icons.done,
          color: Colors.grey,
        ),
        SizedBox(
          width: 10,
        ),
        Text('Данные обновленны',
            style: TextStyle(
                color: Colors.grey, fontFamily: 'SourceSansPro-SemiBold'))
      ],
    );
  }

  failedIndicator() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.close,
          color: Colors.grey,
        ),
        SizedBox(
          width: 10,
        ),
        Text('Ошибка',
            style: TextStyle(
                color: Colors.grey, fontFamily: 'SourceSansPro-SemiBold'))
      ],
    );
  }