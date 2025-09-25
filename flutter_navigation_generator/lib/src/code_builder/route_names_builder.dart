import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:flutter_navigation_generator/src/extensions/route_config_extension.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/case_utils.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class RouteNamesBuilder {
  final Set<RouteConfig> routes;
  final List<String> removeSuffixes;

  RouteNamesBuilder({required this.routes, required this.removeSuffixes});

  Spec generate() {
    final pageRoutes = routes.where((route) => route.navigationType != NavigationType.dialog && route.navigationType != NavigationType.bottomSheet).toList();
    for (final pageRoute in pageRoutes.toList()) {
      final pageRoute2 = pageRoutes.firstWhere((element) => element.routeName == pageRoute.routeName);
      if (pageRoute != pageRoute2) {
        pageRoutes.remove(pageRoute);
      }
    }
    final pageRoutesWithParameters = <String, RouteConfig>{};
    final pageRoutesWithoutParameters = <String, RouteConfig>{};
    for (final pageRoute in pageRoutes) {
      final route = pageRoute.fullRouteName(pageRoutes, removeSuffixes);
      if (route.parametersFromRouteName.isNotEmpty) {
        pageRoutesWithParameters.addAll({route: pageRoute});
      } else {
        pageRoutesWithoutParameters.addAll({route: pageRoute});
      }
    }
    return Class(
      (b) =>
          b
            ..name = 'RouteNames'
            ..fields.addAll(
              pageRoutesWithoutParameters.entries.map((entry) {
                final url = entry.key;
                return Field(
                  (b) =>
                      b
                        ..name = entry.value.asRouteName
                        ..static = true
                        ..docs.add('/// $url')
                        ..modifier = FieldModifier.constant
                        ..assignment = Code("'$url'"),
                );
              }),
            )
            ..methods.addAll(
              pageRoutesWithParameters.entries.map((entry) {
                final url = entry.key;
                final pageRoute = entry.value;
                final parameters =
                    url.parametersFromRouteName.map((parameter) {
                      final argument = pageRoute.parameters.firstWhereOrNull((element) => element.type.name == parameter);
                      if (argument == null) {
                        printBoxed('Parameter $parameter is not defined in the constructor of ${pageRoute.routeWidget.className}, but is in the routeName $url');
                      }
                      return Parameter(
                        (b) =>
                            b
                              ..name = CaseUtil(parameter).camelCase
                              ..named = true
                              ..type = Reference('String${argument?.type.isRequired != true ? '?' : ''}')
                              ..required = argument?.type.isRequired == true,
                      );
                    }).nonNulls;
                return Method(
                  (b) =>
                      b
                        ..name = pageRoute.asRouteName
                        ..static = true
                        ..returns = refer('String')
                        ..lambda = true
                        ..docs.add('/// $url')
                        ..optionalParameters.addAll(parameters)
                        ..body = Code("'$url'".replaceAll(':', r'$')),
                );
              }),
            ),
    );
  }
}
