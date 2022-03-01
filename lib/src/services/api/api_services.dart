import 'dart:async';
import 'dart:convert';
import 'package:bestapp_package/bestapp_package.dart';
import 'package:bestapp_package/src/services/api/api_helpers.dart';
import 'package:flutter/material.dart';
export 'package:bestapp_package/src/models/api_config.dart';

/*
  ******** Msg Error ********
  Erro ao sincronizar com o servidor!\nProvavelmente você não está conectado à internet.
  Feche e reabra o app e tente novamente.
  Alguma coisa deu errado. Se o erro persistir, entre em contato com o suporte.
*/

enum TypeHeader {SESSIONID, TOKEN}
enum TypeBody {JSON, FORMDATA}
enum ApiMethod {POST, PUT, DELETE, GET}

class ApiServices {
  /* baseURL es para iniciar a clase com o endpoint
    se usar o parametro apiConfig dentro do callAPi ele desconsidera esa variavel.
  */
  final String baseUrl;
  final Dio dio = Dio();
  
  ApiServices({
    this.baseUrl
  });

  bool _isInformational = false;
  bool _isSuccess = false;
  bool _isRedirect = false;
  bool _isClientError = false;
  bool _isServerError = false;

  bool get isInformational => _isInformational;
  bool get isSuccess => _isSuccess;
  bool get isRedirect => _isRedirect;
  bool get isClientError => _isClientError;
  bool get isServerError => _isServerError;

  Future<Map<String, dynamic>> callApi({
    @required ApiMethod method,
    @required rota,
    Map<String, dynamic> params,
    Map<String, dynamic> payload,
    void Function(int, int) onSendProgress,
    TypeBody typeBody = TypeBody.JSON,
    TypeHeader typeHeader = TypeHeader.SESSIONID,
    ApiConfig apiConfig
  }) async {
    Map<String, dynamic> headers;
    _isInformational = false;
    _isSuccess = false;
    _isRedirect = false;
    _isClientError = false;
    _isServerError = false;

    if(typeBody != TypeBody.FORMDATA){
      headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      };
    }


    if(typeBody == TypeBody.FORMDATA){
      headers = {
        'Accept': '*/*'
      };
    }
    
    if(apiConfig != null && apiConfig.token != null && apiConfig.token != ''){
      if(typeHeader == TypeHeader.TOKEN)headers['Authorization'] = apiConfig.token;
      if(typeHeader == TypeHeader.SESSIONID)headers['Cookie'] = 'sessionid=${apiConfig.token}';
    }

    dio.options.baseUrl = apiConfig != null && apiConfig.baseUrl != null && apiConfig.baseUrl != '' ? '${apiConfig.baseUrl}/' : '$baseUrl/';
    dio.options.headers = headers;
    dio.options.method = ApiHelpers.defineMethod(method);
    dio.options.responseType = ResponseType.json;
    dio.interceptors.clear();

    RequestOptions _customOption =  RequestOptions(
      baseUrl: baseUrl,
      headers: headers,
      method: ApiHelpers.defineMethod(method),
      path: rota
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response,handler){
          _isSuccess = ApiHelpers.isSuccess(response.statusCode);
          if(response.data is Map){
            ApiHelpers.logsRequest(response, 'REQUEST SUCCESSFULL :)');
            return handler.resolve(response);
          }else if(response.data is String){
            if(ApiHelpers.isJsonparsed(response.data)){
              response.data = jsonDecode(response.data);
            }else{
              response.data = {
                'message': 'sucesso!'
              };
            }
          }else{
            response.data = {
              'message': 'Sucesso!'
            };
          }
          ApiHelpers.logsRequest(response, 'REQUEST SUCCESSFULL :)');
          return handler.resolve(response);
        },
        onError: (DioError err, handler) {
          _isClientError = false;
          _isServerError = false;
          _isRedirect = false;
          _isInformational = false;
          switch (err.type) {
            case DioErrorType.response:
              _isClientError = ApiHelpers.isClientError(err.response.statusCode);
              _isServerError = ApiHelpers.isServerError(err.response.statusCode);
              _isRedirect = ApiHelpers.isRedirect(err.response.statusCode);
              _isInformational = ApiHelpers.isRedirect(err.response.statusCode);

              // Esas mensagem o retorno no json final sempre vai ter a tag message,
              // Quando o tipo da mensagem nao e definido
              // Para usar a mensagem padrao do usuario ou o proveedor
              // Precisa validar os if no caso que tipo de retorne e.
              if(_isClientError){
                err.response.data = ApiHelpers.messageTag(err.response.data, 'Não foi possível completar sua consulta.');
              }else if(_isServerError){
                err.response.data = ApiHelpers.messageTag(err.response.data, 'Há um problema no nosso servidor, tente mais tarde.');
              }else if(_isRedirect){
                err.response.data = ApiHelpers.messageTag(err.response.data, 'Unknow Status _isRedirect');
              }else if(_isInformational){
                err.response.data = ApiHelpers.messageTag(err.response.data, 'Unknow Status _isInformational');
              }else{
                err.response.data = ApiHelpers.messageTag(err.response.data, 'Unknow Status');
              }
              ApiHelpers.logsRequest(err.response, 'REQUEST ERROR :(');
              return handler.resolve(err.response);
            case DioErrorType.other:
              ApiHelpers.logsError(err, 'ERROR :(');
              Response response = ApiHelpers.customResponseReturn(_customOption, 'Alguma coisa deu errado!\nProvavelmente você não está conectado à internet.');
              return handler.resolve(response);
            default:
              ApiHelpers.logsError(err, 'ERROR :(');
              Response response = ApiHelpers.customResponseReturn(_customOption, 'Alguma coisa deu errado. Se o erro persistir, entre em contato com o suporte.');
              return handler.resolve(response);
          }
        }
      )
    );
    
    Response response =  await dio.request(
      rota,
      onSendProgress: onSendProgress,
      data: typeBody == TypeBody.FORMDATA ? FormData.fromMap(payload) : payload,
      queryParameters: params
    );
    return response.data;
  }
}