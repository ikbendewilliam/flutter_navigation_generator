
import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_field_config.dart';
import 'package:flutter_navigation_generator/src/resolvers/importable_type_resolver.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:source_gen/source_gen.dart';

const TypeChecker _flutterRouteFieldAnnotationChecker = TypeChecker.typeNamed(
  FlutterRouteField,
);

class RouteFieldResolver {
  final ImportableTypeResolverImpl _typeResolver;

  RouteFieldResolver(List<LibraryElement> libs)
    : _typeResolver = ImportableTypeResolverImpl(libs);

  List<_RawRouteFieldConfig> _resolveConstructorFields(
    ExecutableElement constructor,
  ) {
    final constructorParameters = constructor.formalParameters;

    return constructorParameters.map((parameter) {
      final field = _typeResolver.resolveType(
        parameter.type,
        isRequired: parameter.isRequired,
        name: parameter.displayName,
      );
      final annotation = _flutterRouteFieldAnnotationChecker
          .annotationsOf(parameter, throwOnUnresolved: false)
          .map(ConstantReader.new);
      if (annotation.isEmpty) {
        return _RawRouteFieldConfig(
          type: field,
          defaultValue: parameter.defaultValueCode,
        );
      }
      final flutterRouteField = annotation.firstOrNull;
      final queryName = flutterRouteField?.peek('queryName')?.stringValue;
      final ignore = flutterRouteField?.peek('ignore')?.boolValue;
      final addToJson = flutterRouteField?.peek('addToJson')?.boolValue;

      return _RawRouteFieldConfig(
        type: field,
        defaultValue: parameter.defaultValueCode,
        queryName: queryName,
        ignore: ignore,
        addToJson: addToJson,
      );
    }).toList();
  }

  List<RouteFieldConfig> resolveFieldsMethod(
    ExecutableElement constructor,
    ClassElement classElement,
  ) {
    final fieldsWithAnnotation = classElement.fields.asMap().map(
      (key, value) => MapEntry(
        value.displayName,
        _flutterRouteFieldAnnotationChecker
            .annotationsOf(value)
            .map(ConstantReader.new),
      ),
    );

    final constructorParameters = _resolveConstructorFields(constructor);
    return constructorParameters
        .map(
          (parameter) => _getConfigFromField(
            fieldsWithAnnotation[parameter.type.argumentName],
            parameter,
          ),
        )
        .toList();
  }

  RouteFieldConfig _getConfigFromField(
    Iterable<ConstantReader>? annotations,
    _RawRouteFieldConfig parameterData,
  ) {
    final flutterRouteField = annotations?.firstOrNull;
    final queryName = flutterRouteField?.peek('queryName')?.stringValue;
    final ignore = flutterRouteField?.peek('ignore')?.boolValue;
    final addToJson = flutterRouteField?.peek('addToJson')?.boolValue;

    return RouteFieldConfig(
      type: parameterData.type,
      defaultValue: parameterData.defaultValue,
      queryName:
          parameterData.queryName ??
          queryName ??
          parameterData.type.argumentName,
      ignore: parameterData.ignore ?? ignore,
      addToJson: parameterData.addToJson ?? addToJson ?? true,
    );
  }
}

class _RawRouteFieldConfig {
  final ImportableType type;
  final String? defaultValue;
  final bool? ignore;
  final bool? addToJson;
  final String? queryName;

  _RawRouteFieldConfig({
    required this.type,
    required this.defaultValue,
    this.ignore,
    this.addToJson,
    this.queryName,
  });
}
