// import 'dart:io';
// import 'package:flutter_image_compress_web/flutter_image_compress_web.dart';
// import 'package:path_provider/path_provider.dart';

// Future <File?> compressImages(String pathImages, int qualityImage) async {
//   print("Start compress");
//   var tmpDir = (await getTemporaryDirectory()).path;
//   final target = "$tmpDir/${DateTime.now().millisecondsSinceEpoch}.jpg";
//   XFile? imagecompress = await FlutterImageCompressWeb.compressAndGetFile(pathImages, target, quality: qualityImage);
//   return File(imagecompress!.path);
// }