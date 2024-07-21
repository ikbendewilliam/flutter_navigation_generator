// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/on_generate_route_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:test/test.dart';

// For debugging purposes
const printActuals = false;

void main() {
  group('OnGenerateRouteBuilder', () {
    test('Empty routes', () {
      final content = OnGenerateRouteBuilder(
        routes: {},
      ).generate();

      expect(content.name, 'onGenerateRoute');
      expect(content.returns?.symbol, 'Route<dynamic>?');
      expect(content.requiredParameters.first.name, 'settings');
      expect(content.requiredParameters.first.type?.symbol, 'RouteSettings');
      expect(content.requiredParameters.length, 1);
      expect(content.body is Block, true);
      expect((content.body as Block).statements.first.toString(), 'return null;');
      expect((content.body as Block).statements.length, 1);
    });

    test('1 test route no return', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.test: return MaterialPageRoute<void>(builder: (_) => TestPage(), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('2 test route with return', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test_without_return',
            routeWidget: const ImportableType(
              className: 'TestPageWithoutReturn',
            ),
          ),
          RouteConfig(
            routeName: 'test_with_return',
            routeWidget: const ImportableType(
              className: 'TestPageWithReturn',
            ),
            returnType: const ImportableType(
              className: 'ReturnType',
            ),
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.testWithoutReturn: return MaterialPageRoute<void>(builder: (_) => TestPageWithoutReturn(), settings: settings, fullscreenDialog: false,);case RouteNames.testWithReturn: return MaterialPageRoute<ReturnType>(builder: (_) => TestPageWithReturn(), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('test route with return & unknownRoute', () {
      final content = OnGenerateRouteBuilder(
        unknownRoute: const ImportableType(
          className: 'Route404',
        ),
        routes: {
          RouteConfig(
            routeName: 'test_without_return',
            routeWidget: const ImportableType(
              className: 'TestPageWithoutReturn',
            ),
          ),
          RouteConfig(
            routeName: 'test_with_return',
            routeWidget: const ImportableType(
              className: 'TestPageWithReturn',
            ),
            returnType: const ImportableType(
              className: 'ReturnType',
            ),
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.testWithoutReturn: return MaterialPageRoute<void>(builder: (_) => TestPageWithoutReturn(), settings: settings, fullscreenDialog: false,);case RouteNames.testWithReturn: return MaterialPageRoute<ReturnType>(builder: (_) => TestPageWithReturn(), settings: settings, fullscreenDialog: false,);}",
        "return MaterialPageRoute<void>(builder: (_) => Route404(), settings: settings, fullscreenDialog: false,);",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('test routename starting with a number', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: '404',
            routeWidget: const ImportableType(
              className: 'Route404',
            ),
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.r404: return MaterialPageRoute<void>(builder: (_) => Route404(), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('1 test route with constructorName', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            constructorName: 'constructorName',
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.test: return MaterialPageRoute<void>(builder: (_) => TestPage.constructorName(), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('1 test route with isFullscreenDialog', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
              routeName: 'test',
              routeWidget: const ImportableType(
                className: 'TestPage',
              ),
              isFullscreenDialog: true),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.test: return MaterialPageRoute<void>(builder: (_) => TestPage(), settings: settings, fullscreenDialog: true,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('1 test route with CustomPageType', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            pageType: const ImportableType(
              className: 'CustomPageType',
            ),
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.test: return CustomPageType<void>(builder: (_) => TestPage(), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('1 test route with CustomPageType from navigator', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
          ),
        },
        pageType: const ImportableType(
          className: 'CustomPageType',
        ),
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.test: return CustomPageType<void>(builder: (_) => TestPage(), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('1 test route with parameters', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            parameters: [
              const ImportableType(className: 'bool', name: 'testBool', isNullable: true),
              const ImportableType(className: 'int', name: 'testInt'),
            ],
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.test: return MaterialPageRoute<void>(builder: (_) => TestPage(testBool: arguments['testBool'] is String ? arguments['testBool'] == 'true' : arguments['testBool'] as bool?,testInt: arguments['testInt'] is String ? int.parse(arguments['testInt']) : arguments['testInt'] as int,), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('1 test route with parameters in routeName', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test/:testBool',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            parameters: [
              const ImportableType(className: 'bool', name: 'testBool', isNullable: true),
              const ImportableType(className: 'int', name: 'testInt'),
            ],
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {}",
        "final pathSegments = settingsUri.pathSegments;",
        "if (pathSegments.length == 2) {if (pathSegments[0] == 'test') {arguments['testBool'] = pathSegments[1];return MaterialPageRoute<void>(builder: (_) => TestPage(testBool: arguments['testBool'] is String ? arguments['testBool'] == 'true' : arguments['testBool'] as bool?,testInt: arguments['testInt'] is String ? int.parse(arguments['testInt']) : arguments['testInt'] as int,), settings: settings, fullscreenDialog: false,);}}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('1 test route with routeName /', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: '/',
            methodName: 'TestPage',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            parameters: [
              const ImportableType(className: 'bool', name: 'testBool', isNullable: true),
              const ImportableType(className: 'int', name: 'testInt'),
            ],
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.testPage: return MaterialPageRoute<void>(builder: (_) => TestPage(testBool: arguments['testBool'] is String ? arguments['testBool'] == 'true' : arguments['testBool'] as bool?,testInt: arguments['testInt'] is String ? int.parse(arguments['testInt']) : arguments['testInt'] as int,), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('1 test route with parameters in routeName ending with /', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test/:testBool/',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            parameters: [
              const ImportableType(className: 'bool', name: 'testBool', isNullable: true),
              const ImportableType(className: 'int', name: 'testInt'),
            ],
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {}",
        "final pathSegments = settingsUri.pathSegments;",
        "if (pathSegments.length == 3) {if (pathSegments[0] == 'test' && pathSegments[2] == '') {arguments['testBool'] = pathSegments[1];return MaterialPageRoute<void>(builder: (_) => TestPage(testBool: arguments['testBool'] is String ? arguments['testBool'] == 'true' : arguments['testBool'] as bool?,testInt: arguments['testInt'] is String ? int.parse(arguments['testInt']) : arguments['testInt'] as int,), settings: settings, fullscreenDialog: false,);}}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('1 test route with parameters and default values', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            parameters: [
              const ImportableType(className: 'bool', name: 'testBool', isNullable: true),
              const ImportableType(className: 'int', name: 'testInt'),
            ],
            defaultValues: {
              'testBool': 'true',
              'testInt': '1',
            },
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.test: return MaterialPageRoute<void>(builder: (_) => TestPage(testBool: arguments['testBool'] is String ? arguments['testBool'] == 'true' : arguments['testBool'] as bool?,testInt: arguments['testInt'] is String ? int.parse(arguments['testInt']) : arguments['testInt'] as int,), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('1 test route with generatePageRoute false', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            generatePageRoute: false,
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      expect((content.body as Block).statements.first.toString(), 'return null;');
      expect((content.body as Block).statements.length, 1);
    });

    test('1 test route with dialog', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            navigationType: NavigationType.dialog,
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      expect((content.body as Block).statements.first.toString(), 'return null;');
      expect((content.body as Block).statements.length, 1);
    });

    test('1 test route with bottomsheet', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            navigationType: NavigationType.bottomSheet,
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      expect((content.body as Block).statements.first.toString(), 'return null;');
      expect((content.body as Block).statements.length, 1);
    });

    test('guards', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
            guards: const [
              ImportableType(className: 'TestGuard'),
            ],
          ),
          RouteConfig(
            routeName: 'test2',
            routeWidget: const ImportableType(
              className: 'TestPage2',
            ),
          ),
        },
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.test: final testGuard = guards.whereType<TestGuard>().first;\nif (!testGuard.value) {\n  guardedRouteSettings = settings;\n  return onGenerateRoute(RouteSettings(\n    arguments: settings.arguments,\n    name: testGuard.alternativeRoute,\n  ));\n}\nreturn MaterialPageRoute<void>(builder: (_) => TestPage(), settings: settings, fullscreenDialog: false,);case RouteNames.test2: return MaterialPageRoute<void>(builder: (_) => TestPage2(), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });

    test('defaultGuards', () {
      final content = OnGenerateRouteBuilder(
        routes: {
          RouteConfig(
            routeName: 'test',
            routeWidget: const ImportableType(
              className: 'TestPage',
            ),
          ),
          RouteConfig(
            routeName: 'test2',
            routeWidget: const ImportableType(
              className: 'TestPage2',
            ),
            guards: [],
          ),
        },
        defaultGuards: [
          const ImportableType(className: 'TestGuard'),
        ],
      ).generate();

      expect(content.body is Block, true);
      final bodyStatements = (content.body as Block).statements.map((f) => f.toString()).toList();
      final expectedStatements = [
        "final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};\n    final settingsUri = Uri.parse(settings.name ?? '');\n    settingsUri.queryParameters.forEach((key, value) {\n      arguments[key] ??= value;\n    });",
        "switch (settingsUri.path) {case RouteNames.test: final testGuard = guards.whereType<TestGuard>().first;\nif (!testGuard.value) {\n  guardedRouteSettings = settings;\n  return onGenerateRoute(RouteSettings(\n    arguments: settings.arguments,\n    name: testGuard.alternativeRoute,\n  ));\n}\nreturn MaterialPageRoute<void>(builder: (_) => TestPage(), settings: settings, fullscreenDialog: false,);case RouteNames.test2: return MaterialPageRoute<void>(builder: (_) => TestPage2(), settings: settings, fullscreenDialog: false,);}",
        "return null;",
      ];
      if (printActuals) print(jsonEncode(bodyStatements));
      expect(bodyStatements.length, expectedStatements.length);
      for (var i = 0; i < bodyStatements.length; i++) {
        expect(bodyStatements[i].toString(), expectedStatements[i]);
      }
    });
  });
}
