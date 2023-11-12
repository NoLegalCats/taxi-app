class ModelTimes {
  int? id;
  int? idcompany;
  int? minute;
  int? idstate;
  ModelTimes();
  ModelTimes.json(Map<String, dynamic> json) {
    if(json['idtimes']!=null){
      id = int.parse(json['idtimes'].toString());
    }
    if(json['company_idcompany']!=null){
      idcompany = int.parse(json['company_idcompany'].toString());
    }
    if(json['minute']!=null){
      minute = int.parse(json['minute'].toString());
    }
    if(json['idstate']!=null){
      idstate = int.parse(json['idstate'].toString());
    }
  }
}
