import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class ImportBuilder {
  final Set<RouteConfig> routes;
  final Uri? targetFile;
  final ImportableType? pageType;
  final List<ImportableType> defaultGuards;
  final IncludeQueryParametersType? includeQueryParametersNavigatorConfig;

  ImportBuilder({
    required this.routes,
    this.targetFile,
    this.pageType,
    this.defaultGuards = const [],
    this.includeQueryParametersNavigatorConfig,
  });

  Iterable<Directive> generate() {
    final imports = <String?>{
      'package:flutter/material.dart',
      'dart:convert',
      if (routes.any((route) => route.guards?.isNotEmpty == true) ||
          defaultGuards.isNotEmpty)
        'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart',
      if (routes.any((route) =>
              route.includeQueryParameters ==
              IncludeQueryParametersType.onlyOnWeb) ||
          (includeQueryParametersNavigatorConfig ==
                  IncludeQueryParametersType.onlyOnWeb &&
              routes.any((route) => route.includeQueryParameters == null)))
        'package:flutter/foundation.dart',
    };
    imports.add(typeRefer(pageType, targetFile: targetFile).url);
    imports.addAll(
        defaultGuards.map((e) => typeRefer(e, targetFile: targetFile).url));
    imports.addAll(routes.expand(
      (route) => [
        typeRefer(route.routeWidget, targetFile: targetFile).url,
        typeRefer(route.pageType, targetFile: targetFile).url,
        typeRefer(route.returnType, targetFile: targetFile).url,
        ...route.parameters.expand((e) => [
              typeRefer(e, targetFile: targetFile).url,
              ...e.typeArguments
                  .map((e) => typeRefer(e, targetFile: targetFile).url),
            ]),
        ...?route.guards?.map((e) => typeRefer(e, targetFile: targetFile).url),
      ],
    ));
    return imports.whereType<String>().map(Directive.import);
  }
}
