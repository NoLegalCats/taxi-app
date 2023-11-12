import 'package:admin_panel/models/model_drivers.dart';

class ModelOrderDrivers{
  int? id;
  String? datetimeCreated;
  int? idstate;
  int? idorders;
  int? iddrivers;
  ModelDrivers? drivers;
  ModelOrderDrivers();
  ModelOrderDrivers.json(Map<String, dynamic>json){
    if(json['idorder_drivers']!=null){
      id = int.parse(json['idorder_drivers'].toString());
    }
    if(json['idstate']!=null){
      idstate = int.parse(json['idstate'].toString());
    }
    if(json['orders_idorders']!=null){
      idorders = int.parse(json['orders_idorders'].toString());
    }
    if(json['drivers_iddrivers']!=null){
      iddrivers = int.parse(json['drivers_iddrivers'].toString());
    }
    if(json['datetime_created']!=null){
      datetimeCreated = json['datetime_created'].toString();
    }
  }
}