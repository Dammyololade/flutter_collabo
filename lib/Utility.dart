
import 'dart:io';
import 'package:device_info/device_info.dart';

///
/// project: flutter_collabo
/// @package: 
/// @author dammyololade <damola@kobo360.com>
/// created on 2019-06-01
class Utility {

  Future<String> getDeviceSerial() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String serial = "";
    if (Platform.isAndroid) {
      serial = await deviceInfoPlugin.androidInfo.then((build) {
        return build.androidId;
      });
    } else {
      serial = await deviceInfoPlugin.iosInfo.then((build) {
        return build.identifierForVendor;
      });
    }
    return serial;
  }
}