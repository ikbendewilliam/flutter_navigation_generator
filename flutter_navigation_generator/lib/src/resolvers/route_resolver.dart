import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/resolvers/importable_type_resolver.dart';
import 'package:flutter_navigation_generator/src/utils/case_utils.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:source_gen/source_gen.dart';

const TypeChecker _flutterRouteAnnotationChecker =
    TypeChecker.fromRuntime(FlutterRoute);
const TypeChecker _constructorAnnotationChecker =
    TypeChecker.fromRuntime(FlutterRouteConstructor);

class RouteResolver {
  final ImportableTypeResolverImpl _typeResolver;

  RouteResolver(List<LibraryElement> libs)
      : _typeResolver = ImportableTypeResolverImpl(libs);

  List<RouteConfig> resolve(ClassElement classElement) {
    final flutterRouteAnnotations = _flutterRouteAnnotationChecker
        .annotationsOf(classElement, throwOnUnresolved: false);
    return flutterRouteAnnotations
        .map((annotation) => _resolveRoute(classElement, annotation))
        .toList();
  }

  ExecutableElement _resolveConstructorMethod(
      ClassElement classElement, String routeName) {
    final possibleFactories = <ExecutableElement>[
      ...classElement.methods.where((method) => method.isStatic),
      ...classElement.constructors,
    ];

    final possibleFactoriesWithAnnotations = possibleFactories.asMap().map(
        (key, value) => MapEntry(
            value,
            _constructorAnnotationChecker
                .annotationsOf(value)
                .map(ConstantReader.new)));

    ExecutableElement? constructor;
    constructor = possibleFactoriesWithAnnotations.entries
        .firstWhereOrNull((element) => element.value.any((annotation) =>
            annotation.peek('routeName')?.stringValue == routeName))
        ?.key;
    constructor ??= possibleFactoriesWithAnnotations.entries
        .firstWhereOrNull((element) => element.value.any(
            (annotation) => annotation.peek('routeName')?.stringValue == null))
        ?.key;
    return constructor ?? classElement.constructors.first;
  }

  RouteConfig _resolveRoute(
      ClassElement classElement, DartObject flutterRouteAnnotation) {
    final flutterRoute = ConstantReader(flutterRouteAnnotation);

    final routeNameValue = flutterRoute.peek('routeName')?.stringValue;
    final routeName = routeNameValue ?? CaseUtil(classElement.name).kebabCase;
    final methodNameValue = flutterRoute.peek('methodName')?.stringValue;
    final methodName =
        methodNameValue ?? CaseUtil(classElement.name).upperCamelCase;
    final returnType = flutterRoute.peek('returnType')?.typeValue;
    final pageType = flutterRoute.peek('pageType')?.typeValue;
    final guards = flutterRoute
        .peek('guards')
        ?.listValue
        .map((e) => e.toTypeValue())
        .whereNotNull()
        .map(_typeResolver.resolveType)
        .toList();
    final navigationType = NavigationType.values.firstWhere((element) =>
        element.index ==
        flutterRoute.peek('navigationType')?.peek('index')?.intValue);
    final includeQueryParametersIndex =
        flutterRoute.peek('includeQueryParameters')?.peek('index')?.intValue;
    final includeQueryParameters = includeQueryParametersIndex == null
        ? null
        : IncludeQueryParametersType.values[includeQueryParametersIndex];
    final constructor = _resolveConstructorMethod(classElement, routeName);

    ImportableType? importableReturnType;
    if (returnType != null) {
      importableReturnType =
          _typeResolver.resolveType(returnType, forceNullable: true);
    }
    ImportableType? importablePageType;
    if (pageType != null) {
      importablePageType =
          _typeResolver.resolveType(pageType, forceNullable: true);
    }
    final constructorParameters = constructor.parameters
        .map((p) => _typeResolver.resolveType(
              p.type,
              isRequired: p.isRequired,
              name: p.name,
            ))
        .toList();
    final constructorDefaultValues = ((constructor.parameters
            .asMap()
            .map<String, dynamic>((_, p) =>
                MapEntry<String, dynamic>(p.name, p.defaultValueCode)))
          ..removeWhere((key, dynamic value) => value == null))
        .cast<String, String>();

    return RouteConfig(
      routeWidget: _typeResolver.resolveType(classElement.thisType),
      returnType: importableReturnType,
      constructorName: constructor.name,
      parameters: constructorParameters,
      guards: guards,
      defaultValues: constructorDefaultValues,
      routeName: routeName,
      methodName: methodName,
      pageType: importablePageType,
      routeNameIsDefinedByAnnotation: routeNameValue != null,
      methodNameIsDefinedByAnnotation: methodNameValue != null,
      navigationType: navigationType,
      isFullscreenDialog:
          flutterRoute.peek('isFullscreenDialog')?.boolValue ?? false,
      generateMethod: flutterRoute.peek('generateMethod')?.boolValue ?? true,
      generatePageRoute:
          (flutterRoute.peek('generatePageRoute')?.boolValue ?? true) &&
              navigationType != NavigationType.dialog &&
              navigationType != NavigationType.bottomSheet,
      includeQueryParameters: includeQueryParameters,
    );
  }
}
