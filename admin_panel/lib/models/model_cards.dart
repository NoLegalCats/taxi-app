import 'package:admin_panel/models/model_intermediate_cards.dart';

class ModelCards {
  int? id;
  String? inMap;
  String? outMap;
  int? payment;
  int? idcompany;
  int? idstate;
  int? orderIn;
  int? orderOut;
  List<ModelIntermediateCards> lisIntertCards = [];

  ModelCards.json(Map<String, dynamic> json) {
    if (json['intermediate_cards'] != null) {
      for (int i = 0; i < json['intermediate_cards'].length; i++) {
        lisIntertCards
            .add(ModelIntermediateCards.json(json['intermediate_cards'][i]));
      }
    }
    if (json['orderIn'] != null) {
      orderIn = int.parse(json['orderIn'].toString());
    }
    if (json['orderOut'] != null) {
      orderOut = int.parse(json['orderOut'].toString());
    }
    if (json['idcards'] != null) {
      id = int.parse(json['idcards'].toString());
    }
    if (json['payment'] != null) {
      payment = int.parse(json['payment'].toString());
    }
    if (json['company_idcompany'] != null) {
      idcompany = int.parse(json['company_idcompany'].toString());
    }
    if (json['idstate'] != null) {
      idstate = int.parse(json['idstate'].toString());
    }
    if (json['in'] != null) {
      inMap = json['in'].toString();
    }
    if (json['out'] != null) {
      outMap = json['out'].toString();
    }
  }
}
