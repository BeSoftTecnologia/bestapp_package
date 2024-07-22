import 'package:dio/dio.dart';

class ApiResponseModel {
  bool isInformational;
  bool isSuccess;
  bool isRedirect;
  bool isClientError;
  bool isServerError;
  bool isAuthorized;
  bool isNotConected;
  int? statusCode;
  Response? response;
  Map<String, dynamic> data;

  ApiResponseModel({
    this.isInformational = false,
    this.isSuccess = false,
    this.isRedirect  = false,
    this.isClientError = false,
    this.isServerError = false,
    this.isAuthorized = false,
    this.isNotConected = false,
    this.statusCode,
    this.data = const {},
    this.response
  });

  @override
  String toString() {
    return 'ApiResponseModel(isInformational: $isInformational, isSuccess: $isSuccess, isRedirect: $isRedirect, isClientError: $isClientError, isServerError: $isServerError, isAuthorized: $isAuthorized, isNotConected: $isNotConected, response: $response, data: $data)';
  }
}