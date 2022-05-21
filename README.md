# bestapp_package

A new Flutter package project.
tipo de alertas.

snackbar
toast
dialog
## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.



```
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class webFunctions {
  final Dio _dio = Dio();
  PersistCookieJar persistentCookies;
  final String URL = "http://test/";

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Directory> get _localCoookieDirectory async {
    final path = await _localPath;
    final Directory dir = new Directory('$path/cookies');
    await dir.create();
    return dir;
  }

  Future<String> getCsrftoken() async{
    try {
      String csrfTokenValue;
      final Directory dir = await _localCoookieDirectory;
      final cookiePath = dir.path;
      persistentCookies = new PersistCookieJar(dir: '$cookiePath');
      persistentCookies.deleteAll(); //clearing any existing cookies for a fresh start
      _dio.interceptors.add(
          CookieManager(persistentCookies) //this sets up _dio to persist cookies throughout subsequent requests
      );
      _dio.options = new BaseOptions(
        baseUrl: URL,
        contentType: ContentType.json,
        responseType: ResponseType.plain,
        connectTimeout: 5000,
        receiveTimeout: 100000,
        headers: {
          HttpHeaders.userAgentHeader: "dio",
          "Connection": "keep-alive",
        },
      ); //BaseOptions will be persisted throughout subsequent requests made with _dio
      _dio.interceptors.add(
          InterceptorsWrapper(
              onResponse:(Response response) {
                List<Cookie> cookies = persistentCookies.loadForRequest(Uri.parse(URL));
                csrfTokenValue = cookies.firstWhere((c) => c.name == 'csrftoken', orElse: () => null)?.value;
                if (csrfTokenValue != null) {
                  _dio.options.headers['X-CSRF-TOKEN'] = csrfTokenValue; //setting the csrftoken from the response in the headers
                }
                return response;
              }
          )
      );
      await _dio.get("/accounts/login/");
      return csrfTokenValue;
    } catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }

  getSessionId() async {
    try {
      final csrf = await getCsrftoken();
      FormData formData = new FormData.from({
        "username": "username",
        "password": 'A *passphrase* is stronger than a password.',
        "csrfmiddlewaretoken" : '$csrf'
      });
      Options optionData = new Options(
        contentType: ContentType.parse("application/x-www-form-urlencoded"),
      );
      Response response = await _dio.post("/accounts/login/", data: formData, options: optionData);
      print(response.statusCode);
    } on DioError catch(e) {
      if(e.response != null) {
        print( e.response.statusCode.toString() + " " + e.response.statusMessage);
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else{
        print(e.request);
        print(e.message);
      }
    }
    catch (error, stacktrace) {
      print("Exception occured: $error stackTrace: $stacktrace");
      return null;
    }
  }
}
```