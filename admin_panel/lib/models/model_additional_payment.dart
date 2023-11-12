class ModelAdditionalPayment {
  int? id;
  String? text;
  int? payment;
  int? idcompany;
  int? idstate;

  ModelAdditionalPayment();
  ModelAdditionalPayment.json(Map<String, dynamic> json) {
    if (json['idadd_payment'] != null) {
      id = int.parse(json['idadd_payment'].toString());
    }
    if (json['text'] != null) {
      text = json['text'].toString();
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
  }
}
