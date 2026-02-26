import 'package:device_info_plus/device_info_plus.dart';

class BeDevicesInfo {
  Future<String?> getDevicesInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    return webBrowserInfo.userAgent;
  }
}
