import 'package:firebase_database/firebase_database.dart';
import 'package:video_example/constants/constants.dart';
import 'package:video_example/database/temp_database.dart';
import 'package:video_example/database/database.dart';

var databaseHelper = TestDatabase();
int lastUpdatedTime = 0;
final dbHelper = VideoDatabaseHelper.instance;

String firebaseListner() {
  DatabaseReference ref = FirebaseDatabase.instance.ref("items");

// Get the Stream

  Stream<DatabaseEvent> stream = ref.onChildChanged;
// Subscribe to the stream!
  stream.listen(
    (DatabaseEvent event) {
      print('Event Type: ${event.snapshot.key}');
      print('Snapshot: ${event.snapshot.child("date").value}');
      // DataSnapshot

      if (event.snapshot.child("delete").value as int == 1) {
        print("deleting");
        print("deleting id ${event.snapshot.child("item_id").value}");

       databaseHelper.delete(
            id: event.snapshot.child("item_id").value as int,
            table_name: item_table);
      }

      return event.snapshot
          .child("1")
          .child("date")
          .value; // DatabaseEventType.value;
    },
    onDone: () {
      lastUpdatedTime = DateTime.now().millisecondsSinceEpoch;
    },
  );
}

delete({int id = 1, String table_name}) async {
  // Assuming that the number of rows is the id for the last row.

  final rowsDeleted = await dbHelper.delete(id, table_name);
  print('deleted $rowsDeleted row(s): row $id');
}

void InitialFirebaseFetch() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("items");

// Get the Stream

  DatabaseEvent event = await ref.once();

  var allData = event.snapshot.children.toList();

  for (var data in allData) {
    print(data.child("date").value);

    if (data.child("date").value as int > lastUpdatedTime) {
      if (data.child("delete") == 1) {
        databaseHelper.delete(
            id: data.child("item_id") as int, table_name: item_table);
      }
    }
  }

// Print the data of the snapshot
  print("initial events${event.snapshot.children.toList()[1].value}");

  // if (event.snapshot.child("date").value as double <
  //     DateTime.now().millisecondsSinceEpoch) {
  //   if (event.snapshot.child("delete") == 1) {
  //     databaseHelper.delete(
  //         id: event.snapshot.child("item_id") as int, table_name: item_table);
  //   }
  // }
}
