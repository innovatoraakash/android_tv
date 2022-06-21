import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:video_example/constants/constants.dart';
import 'package:video_example/database/database.dart';
import 'package:video_example/model/items/ItemModel.dart';
import 'package:video_example/model/items/item_data.dart';

final dbHelper = VideoDatabaseHelper.instance;

class FetchDatabase extends StatelessWidget {
  const FetchDatabase({Key key}) : super(key: key);

// InitialFetch(){
//     var items = await ItemRepo().getItems().whenComplete(() => null);
//     items.forEach((element) async {
//       print('items:${element.id}');
//       final id = await dbHelper.insert(element.toMap(), item_table);
//       print('inserted row id: $id');
//     });
// }

  FetchItems() async {
    final allRows = await dbHelper.queryAllRows(item_table).whenComplete(() {});
    print('database${allRows.length}');
    for (var row in allRows) {
      print("rows$row");
      ItemData.add(ItemModel().toModel(row));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
