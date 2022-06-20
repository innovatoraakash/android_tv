import 'dart:convert';

/// id : "1"
/// name : "mac1"
/// file : "https://player.vimeo.com/video/71787467"
/// follow : null
/// hold : "15"
/// org_id : "2"
/// repeat_no : "9999"
/// start_date : "2022-06-01"
/// end_date : "2022-06-30"
/// type : "1"
/// status : "1"
/// video_length : "0.00"
/// action_by : "1"
/// action : null
/// created_at : "2022-06-13 12:57:08"
/// updated_at : "2022-06-13 13:11:10"
/// deleted_at : null

List<ItemModel> itemModelFromJson(String str) {
  List data = json.decode(str);
  List<ItemModel> items = [];
  data.forEach((element) {
    // print(ItemModel().fromJson(element).id);
    items.add(ItemModel().fromJson(element));
  });
  return items;
}

String itemModelToJson(ItemModel data) => json.encode(data.toJson());

class ItemModel {
  ItemModel({
    this.id,
    this.name,
    this.file,
    this.follow,
    this.hold,
   
    this.repeatNo,
    this.startDate,
    this.endDate,
    this.type,
    this.status,
    
  });

  ItemModel fromJson(dynamic json) {
    return ItemModel(
      id: json['id'],
      name: json['name'],
      file: json['file'],
      follow: json['follow'],
      hold: json['hold'],
   
      repeatNo: json['repeat_no'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      type: json['type'],
      status: json['status'],

    );
  }

  String id;
  String name;
  String file;
  dynamic follow;
  String hold;
 
  String repeatNo;
  String startDate;
  String endDate;
  String type;
  String status;
 


  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'file_link': file,
        'image_link': follow,
        'hold': hold,
        'day_count': repeatNo,
        'start_from': startDate,
        'end_on': endDate,
        'status': status,
      
      };
      
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['file'] = file;
    map['follow'] = follow;
    map['hold'] = hold;
   
    map['repeat_no'] = repeatNo;
    map['start_date'] = startDate;
    map['end_date'] = endDate;
    map['type'] = type;
    map['status'] = status;
 
    return map;
  }
}
