import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_field_config.dart';
import 'package:flutter_navigation_generator/src/utils/case_utils.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class RouteConfig {
  final bool isFullscreenDialog;
  final bool generatePageRoute;
  final bool generateMethod;
  final bool routeNameIsDefinedByAnnotation;
  final bool methodNameIsDefinedByAnnotation;
  final String routeName;
  final String methodName;
  final String constructorName;
  final ImportableType routeWidget;
  final ImportableType? parentScreen;
  final ImportableType? returnType;
  final ImportableType? pageType;
  final NavigationType navigationType;
  final List<RouteFieldConfig> parameters;
  final List<ImportableType>? guards;
  final Map<String, dynamic> defaultValues;
  final IncludeQueryParametersType? includeQueryParameters;

  bool get routeNameContainsParameters => routeName.contains(':');

  String fullRouteName(Set<RouteConfig> routes, List<String> removeSuffixes) {
    final parentScreenRouteName = parentScreen?.fullRouteName(routes, removeSuffixes);
    final routeNameSuffixless = routeNameIsDefinedByAnnotation ? routeName : CaseUtil(routeName, removeSuffixes: removeSuffixes).textWithoutSuffix;
    final divider = routeName.startsWith('/') ? '' : '/';
    final fullRouteName = parentScreenRouteName == null ? routeNameSuffixless : '$parentScreenRouteName$divider$routeNameSuffixless';
    return "${fullRouteName.startsWith('/') ? '' : '/'}$fullRouteName";
  }

  RouteConfig({
    required this.routeWidget,
    this.routeName = '',
    this.methodName = '',
    this.constructorName = '',
    this.pageType,
    this.isFullscreenDialog = false,
    this.generatePageRoute = true,
    this.generateMethod = true,
    this.routeNameIsDefinedByAnnotation = false,
    this.methodNameIsDefinedByAnnotation = false,
    this.parentScreen,
    this.returnType,
    this.navigationType = NavigationType.push,
    this.parameters = const [],
    this.guards,
    this.defaultValues = const {},
    this.includeQueryParameters,
  });

  Map<String, dynamic> toMap() {
    return {
      'isFullscreenDialog': isFullscreenDialog,
      'generatePageRoute': generatePageRoute,
      'generateMethod': generateMethod,
      'constructorName': constructorName,
      'routeName': routeName,
      'methodName': methodName,
      'routeNameIsDefinedByAnnotation': routeNameIsDefinedByAnnotation,
      'methodNameIsDefinedByAnnotation': methodNameIsDefinedByAnnotation,
      'parentScreen': parentScreen?.toMap(),
      'returnType': returnType?.toMap(),
      'pageType': pageType?.toMap(),
      'routeWidget': routeWidget.toMap(),
      'navigationType': navigationType.index,
      'parameters': parameters.map((x) => x.toMap()).toList(),
      'guards': guards?.map((x) => x.toMap()).toList(),
      'defaultValues': defaultValues,
      'includeQueryParameters': includeQueryParameters?.index,
    };
  }

  factory RouteConfig.fromMap(Map<String, dynamic> map) {
    return RouteConfig(
      isFullscreenDialog: map['isFullscreenDialog'] ?? false,
      generatePageRoute: map['generatePageRoute'] ?? false,
      generateMethod: map['generateMethod'] ?? false,
      constructorName: map['constructorName'] ?? '',
      routeName: map['routeName'] ?? '',
      methodName: map['methodName'] ?? '',
      routeNameIsDefinedByAnnotation: map['routeNameIsDefinedByAnnotation'] ?? '',
      methodNameIsDefinedByAnnotation: map['methodNameIsDefinedByAnnotation'] ?? '',
      routeWidget: ImportableType.fromMap(map['routeWidget']),
      parentScreen: map['parentScreen'] != null ? ImportableType.fromMap(map['parentScreen']) : null,
      returnType: map['returnType'] != null ? ImportableType.fromMap(map['returnType']) : null,
      pageType: map['pageType'] != null ? ImportableType.fromMap(map['pageType']) : null,
      navigationType: NavigationType.values[map['navigationType']],
      parameters: List<RouteFieldConfig>.from(map['parameters']?.map((dynamic x) => RouteFieldConfig.fromMap(x as Map<String, dynamic>)) as Iterable),
      guards: map['guards'] == null ? null : List<ImportableType>.from(map['guards'].map((dynamic x) => ImportableType.fromMap(x as Map<String, dynamic>)) as Iterable),
      defaultValues: map['defaultValues'] as Map<String, dynamic>? ?? <String, dynamic>{},
      includeQueryParameters: map['includeQueryParameters'] == null ? null : IncludeQueryParametersType.values[map['includeQueryParameters']],
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteConfig.fromJson(String source) => RouteConfig.fromMap(json.decode(source));
}

extension ImportableTypeExtension on ImportableType {
  String fullRouteName(Set<RouteConfig> typesConfig, List<String> removeSuffixes) {
    final config = typesConfig.firstWhereOrNull((element) => element.routeWidget.className == className);
    if (config == null) return '';
    final parent = config.parentScreen;
    final routeName = config.routeNameIsDefinedByAnnotation ? config.routeName : CaseUtil(config.routeName, removeSuffixes: removeSuffixes).textWithoutSuffix;
    if (parent == null) return routeName;
    final divider = routeName.startsWith('/') ? '' : '/';
    return '${parent.fullRouteName(typesConfig, removeSuffixes)}$divider$routeName';
  }
}
