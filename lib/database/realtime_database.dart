import 'package:firebase_database/firebase_database.dart';

String firefire() {
  DatabaseReference ref = FirebaseDatabase.instance.ref("items");

// Get the Stream

  Stream<DatabaseEvent> stream = ref.onChildChanged;

// Subscribe to the stream!
  stream.listen(
    (DatabaseEvent event) {
      print('Event Type: ${event.snapshot.key}');
      print('Snapshot: ${event.snapshot.value}');
      // DataSnapshot
      return event.snapshot
          .child("1")
          .child("date")
          .value; // DatabaseEventType.value;
    },
    onDone: () {},
  );
}

void InitialFirebaseFetch() async {
  DatabaseReference ref = FirebaseDatabase.instance.ref("items");

// Get the Stream

  DatabaseEvent event = await ref.once();

// Print the data of the snapshot
  print(event.snapshot.value);
}
