import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';

class ImportBuilder {
  final Set<RouteConfig> routes;
  final Uri? targetFile;
  final ImportableType? pageType;

  ImportBuilder({
    required this.routes,
    this.targetFile,
    this.pageType,
  });

  Iterable<Directive> generate() {
    final imports = <String?>{'package:flutter/material.dart', 'dart:convert'};
    imports.add(typeRefer(pageType, targetFile: targetFile).url);
    imports.addAll(routes
        .map((route) => [
              typeRefer(route.routeWidget, targetFile: targetFile).url,
              typeRefer(route.pageType, targetFile: targetFile).url,
              typeRefer(route.returnType, targetFile: targetFile).url,
              ...route.parameters
                  .map((e) => typeRefer(e, targetFile: targetFile).url),
            ])
        .expand((element) => element));
    return imports.whereType<String>().map(Directive.import);
  }
}
