import 'package:admin_panel/app_config.dart';
import 'package:admin_panel/widgets/button_custom.dart';
import 'package:admin_panel/widgets/textfield_custom.dart';
import 'package:flutter/material.dart';

class AuthView extends StatelessWidget {
  TextEditingController login = TextEditingController(text: '');
  TextEditingController password = TextEditingController(text: '');

  AuthView({super.key}) {
    var r = AppConfig.getLoginData();
    if (r != null) {
      login.text = r['login'];
      password.text = r['password'];
      AppConfig.auth(r['login'], r['password']);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 250,
          height: 300,
          child: ListView(
            children: [
              TextFieldCustom(
                title: 'Логин',
                controller: login,
              ),
              TextFieldCustom(title: 'Пароль',
              controller: password,),
              ButtonCustom(
                onPressed: () async {
                  await AppConfig.auth(login.text, password.text);
                },
                title: 'Готово',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
