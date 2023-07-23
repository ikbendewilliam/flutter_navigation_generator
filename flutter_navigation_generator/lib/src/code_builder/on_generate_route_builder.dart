import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/case_utils.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';

class OnGenerateRouteBuilder {
  final Set<RouteConfig> routes;
  final ImportableType? pageType;
  final Uri? targetFile;

  OnGenerateRouteBuilder({
    required this.routes,
    required this.pageType,
    required this.targetFile,
  });

  String _withPageType(RouteConfig route, String screen) {
    final pageClass = pageType != null
        ? typeRefer(pageType).symbol
        : route.pageType != null
            ? typeRefer(route.pageType).symbol
            : 'MaterialPageRoute';
    return '$pageClass<${typeRefer(route.returnType).symbol}>(builder: (_) => $screen, settings: settings, fullscreenDialog: ${route.isFullscreenDialog},)';
  }

  String _generateRoute(RouteConfig route) {
    final constructor = route.constructorName == route.routeWidget.className || route.constructorName.isEmpty
        ? route.routeWidget.className
        : '${route.routeWidget.className}.${route.constructorName}';
    final constructorCall = '$constructor(${route.parameters.asMap().map((_, p) {
          final nullableSuffix = p.isNullable ? '?' : '';
          return MapEntry(
            p.argumentName,
            "(settings.arguments as Map<String, dynamic>$nullableSuffix)$nullableSuffix['${p.argumentName}'] as ${typeRefer(p).symbol}$nullableSuffix",
          );
        }).entries.map((e) => '${e.key}: ${e.value},').join('')})';
    return 'case RouteNames.${CaseUtil(route.routeName).camelCase}: return ${_withPageType(route, constructorCall)};';
  }

  Method generate() {
    return Method(
      (m) => m
        ..name = 'onGenerateRoute'
        ..returns = const Reference('Route<dynamic>?')
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..name = 'settings'
              ..type = const Reference('RouteSettings'),
          ),
        )
        ..body = Block.of([
          Code('switch (settings.name) {${routes.map(_generateRoute).join('')}}'),
          const Code('return null;'),
        ]),
    );
  }
}
