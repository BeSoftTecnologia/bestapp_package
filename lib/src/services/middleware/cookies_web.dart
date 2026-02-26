import 'dart:async';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';

/// Stub CookieManager for Web/WASM.
/// Cookies on web are managed by the browser automatically via withCredentials.
class CookieManager extends Interceptor {
  final CookieJar cookieJar;

  CookieManager(this.cookieJar);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }

  static String getCookies(List cookies) {
    return '';
  }
}
