class ModelIntermediateCards {
  int? id;
  int? idcards;
  String? inMap;
  String? outMap;
  int? payment;
  int? countMinute;
  int? idstate;
    int? orderIn;
  int? orderOut;
  ModelIntermediateCards.json(Map<String, dynamic> json) {
    
    if (json['idintermediate_cards'] != null) {
      id = int.parse(json['idintermediate_cards'].toString());
    }
    if (json['cards_idcards'] != null) {
      idcards = int.parse(json['cards_idcards'].toString());
    }
    if (json['payment'] != null) {
      payment = int.parse(json['payment'].toString());
    }
    if (json['count_minute'] != null) {
      countMinute = int.parse(json['count_minute'].toString());
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
    if (json['orderIn'] != null) {
      orderIn = int.parse(json['orderIn'].toString());
    }
    if (json['orderOut'] != null) {
      orderOut = int.parse(json['orderOut'].toString());
    }
  }
}
