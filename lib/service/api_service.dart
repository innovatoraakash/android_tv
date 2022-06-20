import 'package:http/http.dart' as http;
import 'package:video_example/constants/constants.dart';
// import 'package:video_example/model/item_model.dart';
import 'package:video_example/model/items/ItemModel.dart';
import 'dart:convert';

class ItemRepo {
  Future<List<ItemModel>> getItems() async {
    final result = await http.Client().get(Uri.parse(item_api));
    if (result.statusCode != 200) throw Exception();
    // print(result.body);
    var parsed = itemModelFromJson(result.body);
    // print('parsed:$parsed');
    return parsed;
  }

  Future<List<ItemModel>> getItemById(int id) async {
    print("got here");
    final result = await http.Client().get(Uri.parse("${item_api}/$id"));
    print("result : ${result.body}");
    if (result.statusCode != 200) throw Exception();
    return itemModelFromJson(result.body);
  }

  // List<ItemModel> parsedJson(final response) {
  //   // itemModelFromJson(response);
  //   List itemList;
  //   final jsonDecoded = json.decode(response);
  //   print(jsonDecoded);
  //   if (jsonDecoded.length > 0) {
  //     for (int i = 0; i < jsonDecoded.length; i++) {
  //       if (jsonDecoded[i] != null) {
  //         itemList.add(ItemModel.fromJson(jsonDecoded[i]));
  //       }
  //     }
  //   }
  //   return itemList;
  //   // return ItemModel.fromJson(jsonDecoded);
  // }
}
