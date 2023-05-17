import 'dart:async';
import 'dart:convert';
import 'package:bestapp_package/bestapp_package.dart';
// import 'package:bestapp_package/src/utils/helpers/api_helpers.dart';
// import 'package:bestapp_package/src/utils/devices_info.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

export 'package:bestapp_package/src/models/api_config.dart';

class ApiResponseModel {
  bool isInformational;
  bool isSuccess;
  bool isRedirect;
  bool isClientError;
  bool isServerError;
  bool isAuthorized;
  bool isNotConected;
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
    this.data = const {},
    this.response
  });
}
/*
  ******** Msg Error ********
  Erro ao sincronizar com o servidor!\nProvavelmente você não está conectado à internet.
  Feche e reabra o app e tente novamente.
  Alguma coisa deu errado. Se o erro persistir, entre em contato com o suporte.
*/

enum TypeHeader {SESSIONID, TOKEN}
enum TypeBody {JSON, FORMDATA}
enum ApiMethod {POST, PUT, DELETE, GET, PATCH}

class ApiServices {
  /* baseURL es para iniciar a clase com o endpoint
    se usar o parametro apiConfig dentro do callAPi ele desconsidera esa variavel.
  */
  final String? baseUrl;
  final bool showLogs;
  final Dio dio = Dio();
  final BeDevicesInfo beDevicesInfo = BeDevicesInfo();
  final Appdirctory appdirctory = Appdirctory('cookies');
  ApiServices({
    this.baseUrl,
    this.showLogs=false
  });

  Future<ApiResponseModel> callApi({
    required ApiMethod method,
    required rota,
    Map<String, dynamic>? params,
    Map<String, dynamic>? payload,
    void Function(int, int)? onSendProgress,
    TypeBody typeBody = TypeBody.JSON,
    TypeHeader typeHeader = TypeHeader.SESSIONID,
    ApiConfig? apiConfig,
    ValueChanged<bool>? authRequired
  }) async {
    Map<String, dynamic> headers = {};
    ApiResponseModel responseModel = ApiResponseModel();
    String? _userAgent = await beDevicesInfo.getDevicesInfo();
    
    headers['User-Agent'] = _userAgent;
    if(typeBody != TypeBody.FORMDATA){
      headers['Accept'] = 'application/json';
      headers['Content-Type'] = 'application/json';
    }
    
    if(typeBody == TypeBody.FORMDATA)headers['Accept'] = '*/*';
    if(typeHeader == TypeHeader.TOKEN && apiConfig != null)headers['Authorization'] = apiConfig.token;
    if(kIsWeb && typeHeader == TypeHeader.SESSIONID && apiConfig != null)headers['Cookie'] = 'sessionid=${apiConfig.token}';

    dio.options.baseUrl = apiConfig != null && apiConfig.baseUrl != null && apiConfig.baseUrl != '' ? '${apiConfig.baseUrl}/' : '$baseUrl/';
    dio.options.headers = headers;
    dio.options.method = ApiHelpers.defineMethod(method);
    dio.options.responseType = ResponseType.json;
    dio.interceptors.clear();

    RequestOptions _customOption =  RequestOptions(
      baseUrl: apiConfig != null && apiConfig.baseUrl != null && apiConfig.baseUrl != '' ? '${apiConfig.baseUrl}/' : '$baseUrl/',
      headers: headers,
      method: ApiHelpers.defineMethod(method),
      path: rota
    );

    /********* COOKIES CONFIG ***********/
    if(!kIsWeb){
      String cookiePath = await appdirctory.getDirectory();
      if(typeHeader == TypeHeader.SESSIONID){
        dio.interceptors.add(
          CookieManager(
            PersistCookieJar(
              storage:  FileStorage('$cookiePath')
            )
          )
        );
      }
    }
    /*********** ************* ***********/


    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (response,handler){
          responseModel.isAuthorized = true;
          responseModel.isSuccess = ApiHelpers.isSuccess(response.statusCode);
          if(authRequired != null)authRequired(responseModel.isAuthorized);
          if(response.data is Map){
            if(showLogs) ApiHelpers.logsRequest(response, 'REQUEST SUCCESSFULL :)');
            return handler.resolve(response);
          }else if(response.data is String){
            if(ApiHelpers.isJsonparsed(response.data)){
              response.data = jsonDecode(response.data);
            }else{
              response.data = {
                'message': 'sucesso!'
              };
            }
          }else if(response.data is List){
            response.data = {
              'message': 'sucesso!',
              'results': response.data
            };
          }else{
            response.data = {
              'message': 'Sucesso!'
            };
          }
          if(showLogs) ApiHelpers.logsRequest(response, 'REQUEST SUCCESSFULL :)');
          return handler.resolve(response);
        },
        onError: (DioError err, handler) {

          switch (err.type) {
            case DioErrorType.response:
              responseModel.isClientError = ApiHelpers.isClientError(err.response?.statusCode);
              responseModel.isServerError = ApiHelpers.isServerError(err.response?.statusCode);
              responseModel.isRedirect = ApiHelpers.isRedirect(err.response?.statusCode);
              responseModel.isInformational = ApiHelpers.isRedirect(err.response?.statusCode);
              responseModel.isNotConected = ApiHelpers.isRetrive(err.response?.statusCode);
              // Esas mensagem o retorno no json final sempre vai ter a tag message,
              // Quando o tipo da mensagem nao e definido
              // Para usar a mensagem padrao do usuario ou o proveedor
              // Precisa validar os if no caso que tipo de retorne e.
              if(responseModel.isClientError){
                if(ApiHelpers.isUnauthorized(err.response?.statusCode)){
                  responseModel.isAuthorized = false;
                  if(authRequired != null)authRequired(responseModel.isAuthorized);
                  err.response!.data = ApiHelpers.messageTag(err.response?.data, 'As credenciais de autenticação não foram fornecidas.');
                }else{
                  err.response!.data = ApiHelpers.messageTag(err.response?.data, 'Não foi possível completar sua consulta.');
                }
              }else if(responseModel.isServerError){
                err.response!.data = ApiHelpers.messageTag(err.response?.data, 'Há um problema no nosso servidor, tente mais tarde.');
              }else if(responseModel.isRedirect){
                err.response!.data = ApiHelpers.messageTag(err.response?.data, 'Unknow Status _isRedirect');
              }else if(responseModel.isInformational){
                err.response!.data = ApiHelpers.messageTag(err.response?.data, 'Unknow Status _isInformational');
              }else{
                err.response!.data = ApiHelpers.messageTag(err.response?.data, 'Unknow Status');
              }
              
              if(showLogs) ApiHelpers.logsRequest(err.response!, 'REQUEST ERROR :(');
              return handler.resolve(err.response!);
            case DioErrorType.other:
              responseModel.isNotConected = true;
              if(showLogs)ApiHelpers.logsError(err, 'ERROR :(');
              Response response = ApiHelpers.customResponseReturn(_customOption, 'Alguma coisa deu errado!\nProvavelmente você não está conectado à internet.');
              return handler.resolve(response);
            default:
              if(showLogs)ApiHelpers.logsError(err, 'ERROR :(');
              Response response = ApiHelpers.customResponseReturn(_customOption, 'Alguma coisa deu errado. Se o erro persistir, entre em contato com o suporte.');
              return handler.resolve(response);
          }
        }
      )
    );
    
    responseModel.response = await dio.request(
      rota,
      onSendProgress: onSendProgress,
      data: typeBody == TypeBody.FORMDATA ? FormData.fromMap(payload!) : payload,
      queryParameters: params
    );
    responseModel.data = responseModel.response?.data;
    return responseModel;
  }
}