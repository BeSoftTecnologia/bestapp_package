import 'package:bestapp_package/src/utils/app_directory.dart';

Future<String> getCookiePath() async {
  return await Appdirctory('cookies').getDirectory();
}
