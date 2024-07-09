import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/guards_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/guards_field_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/on_generate_route_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/route_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';

class NavigatorBuilder {
  final Set<RouteConfig> routes;
  final String className;
  final Uri? targetFile;
  final ImportableType? pageType;
  final ImportableType? unknownRoute;

  NavigatorBuilder({
    required this.routes,
    required this.className,
    required this.targetFile,
    required this.unknownRoute,
    required this.pageType,
  });

  Field buildNavigatorKey() {
    return Field(
      (f) => f
        ..name = 'navigatorKey'
        ..type = const Reference('GlobalKey<NavigatorState>')
        ..modifier = FieldModifier.final$
        ..assignment = const Code('GlobalKey<NavigatorState>()'),
    );
  }

  Spec generate() {
    return Mixin(
      (b) => b
        ..name = className
        ..fields.add(buildNavigatorKey())
        ..methods.add(
          OnGenerateRouteBuilder(
            routes: routes,
            pageType: pageType,
            targetFile: targetFile,
            unknownRoute: unknownRoute,
          ).generate(),
        )
        ..methods.addAll(
          GuardsBuilder().generate(),
        )
        ..fields.add(
          GuardsFieldBuilder(
            routes: routes,
            targetFile: targetFile,
          ).generate(),
        )
        ..methods.addAll(
          RouteBuilder(
            routes: routes,
            pageType: pageType,
            targetFile: targetFile,
          ).generate(),
        ),
    );
  }
}
