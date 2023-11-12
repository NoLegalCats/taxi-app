class ModelBookings{
  int? id;
  int? idstate;
  String? datetime;
  int? idpassengers;
  ModelBookings.json(Map<String, dynamic>json){
    if(json['idbookings']!=null){
      id = int.parse(json['idbookings'].toString());
    }
    if(json['idstate']!=null){
      idstate = int.parse(json['idstate'].toString());
    }
    if(json['passengers_idpassengers']!=null){
      idpassengers = int.parse(json['passengers_idpassengers'].toString());
    }
    if(json['datetime']!=null){
      datetime = json['datetime'].toString();
    }
  }
}