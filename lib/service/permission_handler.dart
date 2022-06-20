import 'package:permission_handler/permission_handler.dart';

PermissionHandle() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.location,

    Permission.storage
    //add more permission to request here.
  ].request();

  if (statuses[Permission.location].isDenied) {
    //check each permission status after.
    print("Location permission is denied.");
  }

  if (statuses[Permission.storage].isDenied) {
    print("media access denied");
  }

  if (statuses[Permission.manageExternalStorage].isDenied) {
    print("external access denied");
  }
}
