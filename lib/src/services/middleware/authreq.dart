import 'package:bestapp_package/src/models/auth_model.dart';
import 'package:bestapp_package/src/models/enums.dart';
import 'package:bestapp_package/src/services/nav_services.dart';
import 'package:bestapp_package/src/utils/helpers/api_helpers.dart';
import 'package:dio/dio.dart';

class AuthManager extends Interceptor {
  final AuthRequired authRequired;
  AuthManager(this.authRequired);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if(authRequired.type == AuthRequiredType.CUSTOM){
      authRequired.authFunction(true);
    }
    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.type == DioErrorType.response){
      bool isUnauthorized = ApiHelpers.isUnauthorized(err.response.statusCode);
      // Default auth controle login
      if(isUnauthorized && (authRequired.type == AuthRequiredType.DEFAULT)){
        NavigationService.navigateReplacementTo('/login');
      }
      if(isUnauthorized && (authRequired.type == AuthRequiredType.CUSTOM)){
        authRequired.authFunction(false);
      }
    }
    handler.next(err);
  }
}