class ModelUsers{
  int? id;
  String? idvk;
  Map<dynamic,dynamic>? vkData;
  String? datetimeCreated;
  String? idhash;
  String? aes128;
  String? mobile;
  String? name;
  String? idtelegram;
  ModelUsers.json(Map<String, dynamic>json){
    //
    if(json['idusers']!=null){
      id = int.parse(json['idusers'].toString());
    }
    if(json['idvk']!=null){
      idvk = json['idvk'].toString();
    }
    if(json['datetime_created']!=null){
      datetimeCreated = json['datetime_created'].toString();
    }
    if(json['idhash']!=null){
      idhash = json['idhash'].toString();
    }
    if(json['mobile']!=null){
      mobile = json['mobile'].toString();
    }
    if(json['name']!=null){
      name = json['name'].toString();
    }
    if(json['aes128']!=null){
      aes128 = json['aes128'].toString();
    }
    if(json['idtelegram']!=null){
      idtelegram = json['idtelegram'].toString();
    }
  }
}