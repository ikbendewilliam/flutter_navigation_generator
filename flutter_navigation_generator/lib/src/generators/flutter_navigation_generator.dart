import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:flutter_navigation_generator/src/resolvers/route_resolver.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:source_gen/source_gen.dart';

const TypeChecker _typeChecker = TypeChecker.fromRuntime(FlutterRoute);

class FlutterRouteGenerator implements Generator {
  const FlutterRouteGenerator();

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) async {
    final routesInStep = (await Future.wait(
      library.classes.where(_typeChecker.hasAnnotationOf).map(
            (e) async => RouteResolver(
              await buildStep.resolver.libraries.toList(),
            ).resolve(e),
          ),
    ))
        .expand((element) => element);
    return routesInStep.isNotEmpty ? jsonEncode(routesInStep.map((e) => e.toMap()).toList()) : null;
  }
}
