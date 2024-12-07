import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/case_utils.dart';
import 'package:flutter_navigation_generator/src/utils/importable_type_string_converter.dart';
import 'package:flutter_navigation_generator/src/utils/route_config_extension.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class OnGenerateRouteBuilder {
  final Set<RouteConfig> routes;
  final ImportableType? pageType;
  final ImportableType? unknownRoute;
  final List<ImportableType> defaultGuards;
  final Uri? targetFile;

  OnGenerateRouteBuilder({
    required this.routes,
    this.pageType,
    this.unknownRoute,
    this.targetFile,
    this.defaultGuards = const [],
  });

  String _withPageType(RouteConfig? route, String screen) {
    final pageClass = route?.pageType != null
        ? typeRefer(route!.pageType).symbol
        : pageType != null
            ? typeRefer(pageType).symbol
            : 'MaterialPageRoute';
    return '$pageClass<${typeRefer(route?.returnType).symbol}>(builder: (_) => $screen, settings: settings, fullscreenDialog: ${route?.isFullscreenDialog == true},)';
  }

  String _generateRoute(RouteConfig route) {
    final constructor = route.constructorName == route.routeWidget.className || route.constructorName.isEmpty
        ? route.routeWidget.className
        : '${route.routeWidget.className}.${route.constructorName}';
    final constructorCall = '$constructor(${route.parameters.asMap().map((_, parameterConfig) {
          final parameter = parameterConfig.type;
          final nullableSuffix = parameter.isNullable ? '?' : '';
          final convertFromString = ImportableTypeStringConverter.convertFromString(parameter, 'arguments[\'${parameter.argumentName}\']');
          return MapEntry(
            parameter.argumentName,
            (parameter.className == 'Key' || parameter.className == 'String')
                ? "arguments['${parameter.argumentName}'] as ${parameter.className}$nullableSuffix"
                : "arguments['${parameter.argumentName}'] is String ? $convertFromString : arguments['${parameter.argumentName}'] as ${parameter.className}${parameter.typeArguments.isNotEmpty ? '<${parameter.typeArguments.map((e) => e.className).join(',')}>' : ''}$nullableSuffix",
          );
        }).entries.map((e) => '${e.key}: ${e.value},').join('')})';

    var guardsCode = '';
    if ((route.guards ?? defaultGuards).isNotEmpty) {
      for (final guard in route.guards ?? defaultGuards) {
        final insanceName = CaseUtil(guard.className).camelCase;
        guardsCode += 'final $insanceName = guards.whereType<${typeRefer(guard).symbol}>().first;\n';
        guardsCode += 'if (!$insanceName.value) {\n';
        guardsCode += '  guardedRouteSettings = settings;\n';
        guardsCode += '  return onGenerateRoute(RouteSettings(\n';
        guardsCode += '    arguments: settings.arguments,\n';
        guardsCode += '    name: $insanceName.alternativeRoute,\n';
        guardsCode += '  ));\n';
        guardsCode += '}\n';
      }
    }
    return '${guardsCode}return ${_withPageType(route, constructorCall)};';
  }

  Method generate() {
    final pageRoutes = routes.where((r) => r.generatePageRoute && r.navigationType != NavigationType.bottomSheet && r.navigationType != NavigationType.dialog).toList();
    for (final pageRoute in pageRoutes.toList()) {
      final pageRoute2 = pageRoutes.firstWhere((element) => element.routeName == pageRoute.routeName);
      if (pageRoute != pageRoute2) {
        pageRoutes.remove(pageRoute);
      }
    }
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
          if (pageRoutes.isNotEmpty) ...[
            const Code('''final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};
    final settingsUri = Uri.parse(settings.name ?? '');
    settingsUri.queryParameters.forEach((key, value) {
      arguments[key] ??= value;
    });'''),
            Code(
                'switch (settingsUri.path) {${pageRoutes.where((route) => !route.routeNameContainsParameters).map((route) => 'case RouteNames.${route.asRouteName}: ${_generateRoute(route)}').join('')}}'),
          ],
          if (pageRoutes.any((element) => element.routeNameContainsParameters)) ...[
            const Code('final pathSegments = settingsUri.pathSegments;'),
            ...pageRoutes
                .where((pageRoute) => pageRoute.routeNameContainsParameters)
                .groupListsBy((pageRoute) => pageRoute.routeName.pathSegments.length)
                .entries
                .sorted((a, b) => -a.key.compareTo(b.key))
                .map((group) {
              final pathSegments = group.key;
              var code = 'if (pathSegments.length == $pathSegments) {';
              final pageRoutesMap = group.value.asMap().map((key, value) => MapEntry(value, value.routeName.parametersFromRouteName.length));
              final pageRoutes = pageRoutesMap.entries.sorted((a, b) => a.value.compareTo(b.value)).map((e) => e.key).toList();
              for (final pageRoute in pageRoutes) {
                final pathSegments = pageRoute.routeName.pathSegments;
                final hasRigidSegments = pathSegments.any((element) => !element.startsWith(':'));
                if (hasRigidSegments) {
                  code += 'if (';
                  code += pathSegments
                      .asMap()
                      .entries
                      .where((pathSegment) => !pathSegment.value.startsWith(':'))
                      .map((pathSegment) => 'pathSegments[${pathSegment.key}] == \'${pathSegment.value}\'')
                      .join(' && ');
                  code += ') {';
                }
                code += pathSegments
                    .asMap()
                    .entries
                    .where((pathSegment) => pathSegment.value.startsWith(':'))
                    .map((pathSegment) => 'arguments[\'${pathSegments[pathSegment.key].substring(1)}\'] = pathSegments[${pathSegment.key}];')
                    .join('\n');
                code += _generateRoute(pageRoute);
                if (hasRigidSegments) code += '}';
              }

              return Code('$code}');
            }),
          ],
          if (unknownRoute != null) ...[
            Code('return ${_withPageType(null, '${typeRefer(unknownRoute!).symbol!}()')};'),
          ] else ...[
            const Code('return null;'),
          ],
        ]),
    );
  }
}
