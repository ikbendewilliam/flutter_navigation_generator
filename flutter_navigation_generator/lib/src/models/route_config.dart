import 'dart:convert';

import 'package:flutter_navigation_generator/src/models/importable_type.dart';
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
  final ImportableType? returnType;
  final ImportableType? pageType;
  final NavigationType navigationType;
  final List<ImportableType> parameters;
  final List<ImportableType>? guards;
  final Map<String, dynamic> defaultValues;

  bool get routeNameContainsParameters => routeName.contains(':');

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
    this.returnType,
    this.navigationType = NavigationType.push,
    this.parameters = const [],
    this.guards,
    this.defaultValues = const {},
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
      'returnType': returnType?.toMap(),
      'pageType': pageType?.toMap(),
      'routeWidget': routeWidget.toMap(),
      'navigationType': navigationType.index,
      'parameters': parameters.map((x) => x.toMap()).toList(),
      'guards': guards?.map((x) => x.toMap()).toList(),
      'defaultValues': defaultValues,
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
      routeNameIsDefinedByAnnotation:
          map['routeNameIsDefinedByAnnotation'] ?? '',
      methodNameIsDefinedByAnnotation:
          map['methodNameIsDefinedByAnnotation'] ?? '',
      routeWidget: ImportableType.fromMap(map['routeWidget']),
      returnType: map['returnType'] != null
          ? ImportableType.fromMap(map['returnType'])
          : null,
      pageType: map['pageType'] != null
          ? ImportableType.fromMap(map['pageType'])
          : null,
      navigationType: NavigationType.values[map['navigationType']],
      parameters: List<ImportableType>.from(map['parameters']?.map(
              (dynamic x) => ImportableType.fromMap(x as Map<String, dynamic>))
          as Iterable),
      guards: map['guards'] == null
          ? null
          : List<ImportableType>.from(map['guards'].map((dynamic x) =>
              ImportableType.fromMap(x as Map<String, dynamic>)) as Iterable),
      defaultValues:
          map['defaultValues'] as Map<String, dynamic>? ?? <String, dynamic>{},
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteConfig.fromJson(String source) =>
      RouteConfig.fromMap(json.decode(source));
}
