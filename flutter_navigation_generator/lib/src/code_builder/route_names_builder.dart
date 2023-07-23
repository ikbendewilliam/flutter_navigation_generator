import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/case_utils.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class RouteNamesBuilder {
  static Spec buildRouteNames(Set<RouteConfig> routes, List<String> removeSuffixes) {
    final pageRoutes = routes.where((route) => route.navigationType != NavigationType.dialog && route.navigationType != NavigationType.bottomSheet);
    final routesMap = pageRoutes.toList().asMap().map((_, value) => MapEntry(value.routeName, value.routeNameIsDefinedByAnnotation));
    return Class(
      (b) => b
        ..name = 'RouteNames'
        ..fields.addAll(
          routesMap.entries.map(
            (entry) {
              return Field(
                (b) => b
                  ..name = CaseUtil(entry.key).camelCase
                  ..static = true
                  ..modifier = FieldModifier.constant
                  ..assignment =
                      Code("'${entry.key.startsWith('/') ? '' : '/'}${entry.value ? entry.key : CaseUtil(entry.key, removeSuffixes: removeSuffixes).textWithoutSuffix}'"),
              );
            },
          ),
        ),
    );
  }
}
