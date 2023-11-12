import 'package:admin_panel/models/model_cards.dart';
import 'package:admin_panel/models/model_order_drivers.dart';
import 'package:admin_panel/models/model_order_requests.dart';
import 'package:admin_panel/models/model_times.dart';
import 'package:intl/intl.dart';

class ModelOrders {
  int? id;
  int? idcompany;
  int? idstate;
  int? degres;
  int? countMest;
  String? datetimeCreated;
  String? driverInfo;
  String? driverMobile;
  String? date;
  int? idtimes;
  int? idcards;
  ModelCards? cards;
  ModelTimes? times;
  List<ModelOrderRequests> listOrderRequests = [];
  List<ModelOrderDrivers> listOrderDrivers = [];
  int countPassagers(){
    int y = 0;
    for(int i = 0; i<listOrderRequests.length;i++){
      if(listOrderRequests[i].idstate!=2){
      y+=listOrderRequests[i].passengers?.count??0;
      }
    }
    return y;
  }
  ModelOrders();
  ModelOrders.json(Map<String, dynamic> json) {
    if (json['order_drivers'] != null) {
      for (int i = 0; i < json['order_drivers'].length; i++) {
        listOrderDrivers.add(ModelOrderDrivers.json(json['order_drivers'][i]));
      }
    }
    if (json['order_requests'] != null) {
      for (int i = 0; i < json['order_requests'].length; i++) {
        listOrderRequests
            .add(ModelOrderRequests.json(json['order_requests'][i]));
      }
    }
    if (json['count_mest'] != null) {
      countMest = int.parse(json['count_mest'].toString());
    }
    if (json['degres'] != null) {
      degres = int.parse(json['degres'].toString());
    }
    if (json['company_idcompany'] != null) {
      idcompany = int.parse(json['company_idcompany'].toString());
    }
    if (json['idorders'] != null) {
      id = int.parse(json['idorders'].toString());
    }
    if (json['idstate'] != null) {
      idstate = int.parse(json['idstate'].toString());
    }
    if (json['times_idtimes'] != null) {
      idtimes = int.parse(json['times_idtimes'].toString());
    }
    if (json['cards_idcards'] != null) {
      idcards = int.parse(json['cards_idcards'].toString());
    }
    if (json['datetime_created'] != null) {
      datetimeCreated = json['datetime_created'].toString();
    }
    if (json['driver_info'] != null) {
      driverInfo = json['driver_info'].toString();
    }
    if (json['driver_mobile'] != null) {
      driverMobile = json['driver_mobile'].toString();
    }
    if (json['date'] != null) {
      var d = DateTime.parse(json['date'].toString());
      date = DateFormat('yyyy-MM-dd').format(d);
      print(date);
    }
    
    if (json[''] != null) {}
    if (json[''] != null) {}
  }
}
