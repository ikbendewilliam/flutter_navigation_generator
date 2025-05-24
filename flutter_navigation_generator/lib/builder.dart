import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/generators/flutter_navigation_generator.dart';
import 'src/generators/flutter_navigator_generator.dart';

/// A builder that generates a json file for one or more routes.
Builder flutterRouteBuilder(BuilderOptions options) {
  return LibraryBuilder(
    const FlutterRouteGenerator(),
    formatOutput: (generated, version) => generated.replaceAll(RegExp(r'//.*|\s'), ''),
    generatedExtension: '.navigator.json',
  );
}

/// A builder that generates the navigator class.
Builder flutterNavigatorBuilder(BuilderOptions options) {
  return LibraryBuilder(FlutterNavigatorGenerator(), generatedExtension: '.navigator.dart');
}
