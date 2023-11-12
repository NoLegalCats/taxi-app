class ModelDop {
  int? id;
  int? idcompany;
  int? payment;
  int? idstate;
  String? name;
  ModelDop();
  ModelDop.json(Map<String, dynamic> json) {
    if (json['id'] != null) {
      id = int.parse(json['id'].toString());
    }
    if (json['company_idcompany'] != null) {
      idcompany = int.parse(json['company_idcompany'].toString());
    }
    if (json['payment'] != null) {
      payment = int.parse(json['payment'].toString());
    }
    if (json['idstate'] != null) {
      idstate = int.parse(json['idstate'].toString());
    }
    if (json['name'] != null) {
      name = json['name'].toString();
    }
  }
}
