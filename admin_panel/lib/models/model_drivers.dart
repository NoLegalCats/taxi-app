 class ModelDrivers {
  int? id;
  int? idcompany;
  String? carInfo;
  String? mobile;
  String? idhash;
  String? password;
  String? aes128;
  int? idstate;
  String? name;


  int? count;
  String? color;
  int? year;
  String? number;
  String? markaModel;
  ModelDrivers();
  ModelDrivers.json(Map<String, dynamic> json) {
    if (json['color'] != null) {
      color = json['color'].toString();
    }
    if (json['marka_model'] != null) {
      markaModel = json['marka_model'].toString();
    }
    if (json['number'] != null) {
      number = json['number'].toString();
    }
    if (json['count'] != null) {
      count = int.parse(json['count'].toString());
    }
    if (json['year'] != null) {
      year = int.parse(json['year'].toString());
    }

    if (json['iddrivers'] != null) {
      id = int.parse(json['iddrivers'].toString());
    }
    if (json['company_idcompany'] != null) {
      idcompany = int.parse(json['company_idcompany'].toString());
    }
    if (json['car_info'] != null) {
      carInfo = json['car_info'].toString();
    }
    if (json['mobile'] != null) {
      mobile = json['mobile'].toString();
    }
    if (json['idhash'] != null) {
      idhash = json['idhash'].toString();
    }
    if (json['password'] != null) {
      password = json['password'].toString();
    }
    if (json['aes128'] != null) {
      aes128 = json['aes128'].toString();
    }
    if (json['idstate'] != null) {
      idstate = int.parse(json['idstate'].toString());
    }
    if (json['name'] != null) {
      name = json['name'].toString();
    }
  }
}
