import 'dart:convert';
import 'dart:developer';
import 'package:bestapp_package/bestapp_package.dart';

class ApiHelpers {

  static Map<String, dynamic> messageTag(dynamic data, String defaultMsg){
    if(data != null){
      if(data is Map){
        if(data.containsKey('msg')){
          return {
            ...data as Map<String, dynamic>,
            'message': data['msg']
          };
        }else if(data.containsKey('detail')){
          return {
            ...data as Map<String, dynamic>,
            'message': data['detail']
          };
        }else if(data.containsKey('descrição')){
          return {
            ...data as Map<String, dynamic>,
            'message': data['descrição']
          };
        }else if(data.containsKey('Mensagem')){
          return {
            ...data as Map<String, dynamic>,
            'message': data['Mensagem']
          };
        }else if(data.containsKey('Descrição')){
          return {
            ...data as Map<String, dynamic>,
            'message': data['Descrição']
          };
        }else if(data.containsKey('error')){
          return {
            ...data as Map<String, dynamic>,
            'message': data['error']
          };
        }else if(data.containsKey('mensagem')){
          return {
            ...data as Map<String, dynamic>,
            'message': data['mensagem']
          };
        }else{
          return data as Map<String, dynamic>;
        }
      }
    }
    return {
      'message': defaultMsg
    };
  }
  

  static bool isJsonparsed(String? value){
    if(value == null)return false;
    try {
      jsonDecode(value) as Map<String, dynamic>?;
      return true;
    } catch (e) {
      return false;
    }
  }

  static Response customResponseReturn(RequestOptions options, String message){
    Response response = Response(
      requestOptions: options,
      data: {
        'message': message
      }
    );
    return response;
  }
  
  static logsRequest(Response? response, String titleMsg){
    // log('***** $titleMsg ***** \nURL: ${response.requestOptions.uri} \nSTATUS: ${response != null ? response.statusCode : 'unknow'} \nMETHOD: ${response.requestOptions.method} \nHEADER: ${response.requestOptions.headers} \nBODY: ${response != null ? response.data : {}}');
    log('***** $titleMsg ***** \nURL: ${response?.requestOptions.uri} \nSTATUS: ${response != null ? response.statusCode : 'unknow'} \nMETHOD: ${response?.requestOptions.method} \nHEADER: ${response?.requestOptions.headers}');
  }

  static logsError(DioError? error, String titleMsg){
    log('***** $titleMsg ***** \nURL: ${error?.requestOptions.uri} \nTYPE: ${error != null ? error.type : 'unknow'} \nMETHOD: ${error?.requestOptions.method} \nHEADER: ${error?.requestOptions.headers} \nERROR: ${error != null ? error.message.toString() : {}}');
  }
  
  static bool isJsonParsable(string){
    try {
      json.decode(string);
    } catch (e) {
      return false;
    }
    return true;
  }

  static String defineMethod(ApiMethod type){
    switch (type) {
      case ApiMethod.POST:
        return 'POST';
      case ApiMethod.GET:
        return 'GET';
      case ApiMethod.PUT:
        return 'PUT';
      case ApiMethod.PATCH:
        return 'PATCH';
      case ApiMethod.DELETE:
        return 'DELETE';
      default:
        return 'NO_METHOD';
    }
  }
  

  /*
    Successful - 2xx
    This class of status code indicates that the client's 
      request was successfully received, understood, and accepted.
    HTTP_200_OK
    HTTP_201_CREATED
    HTTP_202_ACCEPTED
    HTTP_203_NON_AUTHORITATIVE_INFORMATION
    HTTP_204_NO_CONTENT
    HTTP_205_RESET_CONTENT
    HTTP_206_PARTIAL_CONTENT
    HTTP_207_MULTI_STATUS
    HTTP_208_ALREADY_REPORTED
    HTTP_226_IM_USED
  */
  static bool isSuccess(int? statusCode){
    switch (statusCode) {
      case 200:
        return true;
      case 201:
        return true;
      case 202:
        return true;
      case 203:
        return true;
      case 204:
        return true;
      case 205:
        return true;
      case 206:
        return true;
      case 207:
        return true;
      case 208:
        return true;
      case 226:
        return true;
      default:
        return false;
    }
  }


  /*
    Informational - 1xx

    This class of status code indicates a provisional response. 
      There are no 1xx status codes used in REST framework by default.

    HTTP_100_CONTINUE
    HTTP_101_SWITCHING_PROTOCOLS
  */
  static bool isInformational(int? statusCode){
    switch (statusCode) {
      case 100:
        return true;
      case 101:
        return true;
      default:
        return false;
    }
  }


  /*
    Redirection - 3xx

    This class of status code indicates that further 
      action needs to be taken by the user agent in order to fulfill the request.

    HTTP_300_MULTIPLE_CHOICES
    HTTP_301_MOVED_PERMANENTLY
    HTTP_302_FOUND
    HTTP_303_SEE_OTHER
    HTTP_304_NOT_MODIFIED
    HTTP_305_USE_PROXY
    HTTP_306_RESERVED
    HTTP_307_TEMPORARY_REDIRECT
    HTTP_308_PERMANENT_REDIRECT
  */
  static bool isRedirect(int? statusCode){
    switch (statusCode) {
      case 300:
        return true;
      case 301:
        return true;
      case 302:
        return true;
      case 303:
        return true;
      case 304:
        return true;
      case 305:
        return true;
      case 306:
        return true;
      case 307:
        return true;
      case 308:
        return true;
      default:
        return false;
    }
  }


