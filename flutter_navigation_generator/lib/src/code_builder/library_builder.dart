import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/import_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/navigator_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/route_names_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';

class LibraryGenerator {
  final Set<RouteConfig> routes;
  final String className;
  final Uri? targetFile;
  final ImportableType? pageType;
  final ImportableType? unknownRoute;
  final List<String> removeSuffixes;

  LibraryGenerator({
    required this.routes,
    required this.className,
    this.targetFile,
    this.pageType,
    this.unknownRoute,
    this.removeSuffixes = const [],
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
