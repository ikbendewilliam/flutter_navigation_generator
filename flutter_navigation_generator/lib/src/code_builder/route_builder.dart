import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/extensions/navigation_type_extension.dart';
import 'package:flutter_navigation_generator/src/extensions/route_config_extension.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/case_utils.dart';
import 'package:flutter_navigation_generator/src/utils/importable_type_string_converter.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class RouteBuilder {
  final Set<RouteConfig> routes;
  final IncludeQueryParametersType includeQueryParametersNavigatorConfig;
  final ImportableType? pageType;
  final Uri? targetFile;
  final bool ignoreKeysByDefault;
  final bool createMultipanelNavigation;

  RouteBuilder({
    required this.routes,
    required this.pageType,
    required this.targetFile,
    required this.includeQueryParametersNavigatorConfig,
    this.ignoreKeysByDefault = true,
    this.createMultipanelNavigation = false,
  });

  Iterable<Method> generate() {
    final methodRoutes = routes.where((element) => element.generateMethod);
    final dialogRoutes = <RouteConfig>[];
    final bottomSheetRoutes = <RouteConfig>[];
    final pageRoutes = <RouteConfig>[];
    for (final route in methodRoutes) {
      switch (route.navigationType) {
        case NavigationType.dialog:
          dialogRoutes.add(route);
          break;
        case NavigationType.bottomSheet:
          bottomSheetRoutes.add(route);
          break;
        default:
          pageRoutes.add(route);
      }
    }
    return <Method>[]
        .followedBy(_generatePageRoutes(pageRoutes, createMultipanelNavigation))
        .followedBy(_generateDialogRoutes(dialogRoutes))
        .followedBy(_generateBottomSheetRoutes(bottomSheetRoutes))
        .followedBy(_generateGenericRoutes(createMultipanelNavigation));
  }

  Method _generateMethod({required RouteConfig route, required Code body, required String namePrefix, bool isLambda = true, bool isAsync = true}) {
    final String name;
    if (route.methodNameIsDefinedByAnnotation) {
      name = route.methodName;
    } else {
      name = '$namePrefix${CaseUtil(route.methodName.replaceAll(RegExp(':[a-zA-Z0-9]*'), '')).upperCamelCase}';
    }
    return Method(
      (b) =>
          b
            ..name = name
            ..lambda = isLambda
            ..modifier = isAsync ? MethodModifier.async : null
            ..optionalParameters.addAll(
              route.parameters
                  .where((p) => !p.ignoreWithKeyCheck(ignoreKeysByDefault))
                  .map(
                    (p) => Parameter(
                      (b) =>
                          b
                            ..name = p.type.argumentName
                            ..named = true
                            ..required = p.type.isRequired && p.defaultValue == null
                            ..defaultTo = p.defaultValue != null ? Code(p.defaultValue!) : null
                            ..type = typeRefer(p.type),
                    ),
                  ),
            )
            ..returns = typeRefer(route.returnType, forceNullable: true, forceFuture: isAsync)
            ..body = body,
    );
  }

  String _generateQueryParameters(RouteConfig route, List<String> parametersInRouteName, bool createMultipanelNavigation) {
    final includeQueryParameters = route.includeQueryParameters ?? includeQueryParametersNavigatorConfig;
    if (includeQueryParameters == IncludeQueryParametersType.never) return '';

    final filteredParameters = route.parameters.where(
      (element) => !element.ignoreWithKeyCheck(ignoreKeysByDefault) && element.addToJson && !parametersInRouteName.contains(element.type.argumentName),
    );
    final queryParametersMap = filteredParameters.toList().asMap().map((_, parameterConfig) {
      final parameter = parameterConfig.type;
      final stringValue = ImportableTypeStringConverter.convertToString(parameter);
      return MapEntry("'${parameterConfig.queryName}'", (parameter.isNullable && parameter.isCustomClass) ? '${parameter.name} == null ? null : $stringValue' : stringValue);
    });

    if (queryParametersMap.isEmpty) return '';
    var queryParameters = queryParametersMap.toString();

    var addRemoveWhere = filteredParameters.any((element) => element.type.isNullable);
    if (addRemoveWhere) {
      queryParameters = '$queryParameters..removeWhere((_, v) => v == null)';
    }
    if (includeQueryParameters == IncludeQueryParametersType.onlyOnWeb) {
      if (addRemoveWhere) {
        queryParameters = '($queryParameters)';
      }
      queryParameters = 'kIsWeb ? $queryParameters : null';
    }
    return queryParameters;
  }

  Iterable<Method> _generatePageRoutes(List<RouteConfig> routes, bool createMultipanelNavigation) {
    return routes.map((route) {
      if (route.navigationType == NavigationType.pushNotNamed) {
        return _generateBottomSheetOrDialogRoute(route: route, namePrefix: 'goTo', bodyCall: 'navigatorKey.currentState?.push', useNamedWidgetArugment: false, withPageType: true);
      }
      final parametersInRouteName = route.fullRouteName(routes, []).parametersFromRouteName;
      var path = route.asRouteNameExpression;
      if (parametersInRouteName.isNotEmpty) path = route.callRouteNameExpression(path, parametersInRouteName);

      var queryParameters = _generateQueryParameters(route, parametersInRouteName, createMultipanelNavigation);
      final arguments = Reference(
        '${route.parameters.where((p) => !p.ignoreWithKeyCheck(ignoreKeysByDefault)).toList().asMap().map((_, parameterConfig) => MapEntry("'${parameterConfig.type.argumentName}'", parameterConfig.type.argumentName))}',
      );

      var bodyCall = TypeReference(
        (b) =>
            b
              ..symbol = 'navigatorKey.currentState?.${route.navigationType.navigatorMethod}'
              ..types.addAll([
                const Reference('dynamic'),
                if (route.navigationType == NavigationType.pushReplacement ||
                    route.navigationType == NavigationType.popAndPush ||
                    route.navigationType == NavigationType.restorablePushReplacement ||
                    route.navigationType == NavigationType.restorablePopAndPush) ...[
                  const Reference('dynamic'),
                ],
              ]),
      ).call(
        [
          queryParameters.isEmpty ? path : const Reference('Uri', 'dart:core').call([], {'path': path, 'queryParameters': Reference(queryParameters)}).property('toString()'),
          if (route.navigationType == NavigationType.pushAndReplaceAll || route.navigationType == NavigationType.restorablePushAndReplaceAll) ...[const Reference('(_) => false')],
        ],
        {'arguments': arguments},
      );
      if (createMultipanelNavigation) {
        bodyCall = TypeReference((b) => b..symbol = '_navigateInMultiPanelOr').call([
          Method(
            (b) =>
                b
                  ..lambda = true
                  ..modifier = MethodModifier.async
                  ..body = bodyCall.code,
          ).closure,
          path,
          arguments,
        ]);
      }
      Code body;
      if (route.returnType != null) {
        body = Block(
          (b) =>
              b
                ..statements.add(declareFinal('result', type: const Reference('dynamic')).assign(bodyCall.awaited).statement)
                ..statements.add(const Reference('result').asA(typeRefer(route.returnType, forceNullable: true)).returned.statement),
        );
      } else {
        body = bodyCall.code;
      }
      return _generateMethod(route: route, namePrefix: 'goTo', isAsync: route.navigationType.isAsync || route.returnType != null, isLambda: route.returnType == null, body: body);
    });
  }

  Method _generateBottomSheetOrDialogRoute({
    required RouteConfig route,
    required String namePrefix,
    required String bodyCall,
    bool useNamedWidgetArugment = true,
    bool withPageType = false,
  }) {
    var argument = Reference(
      route.constructorName == route.routeWidget.className || route.constructorName.isEmpty
          ? route.routeWidget.className
          : '${route.routeWidget.className}.${route.constructorName}',
      typeRefer(route.routeWidget).url,
    ).call(
      [],
      route.parameters.where((p) => !p.ignoreWithKeyCheck(ignoreKeysByDefault)).toList().asMap().map((_, p) => MapEntry(p.type.argumentName, Reference(p.type.argumentName))),
    );
    if (withPageType) {
      final pageClass =
          route.pageType != null
              ? typeRefer(route.pageType)
              : pageType != null
              ? typeRefer(pageType)
              : const Reference('MaterialPageRoute');
      argument = pageClass.call([], {
        'builder':
            Method(
              (b) =>
                  b
                    ..body = argument.code
                    ..requiredParameters.add(Parameter((b) => b..name = 'context')),
            ).genericClosure,
        'fullscreenDialog': Reference(route.isFullscreenDialog == true ? 'true' : 'false'),
      });
    }
    return _generateMethod(
      route: route,
      namePrefix: namePrefix,
      body:
          TypeReference(
            (b) =>
                b
                  ..symbol = bodyCall
                  ..types.add(route.returnType == null ? const Reference('dynamic') : typeRefer(route.returnType!)),
          ).call(useNamedWidgetArugment ? [] : [argument], useNamedWidgetArugment ? {'widget': argument} : {}).code,
    );
  }

  Iterable<Method> _generateDialogRoutes(List<RouteConfig> routes) {
    return routes.map((route) => _generateBottomSheetOrDialogRoute(route: route, namePrefix: 'showDialog', bodyCall: 'showCustomDialog'));
  }

  Iterable<Method> _generateBottomSheetRoutes(List<RouteConfig> routes) {
    return routes.map((route) => _generateBottomSheetOrDialogRoute(route: route, namePrefix: 'showSheet', bodyCall: 'showBottomSheet'));
  }

  Iterable<Method> _generateGenericRoutes(bool createMultipanelNavigation) {
    final goBack = const Reference('navigatorKey.currentState?.pop').call([]).code;
    final goBackWithResult = const Reference('navigatorKey.currentState?.pop').call([const Reference('result')]).code;
    return [
      Method(
        (b) =>
            b
              ..name = 'goBack'
              ..lambda = true
              ..returns = const Reference('void')
              ..body = createMultipanelNavigation ? const Reference('_popMultiPanelOr').call([Method((b) => b..body = goBack).closure]).code : goBack,
      ),
      Method(
        (b) =>
            b
              ..name = 'goBackWithResult'
              ..lambda = true
              ..types.add(const Reference('T'))
              ..optionalParameters.add(
                Parameter(
                  (b) =>
                      b
                        ..name = 'result'
                        ..named = true
                        ..type = const Reference('T?'),
                ),
              )
              ..returns = const Reference('void')
              ..body =
                  createMultipanelNavigation
                      ? const Reference('_popMultiPanelOr').call([Method((b) => b..body = goBackWithResult).closure, const Reference('result')]).code
                      : goBackWithResult,
      ),
      Method(
        (b) =>
            b
              ..name = 'popUntil'
              ..lambda = true
              ..requiredParameters.add(
                Parameter(
                  (b) =>
                      b
                        ..name = 'predicate'
                        ..type = FunctionType(
                          (b) =>
                              b
                                ..returnType = const Reference('bool')
                                ..requiredParameters.add(const Reference('Route<dynamic>')),
                        ),
                ),
              )
              ..returns = const Reference('void')
              ..body = const Reference('navigatorKey.currentState?.popUntil').call([const Reference('predicate')]).code,
      ),
      Method(
        (b) =>
            b
              ..name = 'goBackTo'
              ..lambda = true
              ..requiredParameters.add(
                Parameter(
                  (b) =>
                      b
                        ..name = 'routeName'
                        ..type = const Reference('String'),
                ),
              )
              ..returns = const Reference('void')
              ..body = const Reference('popUntil').call([const Reference('(route) => route.settings.name?.split(\'?\').first == routeName')]).code,
      ),
      Method(
        (b) =>
            b
              ..name = 'showCustomDialog'
              ..lambda = true
              ..modifier = MethodModifier.async
              ..types.add(const Reference('T'))
              ..optionalParameters.add(
                Parameter(
                  (b) =>
                      b
                        ..name = 'widget'
                        ..named = true
                        ..type = const Reference('Widget?'),
                ),
              )
              ..returns = const Reference('Future<T?>')
              ..body =
                  const Reference(
                    'showDialog<T>',
                  ).call([], {'context': const Reference('navigatorKey.currentContext!'), 'builder': const Reference('(_) => widget ?? const SizedBox.shrink()')}).code,
      ),
      Method(
        (b) =>
            b
              ..name = 'showBottomSheet'
              ..lambda = true
              ..modifier = MethodModifier.async
              ..types.add(const Reference('T'))
              ..optionalParameters.add(
                Parameter(
                  (b) =>
                      b
                        ..name = 'widget'
                        ..named = true
                        ..type = const Reference('Widget?'),
                ),
              )
              ..returns = const Reference('Future<T?>')
              ..body =
                  const Reference(
                    'showModalBottomSheet<T>',
                  ).call([], {'context': const Reference('navigatorKey.currentContext!'), 'builder': const Reference('(_) => widget ?? const SizedBox.shrink()')}).code,
      ),
    ];
  }
}
