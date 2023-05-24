import 'dart:async';
import 'dart:convert';
import 'package:bestapp_package/bestapp_package.dart';
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

  @override
  String toString() {
    return 'ApiResponseModel(isInformational: $isInformational, isSuccess: $isSuccess, isRedirect: $isRedirect, isClientError: $isClientError, isServerError: $isServerError, isAuthorized: $isAuthorized, isNotConected: $isNotConected, response: $response, data: $data)';
  }
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
    
    try {
      Response responseResult = await dio.request(
        rota,
        onSendProgress: onSendProgress,
        data: typeBody == TypeBody.FORMDATA ? FormData.fromMap(payload!) : payload,
        queryParameters: params
      );
      if(showLogs) ApiHelpers.logsRequest(responseResult, 'REQUEST SUCCESSFULL :)');
      responseModel.response = responseResult;
      responseModel.isAuthorized = true;
      responseModel.isSuccess = ApiHelpers.isSuccess(responseResult.statusCode);
      if(authRequired != null)authRequired(responseModel.isAuthorized);

      if(responseResult.data is Map){
        responseModel.data = responseResult.data;
      }else if(responseResult.data is String){
        if(ApiHelpers.isJsonparsed(responseResult.data)){
          responseModel.data = jsonDecode(responseResult.data);
        }else{
          responseModel.data = {
            'message': 'sucesso!'
          };
        }
      }else if(responseModel.data is List){
        responseModel.data = {
          'message': 'sucesso!',
          'results': responseModel.data
        };
      }else{
        responseModel.data = {
          'message': 'Sucesso!'
        };
      }
    } on DioError catch (err) {
      // Faz a copia do response original
      responseModel.response = err.response;
      switch (err.type) {
        case DioErrorType.badResponse:
          /*
            No retorno das mensagem json sempre vai ter a chave `message` no json Quando o tipo da mensagem nao e definido
            Para usar a mensagem padrao do usuario ou do proveedor Precisa validar os if no caso que tipo de retorne err.
            -------------------------
            Esses if feito aqui e  para validar todos os diferentes tipos de status, facilitando 
            o retorno de essa classe na hora de fazer os ifs..
            enves de usar statusCode para verificar se o retorno de json for sucesso ou erro
            pode usar uma de essas flags para validar. EX.: if (isClientError) enves de if(err.response?.statusCode == 400)
          */
          if(showLogs) ApiHelpers.logsRequest(err.response!, 'REQUEST ERROR :(');
          
          if(ApiHelpers.isClientError(err.response?.statusCode)){
            responseModel.isClientError = true;
            // Verifica se o usuario esta autenticado
            if(ApiHelpers.isUnauthorized(err.response?.statusCode)){
              responseModel.isAuthorized = false;
              // Se receber o parametro de autenticacao obrigatoria ele retorna isso em algum middle para tratamento no frontend
              if(authRequired != null)authRequired(responseModel.isAuthorized);
              responseModel.data = ApiHelpers.messageTag(err.response?.data, 'As credenciais de autenticação não foram fornecidas.');
            }else{
              responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Não foi possível completar sua consulta.');
            }
          }else if(ApiHelpers.isServerError(err.response?.statusCode)){
            responseModel.isServerError = true;
            responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Há um problema no nosso servidor, tente mais tarde.');
          }else if(ApiHelpers.isRedirect(err.response?.statusCode)){
            responseModel.isRedirect = true;
            responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Unknow Status _isRedirect');
          }else if(ApiHelpers.isInformational(err.response?.statusCode)){
            responseModel.isInformational = true;
            responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Unknow Status _isInformational');
          }else if(ApiHelpers.isNotConected(err.response?.statusCode)){
            responseModel.isNotConected = true;
            responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Unknow Status _isInformational');
          }else{
            responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Unknow Status');
          }
          break;
        case DioErrorType.badCertificate:
          responseModel.isServerError = true;
          responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Certificado invalido, tente mais tarde');
          break;
        case DioErrorType.connectionTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          responseModel.isServerError = true;
          responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Timeout: O tempo limite foi atingido');
          break;
        case DioErrorType.cancel:
          responseModel.isClientError = true;
          responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Requisição cancelada');
          break;
        case DioErrorType.connectionError:
          responseModel.isClientError = true;
          responseModel.isServerError = true;
          responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Alguma coisa deu errado `xhr.onError`. Se o erro persistir, entre em contato com o suporte.');
          break;
        case DioErrorType.unknown:
          responseModel.isNotConected = true;
          responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Alguma coisa deu errado!\nProvavelmente você não está conectado à internet.');
          break;
        default:
          responseModel.data = ApiHelpers.messageTag(err.response?.data, 'Alguma coisa deu errado. Se o erro persistir, entre em contato com o suporte.');

      }
    }
    return responseModel;
  }
}