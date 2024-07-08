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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
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
        pageType: null,
        targetFile: null,
      ).generate();

      expect(content.body is Block, true);
      expect((content.body as Block).statements.first.toString(), 'return null;');
      expect((content.body as Block).statements.length, 1);
    });
  });
}
