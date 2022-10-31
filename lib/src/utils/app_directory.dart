import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';


@deprecated
Future<String> folderInAppDocDir(String folderName) async {
  final Directory _appDocDir = await getApplicationDocumentsDirectory();
  final Directory _appDocDirFolder =  Directory('${_appDocDir.path}/$folderName/');
  if(await _appDocDirFolder.exists()){ //if folder already exists return path
    return _appDocDirFolder.path;
  }else{//if folder not exists create folder and then return its path
    final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
    return _appDocDirNewFolder.path;
  }
}

class Appdirctory {
  final String pathDir;
  Appdirctory(this.pathDir);

  Future<String> getDirectory({bool localPath=true}) async {
    Directory? _appDocDir = await getApplicationDocumentsDirectory();
    if (Platform.isAndroid && localPath) {
      _appDocDir = await (getExternalStorageDirectory() as FutureOr<Directory>);
    }
    final Directory _appDocDirFolder =  Directory('${_appDocDir.path}/$pathDir/');
    if(await _appDocDirFolder.exists()){
      return _appDocDirFolder.path;
    }else{
      final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }
}