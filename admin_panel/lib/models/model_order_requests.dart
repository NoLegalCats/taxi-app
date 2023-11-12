import 'package:admin_panel/models/model_cards.dart';
import 'package:admin_panel/models/model_intermediate_cards.dart';
import 'package:admin_panel/models/model_passengers.dart';
import 'package:admin_panel/models/model_times.dart';

class ModelOrderRequests{
  int? id;
  int? idstate;
  int? idpassengers;
  int? idtimes;
  int? idorders;
  int? idintermediateCards;
  int? idcards;
  ModelCards ? cards;
  ModelIntermediateCards? interCards;
  ModelTimes? times;
  ModelPassengers? passengers;
  ModelOrderRequests();
  ModelOrderRequests.json(Map<String, dynamic>json){
    if (json['passengers'] != null) {
      for (int i = 0; i < json['passengers'].length; i++) {
        passengers = ModelPassengers.json(json['passengers'][i]);
      }
    }

    if(json['idorder_requests']!=null){
      id = int.parse(json['idorder_requests'].toString());
    }
    if(json['idstate']!=null){
      idstate = int.parse(json['idstate'].toString());
    }
    if(json['passengers_idpassengers']!=null){
      idpassengers = int.parse(json['passengers_idpassengers'].toString());
    }
    if(json['times_idtimes']!=null){
      idtimes = int.parse(json['times_idtimes'].toString());
    }
    if(json['orders_idorders']!=null){
      idorders = int.parse(json['orders_idorders'].toString());
    }
    if(json['intermediate_cards_idintermediate_cards']!=null){
      idintermediateCards = int.parse(json['intermediate_cards_idintermediate_cards'].toString());
    }
    if(json['cards_idcards']!=null){
      idcards = int.parse(json['cards_idcards'].toString());
    }
  }
}