import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:dart_style/dart_style.dart';
import 'package:flutter_navigation_generator/src/code_builder/library_builder.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/resolvers/importable_type_resolver.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:glob/glob.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:source_gen/source_gen.dart';

class FlutterNavigatorGenerator extends GeneratorForAnnotation<FlutterNavigator> {
  static const _navigatorClassNameDefault = 'BaseNavigator';

  @override
  dynamic generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async {
    final typeResolver = ImportableTypeResolverImpl(await buildStep.resolver.libraries.toList());
    final configFiles = Glob("**.navigator.json");
    final navigatorClassName = annotation.peek('navigatorClassName')?.stringValue;
    final pageTypeAsDartType = annotation.peek('pageType')?.typeValue;
    final unknownRouteAsDartType = annotation.peek('unknownRoute')?.typeValue;
    final ignoreKeysByDefault = annotation.peek('ignoreKeysByDefault')?.boolValue ?? true;
    final removeSuffixes = annotation.peek('removeSuffixes')?.listValue.map((e) => e.toStringValue()).whereType<String>().toList() ?? [];
    final defaultGuards = annotation.peek('defaultGuards')?.listValue.map((e) => e.toTypeValue()).whereNotNull().map(typeResolver.resolveType).toList() ?? [];
    final pageType = pageTypeAsDartType == null ? null : typeResolver.resolveType(pageTypeAsDartType);
    final unknownRoute = unknownRouteAsDartType == null ? null : typeResolver.resolveType(unknownRouteAsDartType);
    final includeQueryParametersNavigatorConfig =
        IncludeQueryParametersType.values[annotation.peek('includeQueryParameters')?.peek('index')?.intValue ?? IncludeQueryParametersType.onlyOnWeb.index];
    final jsonData = <Map>[];

    await for (final id in buildStep.findAssets(configFiles)) {
      final dynamic json = jsonDecode(await buildStep.readAsString(id));
      jsonData.addAll((json as List).map((dynamic e) => e as Map).toList());
    }

    final routes = <RouteConfig>{};
    for (final json in jsonData) {
      routes.add(RouteConfig.fromMap(json as Map<String, dynamic>));
    }

    final generator = LibraryGenerator(
      routes: routes,
      className: navigatorClassName ?? _navigatorClassNameDefault,
      targetFile: element.source?.uri,
      pageType: pageType,
      unknownRoute: unknownRoute,
      removeSuffixes: removeSuffixes,
      defaultGuards: defaultGuards,
      ignoreKeysByDefault: ignoreKeysByDefault,
      includeQueryParametersNavigatorConfig: includeQueryParametersNavigatorConfig,
    );

    final generatedLib = generator.generate();

    final emitter = DartEmitter(
      allocator: Allocator.simplePrefixing(),
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    return DartFormatter(languageVersion: Version(3, 7, 0)).format(generatedLib.accept(emitter).toString());
  }
}