  /*
    Client Error - 4xx

    The 4xx class of status code is intended for 
      cases in which the client seems to have erred. 
      Except when responding to a HEAD request, the server 
      SHOULD include an entity containing an explanation of the error situation, 
      and whether it is a temporary or permanent condition.

    HTTP_400_BAD_REQUEST
    HTTP_401_UNAUTHORIZED
    HTTP_402_PAYMENT_REQUIRED
    HTTP_403_FORBIDDEN
    HTTP_404_NOT_FOUND
    HTTP_405_METHOD_NOT_ALLOWED
    HTTP_406_NOT_ACCEPTABLE
    HTTP_407_PROXY_AUTHENTICATION_REQUIRED
    HTTP_408_REQUEST_TIMEOUT
    HTTP_409_CONFLICT
    HTTP_410_GONE
    HTTP_411_LENGTH_REQUIRED
    HTTP_412_PRECONDITION_FAILED
    HTTP_413_REQUEST_ENTITY_TOO_LARGE
    HTTP_414_REQUEST_URI_TOO_LONG
    HTTP_415_UNSUPPORTED_MEDIA_TYPE
    HTTP_416_REQUESTED_RANGE_NOT_SATISFIABLE
    HTTP_417_EXPECTATION_FAILED
    HTTP_422_UNPROCESSABLE_ENTITY
    HTTP_423_LOCKED
    HTTP_424_FAILED_DEPENDENCY
    HTTP_426_UPGRADE_REQUIRED
    HTTP_428_PRECONDITION_REQUIRED
    HTTP_429_TOO_MANY_REQUESTS
    HTTP_431_REQUEST_HEADER_FIELDS_TOO_LARGE
    HTTP_451_UNAVAILABLE_FOR_LEGAL_REASONS
  */
  static bool isUnauthorized(int? statusCode){
    switch (statusCode) {
      case 401:
        return true;
      case 403:
        return true;
      case 407:
        return true;
      default:
        return false;
    }
  }

  static bool isClientError(int? statusCode){
    switch (statusCode) {
      case 400:
        return true;
      case 401:
        return true;
      case 402:
        return true;
      case 403:
        return true;
      case 404:
        return true;
      case 405:
        return true;
      case 406:
        return true;
      case 407:
        return true;
      case 408:
        return true;
      case 409:
        return true;
      case 410:
        return true;
      case 411:
        return true;
      case 412:
        return true;
      case 413:
        return true;
      case 414:
        return true;
      case 415:
        return true;
      case 416:
        return true;
      case 417:
        return true;
      case 422:
        return true;
      case 424:
        return true;
      case 426:
        return true;
      case 428:
        return true;
      case 429:
        return true;
      case 431:
        return true;
      case 451:
        return true;
      default:
        return false;
    }
  }


  /*
    Server Error - 5xx

    Response status codes beginning with the digit "5" indicate cases in which the server is aware 
      that it has erred or is incapable of performing the request. 
      Except when responding to a HEAD request, the server SHOULD include an entity 
      containing an explanation of the error situation, 
      and whether it is a temporary or permanent condition.

    HTTP_500_INTERNAL_SERVER_ERROR
    HTTP_501_NOT_IMPLEMENTED
    HTTP_502_BAD_GATEWAY
    HTTP_503_SERVICE_UNAVAILABLE
    HTTP_504_GATEWAY_TIMEOUT
    HTTP_505_HTTP_VERSION_NOT_SUPPORTED
    HTTP_506_VARIANT_ALSO_NEGOTIATES
    HTTP_507_INSUFFICIENT_STORAGE
    HTTP_508_LOOP_DETECTED
    HTTP_509_BANDWIDTH_LIMIT_EXCEEDED
    HTTP_510_NOT_EXTENDED
    HTTP_511_NETWORK_AUTHENTICATION_REQUIRED

  */
  static bool isServerError(int? statusCode){
    switch (statusCode) {
      case 500:
        return true;
      case 501:
        return true;
      case 502:
        return true;
      case 503:
        return true;
      case 504:
        return true;
      case 505:
        return true;
      case 506:
        return true;
      case 507:
        return true;
      case 508:
        return true;
      case 509:
        return true;
      case 510:
        return true;
      case 511:
        return true;
      default:
        return false;
    }
  }

  static bool isNotConected(int? statusCode){
    switch (statusCode) {
      case 101:
        return true;
      case 100:
        return true;
      case 305:
        return true;
      case 403:
        return true;
      case 407:
        return true;
      case 401:
        return true;
      case 502:
        return true;
      case 503:
        return true;
      case 504:
        return true;
      case 507:
        return true;
      case 511:
        return true;
      default:
        return false;
    }
  }
}


