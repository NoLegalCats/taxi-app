
import 'package:admin_panel/models/model_setting_app.dart';

class ModelCompany{
  int? id;
  String? idhash;
  String? name;
  String? info;
  String? password;
  String? login;
  String? aes128;
  ModelSettingApp? settingApp;
  ModelCompany();
  ModelCompany.json(Map<String, dynamic>json){
    if(json['idcompany']!=null){
      id = int.parse(json['idcompany'].toString());
    }
    if(json['idhash']!=null){
      idhash = json['idhash'].toString();
    }
    if(json['name']!=null){
      name = json['name'].toString();
    }
    if(json['info']!=null){
      info = json['info'].toString();
    }
    if(json['password']!=null){
      password = json['password'].toString();
    }
    if(json['login']!=null){
      login = json['login'].toString();
    }
    if(json['aes128']!=null){
      aes128 = json['aes128'].toString();
    }
  }
}