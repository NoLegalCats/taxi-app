class ModelPromocode {
  int? id;
  int? idcompany;
  int? payment;
  int? idstate;
  int? active;
  int? degres;
  int? count;
  String? name;
  String? code;
  ModelPromocode();
  ModelPromocode.json(Map<String, dynamic> json) {
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
    if (json['count'] != null) {
      count = int.parse(json['count'].toString());
    }
    if (json['active'] != null) {
      active = int.parse(json['active'].toString());
    }
    if (json['degres'] != null) {
      degres = int.parse(json['degres'].toString());
    }
    if (json['name'] != null) {
      name = json['name'].toString();
    }
    if (json['code'] != null) {
      code = json['code'].toString();
    }
  }
}
