import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/case_utils.dart';
import 'package:flutter_navigation_generator/src/utils/importable_type_string_converter.dart';

extension RouteConfigExtension on RouteConfig {
  String get asRouteName {
    final name = CaseUtil(routeName, alternativeText: methodName).camelCase;
    if (name.startsWith(RegExp(r'[0-9]'))) return 'r$name';
    return name;
  }

  Expression get asRouteNameExpression => Reference('RouteNames.$asRouteName');

  Expression callRouteNameExpression(Expression expression, List<String> parametersFromRouteName) {
    return expression.call(
      [],
      (parametersFromRouteName.asMap().map((_, parameter) {
        final argument = parameters.firstWhereOrNull((element) => element.type.name == parameter);
        if (argument == null) return MapEntry(parameter, null);
        return MapEntry(parameter, Reference(ImportableTypeStringConverter.convertToString(argument.type)));
      })..removeWhere((key, value) => value == null)).cast(),
    );
  }
}
