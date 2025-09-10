import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/guards_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/guards_field_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/on_generate_route_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/route_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class NavigatorBuilder {
  final Set<RouteConfig> routes;
  final String className;
  final Uri? targetFile;
  final ImportableType? pageType;
  final ImportableType? unknownRoute;
  final List<ImportableType> defaultGuards;
  final bool ignoreKeysByDefault;
  final IncludeQueryParametersType includeQueryParametersNavigatorConfig;

  NavigatorBuilder({
    required this.routes,
    required this.className,
    required this.targetFile,
    required this.unknownRoute,
    required this.pageType,
    required this.defaultGuards,
    required this.includeQueryParametersNavigatorConfig,
    this.ignoreKeysByDefault = true,
  });

  Field buildNavigatorKey() {
    return Field(
      (f) =>
          f
            ..name = 'navigatorKey'
            ..type = const Reference('GlobalKey<NavigatorState>')
            ..modifier = FieldModifier.final$
            ..assignment = const Code('GlobalKey<NavigatorState>()'),
    );
  }

  Spec generate() {
    final hasGuards = routes.any((route) => route.guards?.isNotEmpty == true) || defaultGuards.isNotEmpty;
    return Mixin(
      (b) =>
          b
            ..name = className
            ..fields.add(buildNavigatorKey())
            ..fields.addAll([
              Field(
                (f) =>
                    f
                      ..name = 'parentScreen'
                      ..type = refer('Type?'),
              ),
              Field(
                (f) =>
                    f
                      ..name = 'parentNavigator'
                      ..type = refer('$className?'),
              ),
              Field(
                (f) =>
                    f
                      ..name = 'subNavigators'
                      ..modifier = FieldModifier.final$
                      ..type = refer('Map<Type, $className>')
                      ..assignment = const Code('{}'),
              ),
            ])
            ..methods.add(
              OnGenerateRouteBuilder(
                routes: routes,
                pageType: pageType,
                targetFile: targetFile,
                unknownRoute: unknownRoute,
                defaultGuards: defaultGuards,
                ignoreKeysByDefault: ignoreKeysByDefault,
              ).generate(),
            )
            ..methods.addAll(hasGuards ? GuardsBuilder().generate() : [])
            ..fields.addAll(hasGuards ? GuardsFieldBuilder(routes: routes, targetFile: targetFile, defaultGuards: defaultGuards).generate() : [])
            ..methods.addAll(
              RouteBuilder(
                routes: routes,
                pageType: pageType,
                targetFile: targetFile,
                ignoreKeysByDefault: ignoreKeysByDefault,
                includeQueryParametersNavigatorConfig: includeQueryParametersNavigatorConfig,
              ).generate(),
            ),
    );
  }
}
