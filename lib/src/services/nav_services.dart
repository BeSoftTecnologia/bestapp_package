
import 'package:flutter/material.dart';

class NavigationService {
  // https://ibefx.hashnode.dev/a-nice-way-to-navigate-in-flutter-without-context-cknoptoz10m8dlps12s8pfobp

  /// Creating the first instance
  static final NavigationService _instance = NavigationService._internal();
  NavigationService._internal();

  /// With this factory setup, any time  NavigationService() is called
  /// within the appication _instance will be returned and not a new instance
  factory NavigationService() => _instance;

  /** 
   * This would allow the app to monitor the current screen state during navigation.
   * This is where the singleton setup we did
   * would help as the state is internally maintained 
  **/
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}){
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static dynamic navigateBack([dynamic popValue]){
    return navigatorKey.currentState!.pop(popValue);
  }

  static Future<dynamic> navigateReplacementTo(String routeName, {Object? arguments}){
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateAndRemoveUntilTo(String routeName, {Object? arguments}){
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName, (Route<dynamic> route) => false, arguments: arguments);
  }
}