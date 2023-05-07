import 'package:permission_handler/permission_handler.dart';

Future<String> requestStoragePermission() async {
  var status = await Permission.storage.status;
  if (status.isGranted) {
    print('permission granted');
    return 'done';
  } else if (status.isDenied) {
    if (await Permission.storage.request().isGranted) {
      print('permission was granted');
      return 'done';
    }
  } else if (await Permission.storage.isPermanentlyDenied) {
    openAppSettings();
  }
  return '';
}
