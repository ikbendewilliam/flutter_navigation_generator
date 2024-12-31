import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/models/route_field_config.dart';
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
  final bool ignoreKeysByDefault;

  OnGenerateRouteBuilder({
    required this.routes,
    this.pageType,
    this.unknownRoute,
    this.targetFile,
    this.ignoreKeysByDefault = true,
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
    final constructor = route.constructorName == route.routeWidget.className ||
            route.constructorName.isEmpty
        ? route.routeWidget.className
        : '${route.routeWidget.className}.${route.constructorName}';
    final constructorCall =
        '$constructor(${route.parameters.asMap().map((_, parameterConfig) => MapEntry(
              parameterConfig.type.argumentName,
              _getParameterValue(parameterConfig),
            )).entries.where((e) => e.value != null).map((e) => '${e.key}: ${e.value},').join('')})';

    var guardsCode = '';
    if ((route.guards ?? defaultGuards).isNotEmpty) {
      for (final guard in route.guards ?? defaultGuards) {
        final insanceName = CaseUtil(guard.className).camelCase;
        guardsCode +=
            'final $insanceName = guards.whereType<${typeRefer(guard).symbol}>().first;\n';
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

  String? _getParameterValue(RouteFieldConfig parameterConfig) {
    if (parameterConfig.ignoreWithKeyCheck(ignoreKeysByDefault) == true)
      return null;
    final parameter = parameterConfig.type;
    final nullableSuffix = parameter.isNullable ? '?' : '';
    final defaultSuffix = parameterConfig.defaultValue != null
        ? '${parameter.isNullable ? '' : '?'} ?? ${parameterConfig.defaultValue}'
        : '';
    final convertFromString = ImportableTypeStringConverter.convertFromString(
        parameter, 'queryParameters[\'${parameterConfig.queryName}\']!');
    if (parameter.className == 'Key')
      return "arguments['${parameter.argumentName}'] as ${parameter.className}$nullableSuffix$defaultSuffix";
    // Small notation in case of string/dynamic (using ??)
    if (parameter.className == 'String' || parameter.className == 'dynamic') {
      return "queryParameters['${parameterConfig.queryName}'] ?? arguments['${parameter.argumentName}'] as ${parameter.className}$nullableSuffix$defaultSuffix";
    }

    final typeArguments = parameter.typeArguments.isNotEmpty
        ? '<${parameter.typeArguments.map((e) => e.className).join(',')}>'
        : '';
    final String fromArguments;
    if (parameterConfig.defaultValue != null) {
      fromArguments =
          "arguments['${parameter.argumentName}'] as ${parameter.className}$typeArguments? ?? ${parameterConfig.defaultValue}";
    } else {
      fromArguments =
          "arguments['${parameter.argumentName}'] as ${parameter.className}$typeArguments$nullableSuffix";
    }
    if (parameterConfig.addToJson == false) return fromArguments;
    return "queryParameters['${parameterConfig.queryName}'] != null ? $convertFromString : $fromArguments";
  }

  Method generate() {
    final pageRoutes = routes
        .where((r) =>
            r.generatePageRoute &&
            r.navigationType != NavigationType.bottomSheet &&
            r.navigationType != NavigationType.dialog)
        .toList();
    for (final pageRoute in pageRoutes.toList()) {
      final pageRoute2 = pageRoutes
          .firstWhere((element) => element.routeName == pageRoute.routeName);
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
        ..body = _generateBody(pageRoutes),
    );
  }

  Block _generateBody(List<RouteConfig> pageRoutes) {
    return Block.of([
      if (pageRoutes.isNotEmpty) ...[
        const Code(
            '''final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};
    final settingsUri = Uri.parse(settings.name ?? '');
    final queryParameters = Map.from(settingsUri.queryParameters);'''),
        Code(
            'switch (settingsUri.path) {${pageRoutes.where((route) => !route.routeNameContainsParameters).map((route) => 'case RouteNames.${route.asRouteName}: ${_generateRoute(route)}').join('')}}'),
      ],
      if (pageRoutes.any((element) => element.routeNameContainsParameters)) ...[
        const Code('final pathSegments = settingsUri.pathSegments;'),
        ...pageRoutes
            .where((pageRoute) => pageRoute.routeNameContainsParameters)
            .groupListsBy(
                (pageRoute) => pageRoute.routeName.pathSegments.length)
            .entries
            .sorted((a, b) => -a.key.compareTo(b.key))
            .map((group) {
          final pathSegments = group.key;
          var code = 'if (pathSegments.length == $pathSegments) {';
          final pageRoutesMap = group.value.asMap().map((key, value) =>
              MapEntry(value, value.routeName.parametersFromRouteName.length));
          final pageRoutes = pageRoutesMap.entries
              .sorted((a, b) => a.value.compareTo(b.value))
              .map((e) => e.key)
              .toList();
          for (final pageRoute in pageRoutes) {
            final pathSegments = pageRoute.routeName.pathSegments;
            final hasRigidSegments =
                pathSegments.any((element) => !element.startsWith(':'));
            if (hasRigidSegments) {
              code += 'if (';
              code += pathSegments
                  .asMap()
                  .entries
                  .where((pathSegment) => !pathSegment.value.startsWith(':'))
                  .map((pathSegment) =>
                      'pathSegments[${pathSegment.key}] == \'${pathSegment.value}\'')
                  .join(' && ');
              code += ') {';
            }
            code += pathSegments
                .asMap()
                .entries
                .where((pathSegment) => pathSegment.value.startsWith(':'))
                .map((pathSegment) =>
                    'queryParameters[\'${pathSegments[pathSegment.key].substring(1)}\'] = pathSegments[${pathSegment.key}];')
                .join('\n');
            code += _generateRoute(pageRoute);
            if (hasRigidSegments) code += '}';
          }

          return Code('$code}');
        }),
      ],
      if (unknownRoute != null) ...[
        Code(
            'return ${_withPageType(null, '${typeRefer(unknownRoute!).symbol!}()')};'),
      ] else ...[
        const Code('return null;'),
      ],
    ]);
  }
}
