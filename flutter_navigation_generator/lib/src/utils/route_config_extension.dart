import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/case_utils.dart';

extension RouteConfigExtension on RouteConfig {
  String get asRouteName {
    final name = CaseUtil(routeName, alternativeText: methodName).camelCase;
    if (name.startsWith(RegExp(r'[0-9]'))) return 'r$name';
    return name;
  }
}
