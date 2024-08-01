import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:path/path.dart' as p;

abstract class ImportableTypeResolver {
  String? resolveImport(Element element);

  ImportableType resolveType(
    DartType type, {
    bool isRequired = false,
    String? name,
    bool forceNullable = false,
  });

  ImportableType resolveFunctionType(FunctionType function,
      [ExecutableElement? executableElement]);

  static String? relative(String? path, Uri? to) {
    if (path == null || to == null) {
      return null;
    }
    var fileUri = Uri.parse(path);
    var libName = to.pathSegments.first;
    if ((to.scheme == 'package' &&
            fileUri.scheme == 'package' &&
            fileUri.pathSegments.first == libName) ||
        (to.scheme == 'asset' && fileUri.scheme != 'package')) {
      if (fileUri.path == to.path) {
        return fileUri.pathSegments.last;
      } else {
        return p.posix
            .relative(fileUri.path, from: to.path)
            .replaceFirst('../', '');
      }
    } else {
      return path;
    }
  }

  static String? resolveAssetImport(String? path) {
    if (path == null) {
      return null;
    }
    var fileUri = Uri.parse(path);
    if (fileUri.scheme == "asset") {
      return "/${fileUri.path}";
    }
    return path;
  }
}

class ImportableTypeResolverImpl extends ImportableTypeResolver {
  final List<LibraryElement> libs;

  ImportableTypeResolverImpl(this.libs);

  @override
  String? resolveImport(Element? element) {
    // return early if source is null or element is a core type
    if (element?.source == null || _isCoreDartType(element)) {
      return null;
    }

    for (var lib in libs) {
      if (!_isCoreDartType(lib) &&
          lib.exportNamespace.definedNames.values.contains(element)) {
        return lib.identifier;
      }
    }
    return null;
  }

  bool _isCoreDartType(Element? element) {
    return element?.source?.fullName == 'dart:core';
  }

  @override
  ImportableType resolveFunctionType(FunctionType function,
      [ExecutableElement? executableElement]) {
    final functionElement =
        executableElement ?? function.element ?? function.alias?.element;
    if (functionElement == null) {
      throw 'Can not resolve function type \nTry using an alias e.g typedef MyFunction = ${function.getDisplayString(withNullability: false)};';
    }
    final displayName = functionElement.displayName;
    var functionName = displayName;

    Element elementToImport = functionElement;
    var enclosingElement = functionElement.enclosingElement;

    if (enclosingElement != null && enclosingElement is ClassElement) {
      functionName = '${enclosingElement.displayName}.$displayName';
      elementToImport = enclosingElement;
    }

    return ImportableType(
      className: functionName,
      import: resolveImport(elementToImport),
      isNullable: function.nullabilitySuffix == NullabilitySuffix.question,
      isEnum: enclosingElement is EnumElement,
    );
  }

  List<ImportableType> _resolveTypeArguments(DartType typeToCheck) {
    final importableTypes = <ImportableType>[];
    if (typeToCheck is ParameterizedType) {
      for (DartType type in typeToCheck.typeArguments) {
        if (type.element is TypeParameterElement) {
          importableTypes.add(const ImportableType(className: 'dynamic'));
        } else {
          importableTypes.add(ImportableType(
            className: type.element?.name?.replaceAll('?', '') ??
                type.getDisplayString(withNullability: false),
            import: resolveImport(type.element),
            isNullable: type.nullabilitySuffix == NullabilitySuffix.question,
            typeArguments: _resolveTypeArguments(type),
            isEnum: type.element is EnumElement,
          ));
        }
      }
    }
    return importableTypes;
  }

  @override
  ImportableType resolveType(
    DartType type, {
    bool isRequired = false,
    String? name,
    bool forceNullable = false,
  }) {
    return ImportableType(
      className:
          type.element?.name ?? type.getDisplayString(withNullability: false),
      name: name,
      isNullable:
          forceNullable || type.nullabilitySuffix == NullabilitySuffix.question,
      import: resolveImport(type.element),
      isRequired: isRequired,
      typeArguments: _resolveTypeArguments(type),
      isEnum: type.element is EnumElement,
    );
  }
}
