import 'package:bestapp_package/bestapp_package.dart';

class AuthRequired {
  Function(bool isAuthenticated) authFunction;
  AuthRequiredType type;
  AuthRequired({
    this.type = AuthRequiredType.DEFAULT,
    this.authFunction,
  });
}