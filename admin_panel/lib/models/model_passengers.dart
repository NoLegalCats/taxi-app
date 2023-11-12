import 'package:admin_panel/models/model_additional_payment.dart';
import 'package:admin_panel/models/model_bookings.dart';
import 'package:admin_panel/models/model_users.dart';

class ModelPassengers {
  int? id;
  String? name;
  String? inAdress;
  String? outAdress;
  String? info;
  int? count;
  Map<dynamic, dynamic>? addPayment;
  String? mobile;
  int? idusers;
  String? datetimeCreated;
  int? idaddPAyment;
  ModelUsers? users;
  ModelBookings? booking;
  dynamic dataFull;
  int? degres;
  int? payment;
  ModelAdditionalPayment? addPAyments;
  ModelPassengers.json(Map<String, dynamic> json) {
    if (json['data_full'] != null) {
      dataFull = json['data_full'];
    }
    if (json['degres'] != null) {
      degres = int.parse(json['degres'].toString());
    }
    if (json['payment'] != null) {
      payment = int.parse(json['payment'].toString());
    }
    if (json['info'] != null) {
      info = json['info'].toString();
    }
    if (json['users'] != null) {
      for (int i = 0; i < json['users'].length; i++) {
        users = ModelUsers.json(json['users'][i]);
      }
    }
    if (json['bookings'] != null) {
      for (int i = 0; i < json['bookings'].length; i++) {
        booking = ModelBookings.json(json['bookings'][i]);
      }
    }
    if (json['add_paymnets'] != null) {
      for (int i = 0; i < json['add_paymnets'].length; i++) {
        addPAyments = ModelAdditionalPayment.json(json['add_paymnets'][i]);
      }
    }

    if (json['additional_payment_idadd_payment'] != null) {
      idaddPAyment =
          int.parse(json['additional_payment_idadd_payment'].toString());
    }
    if (json['users_idusers'] != null) {
      idusers = int.parse(json['users_idusers'].toString());
    }
    if (json['idpassengers'] != null) {
      id = int.parse(json['idpassengers'].toString());
    }
    if (json['count'] != null) {
      count = int.parse(json['count'].toString());
    }
    if (json['name'] != null) {
      name = json['name'].toString();
    }
    if (json['datetime_created'] != null) {
      datetimeCreated = json['datetime_created'].toString();
    }
    if (json['in_adress'] != null) {
      inAdress = json['in_adress'].toString();
    }
    if (json['out_adress'] != null) {
      outAdress = json['out_adress'].toString();
    }
    if (json['mobile'] != null) {
      mobile = json['mobile'].toString();
    }
  }
}
