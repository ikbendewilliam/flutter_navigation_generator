import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/guards_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/guards_field_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/multi_panel_navigation_builder.dart';
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
  final List<String> removeSuffixes;
  final bool ignoreKeysByDefault;
  final MultiPanelNavigationBuilder multiPanelNavigationBuilder;
  final IncludeQueryParametersType includeQueryParametersNavigatorConfig;

  NavigatorBuilder({
    required this.routes,
    required this.className,
    required this.targetFile,
    required this.unknownRoute,
    required this.pageType,
    required this.defaultGuards,
    required this.multiPanelNavigationBuilder,
    required this.includeQueryParametersNavigatorConfig,
    required this.removeSuffixes,
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
            ..fields.addAll(multiPanelNavigationBuilder.generateFields())
            ..methods.addAll(multiPanelNavigationBuilder.generateMethods())
            ..methods.add(
              OnGenerateRouteBuilder(
                routes: routes,
                pageType: pageType,
                targetFile: targetFile,
                unknownRoute: unknownRoute,
                defaultGuards: defaultGuards,
                ignoreKeysByDefault: ignoreKeysByDefault,
                removeSuffixes: removeSuffixes,
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
