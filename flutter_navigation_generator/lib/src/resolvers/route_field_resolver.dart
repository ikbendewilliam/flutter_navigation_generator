import 'package:analyzer/dart/element/element.dart';
import 'package:collection/collection.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_field_config.dart';
import 'package:flutter_navigation_generator/src/resolvers/importable_type_resolver.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:source_gen/source_gen.dart';

const TypeChecker _flutterRouteFieldAnnotationChecker = TypeChecker.fromRuntime(FlutterRouteField);

class RouteFieldResolver {
  final ImportableTypeResolverImpl _typeResolver;

  RouteFieldResolver(List<LibraryElement> libs) : _typeResolver = ImportableTypeResolverImpl(libs);

  List<RouteFieldConfig> resolveConstructorFieldsMethod(ExecutableElement constructor) {
    final constructorParameters = constructor.parameters;

    return constructorParameters.map((parameter) {
      final field = _typeResolver.resolveType(
        parameter.type,
        isRequired: parameter.isRequired,
        name: parameter.name,
      );
      final annotation = _flutterRouteFieldAnnotationChecker.annotationsOf(parameter, throwOnUnresolved: false).map(ConstantReader.new);
      if (annotation.isEmpty) {
        return RouteFieldConfig(
          type: field,
          defaultValue: parameter.defaultValueCode,
          queryName: field.name!,
          ignore: false,
          addToJson: true,
        );
      }
      return getConfigFromField(
        annotation,
        null,
        field,
      );
    }).toList();
  }

  List<RouteFieldConfig> resolveFieldsMethod(ClassElement classElement, List<RouteFieldConfig> fields) {
    final fieldsWithAnnotation =
        classElement.fields.asMap().map((key, value) => MapEntry(value.displayName, _flutterRouteFieldAnnotationChecker.annotationsOf(value).map(ConstantReader.new)));

    return fieldsWithAnnotation.entries.map((entry) {
      final field = entry.key;
      final fieldData = fields.firstWhere((element) => element.queryName == field);
      final annotations = entry.value;

      return getConfigFromField(
        annotations,
        fieldData,
        null,
      );
    }).toList();
  }

  RouteFieldConfig getConfigFromField(
    Iterable<ConstantReader> annotations,
    RouteFieldConfig? fieldData,
    ImportableType? type,
  ) {
    assert(fieldData != null || type != null);
    final annotation = annotations.firstOrNull;
    final flutterRouteField = annotation?.read('flutterRouteField');
    final queryName = flutterRouteField?.peek('queryName')?.stringValue;
    final ignore = flutterRouteField?.peek('ignore')?.boolValue;
    final addToJson = flutterRouteField?.peek('addToJson')?.boolValue;

    return RouteFieldConfig(
      type: fieldData?.type ?? type!,
      defaultValue: fieldData?.defaultValue,
      queryName: queryName ?? fieldData?.queryName ?? type!.name!,
      ignore: ignore ?? fieldData?.ignore ?? (type!.className == 'Key' && type.name == 'key'),
      addToJson: addToJson ?? fieldData?.addToJson ?? true,
    );
  }
}
