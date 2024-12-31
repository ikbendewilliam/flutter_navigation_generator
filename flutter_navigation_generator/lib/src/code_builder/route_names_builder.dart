import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/case_utils.dart';
import 'package:flutter_navigation_generator/src/utils/route_config_extension.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class RouteNamesBuilder {
  final Set<RouteConfig> routes;
  final List<String> removeSuffixes;

  RouteNamesBuilder({
    required this.routes,
    required this.removeSuffixes,
  });

  Spec generate() {
    final pageRoutes = routes
        .where((route) =>
            route.navigationType != NavigationType.dialog &&
            route.navigationType != NavigationType.bottomSheet)
        .toList();
    for (final pageRoute in pageRoutes.toList()) {
      final pageRoute2 = pageRoutes
          .firstWhere((element) => element.routeName == pageRoute.routeName);
      if (pageRoute != pageRoute2) {
        pageRoutes.remove(pageRoute);
      }
    }
    return Class(
      (b) => b
        ..name = 'RouteNames'
        ..fields.addAll(
          pageRoutes
              .where((pageRoute) => !pageRoute.routeNameContainsParameters)
              .map(
            (pageRoute) {
              final url =
                  "${pageRoute.routeName.startsWith('/') ? '' : '/'}${pageRoute.routeNameIsDefinedByAnnotation ? pageRoute.routeName : CaseUtil(pageRoute.routeName, removeSuffixes: removeSuffixes).textWithoutSuffix}";
              return Field(
                (b) => b
                  ..name = pageRoute.asRouteName
                  ..static = true
                  ..docs.add('/// $url')
                  ..modifier = FieldModifier.constant
                  ..assignment = Code("'$url'"),
              );
            },
          ),
        )
        ..methods.addAll(
          pageRoutes
              .where((pageRoute) => pageRoute.routeNameContainsParameters)
              .map(
            (pageRoute) {
              final parameters =
                  pageRoute.routeName.parametersFromRouteName.map(
                (parameter) {
                  final argument = pageRoute.parameters.firstWhereOrNull(
                      (element) => element.type.name == parameter);
                  if (argument == null) {
                    printBoxed(
                        'Parameter $parameter is not defined in the constructor of ${pageRoute.routeWidget.className}, but is in the routeName ${pageRoute.routeName}');
                  }
                  return Parameter(
                    (b) => b
                      ..name = CaseUtil(parameter).camelCase
                      ..named = true
                      ..type = Reference(
                          'String${argument?.type.isRequired != true ? '?' : ''}')
                      ..required = argument?.type.isRequired == true,
                  );
                },
              ).whereNotNull();
              final url =
                  "${pageRoute.routeName.startsWith('/') ? '' : '/'}${pageRoute.routeNameIsDefinedByAnnotation ? pageRoute.routeName : CaseUtil(pageRoute.routeName, removeSuffixes: removeSuffixes).textWithoutSuffix}";
              return Method(
                (b) => b
                  ..name = pageRoute.asRouteName
                  ..static = true
                  ..returns = refer('String')
                  ..lambda = true
                  ..docs.add('/// $url')
                  ..optionalParameters.addAll(
                    parameters,
                  )
                  ..body = Code("'$url'".replaceAll(':', r'$')),
              );
            },
          ),
        ),
    );
  }
}
