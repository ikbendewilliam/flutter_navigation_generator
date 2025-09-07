import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:path/path.dart' as p;

abstract class ImportableTypeResolver {
  String? resolveImport(Element2 element);

  ImportableType resolveType(
    DartType type, {
    bool isRequired = false,
    String? name,
    bool forceNullable = false,
  });

  ImportableType resolveFunctionType(FunctionType function, [ExecutableElement2? executableElement]);

  static String? relative(String? path, Uri? to) {
    if (path == null || to == null) {
      return null;
    }
    var fileUri = Uri.parse(path);
    var libName = to.pathSegments.first;
    if ((to.scheme == 'package' && fileUri.scheme == 'package' && fileUri.pathSegments.first == libName) || (to.scheme == 'asset' && fileUri.scheme != 'package')) {
      if (fileUri.path == to.path) {
        return fileUri.pathSegments.last;
      } else {
        return p.posix.relative(fileUri.path, from: to.path).replaceFirst('../', '');
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
  final List<LibraryElement2> libs;

  ImportableTypeResolverImpl(this.libs);

  @override
  String? resolveImport(Element2? element) {
    // return early if source is null or element is a core type
    if (element?.library2 == null || _isCoreDartType(element)) {
      return null;
    }

    for (var lib in libs) {
      if (!_isCoreDartType(lib) && lib.exportNamespace.definedNames2.values.contains(element)) {
        return lib.uri.toString();
      }
    }
    return null;
  }

  bool _isCoreDartType(Element2? element) => element?.library2?.isDartCore ?? false;

  @override
  ImportableType resolveFunctionType(FunctionType function, [ExecutableElement2? executableElement]) {
    final functionElement = executableElement ?? function.element ?? function.alias?.element2;
    if (functionElement == null) {
      throw 'Can not resolve function type \nTry using an alias e.g typedef MyFunction = ${function.getDisplayString()};';
    }
    final displayName = functionElement.displayName;
    var functionName = displayName;

    Element2 elementToImport = functionElement;
    var enclosingElement = functionElement.enclosingElement2;

    if (enclosingElement != null && enclosingElement is ClassElement2) {
      functionName = '${enclosingElement.displayName}.$displayName';
      elementToImport = enclosingElement;
    }

    return ImportableType(
      className: functionName,
      import: resolveImport(elementToImport),
      isNullable: function.nullabilitySuffix == NullabilitySuffix.question,
      isEnum: enclosingElement is EnumElement2,
    );
  }

  List<ImportableType> _resolveTypeArguments(DartType typeToCheck) {
    final importableTypes = <ImportableType>[];
    if (typeToCheck is ParameterizedType) {
      for (DartType type in typeToCheck.typeArguments) {
        if (type.element3 is TypeParameterElement2) {
          importableTypes.add(const ImportableType(className: 'dynamic'));
        } else {
          importableTypes.add(ImportableType(
            className: type.element3?.displayName.replaceAll('?', '') ?? type.getDisplayString().replaceAll('?', ''),
            import: resolveImport(type.element3),
            isNullable: type.nullabilitySuffix == NullabilitySuffix.question,
            typeArguments: _resolveTypeArguments(type),
            isEnum: type.element3 is EnumElement2,
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
      className: type.element3?.displayName ?? type.getDisplayString().replaceAll('?', ''),
      name: name,
      isNullable: forceNullable || type.nullabilitySuffix == NullabilitySuffix.question,
      import: resolveImport(type.element3),
      isRequired: isRequired,
      typeArguments: _resolveTypeArguments(type),
      isEnum: type.element3 is EnumElement2,
    );
  }
}
