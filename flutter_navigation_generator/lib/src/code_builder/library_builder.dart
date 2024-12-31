import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/import_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/navigator_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/route_names_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class LibraryGenerator {
  final Set<RouteConfig> routes;
  final String className;
  final Uri? targetFile;
  final ImportableType? pageType;
  final ImportableType? unknownRoute;
  final List<String> removeSuffixes;
  final List<ImportableType> defaultGuards;
  final bool ignoreKeysByDefault;
  final IncludeQueryParametersType includeQueryParametersNavigatorConfig;

  LibraryGenerator({
    required this.routes,
    required this.className,
    required this.includeQueryParametersNavigatorConfig,
    this.targetFile,
    this.pageType,
    this.unknownRoute,
    this.removeSuffixes = const [],
    this.defaultGuards = const [],
    this.ignoreKeysByDefault = true,
  });

  Library generate() {
    return Library(
      (b) => b
        ..ignoreForFile.addAll(['prefer_const_constructors'])
        ..directives.addAll(
          ImportBuilder(
            routes: routes,
            pageType: pageType,
            targetFile: targetFile,
            defaultGuards: defaultGuards,
            ignoreKeysByDefault: ignoreKeysByDefault,
            includeQueryParametersNavigatorConfig: includeQueryParametersNavigatorConfig,
          ).generate(),
        )
        ..body.addAll(
          [
            NavigatorBuilder(
              className: className,
              routes: routes,
              pageType: pageType,
              targetFile: targetFile,
              unknownRoute: unknownRoute,
              defaultGuards: defaultGuards,
              ignoreKeysByDefault: ignoreKeysByDefault,
              includeQueryParametersNavigatorConfig: includeQueryParametersNavigatorConfig,
            ).generate(),
            RouteNamesBuilder(
              routes: routes,
              removeSuffixes: removeSuffixes,
            ).generate(),
          ],
        ),
    );
  }
}
