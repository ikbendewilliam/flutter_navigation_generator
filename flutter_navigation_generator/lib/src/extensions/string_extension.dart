// import 'package:code_builder/code_builder.dart';
// import 'package:flutter_navigation_generator/src/models/route_config.dart';
// import 'package:flutter_navigation_generator/src/utils/case_utils.dart';

// extension StringExtension on String {
//   String toFieldName(RouteConfig routeConfig, Iterable<RouteConfig> routes) {
//     var name = routeConfig.routeName;
//     if (routes.where((r) => r.routeName == routeConfig.routeName).length >= 2) {
//       name = this;
//     }
//     // print('name is $name, routeConfig.routeName: ${routeConfig.routeName}, alternativeText: ${routeConfig.methodName}');
//     name = CaseUtil(name, alternativeText: routeConfig.methodName).camelCase;
//     // print('newName: $name');
//     if (name.startsWith(RegExp(r'[0-9]'))) return 'r$name';
//     return name;
//   }

//   Expression toFieldNameExpression(RouteConfig routeConfig, Iterable<RouteConfig> routes) => Reference('RouteNames.${toFieldName(routeConfig, routes)}');
// }
