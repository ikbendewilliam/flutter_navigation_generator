import 'package:flutter_navigation_generator/src/code_builder/import_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/models/route_field_config.dart';
import 'package:test/test.dart';

void main() {
  group('ImportBuilder', () {
    test('always have material import', () {
      final directives = ImportBuilder(routes: {}).generate();
      expect(directives.any((element) => element.url == 'dart:convert'), true);
      expect(
        directives.any(
          (element) => element.url == 'package:flutter/material.dart',
        ),
        true,
      );
      expect(directives.length, 2);
    });

    test('imports for routeWidget', () {
      const testImport = 'package:test/test.dart';
      final config = RouteConfig(
        routeWidget: const ImportableType(
          className: 'test',
          import: testImport,
        ),
      );
      final directives = ImportBuilder(routes: {config}).generate();
      expect(directives.any((element) => element.url == 'dart:convert'), true);
      expect(directives.any((element) => element.url == testImport), true);
      expect(
        directives.any(
          (element) => element.url == 'package:flutter/material.dart',
        ),
        true,
      );
      expect(directives.length, 3);
    });

    test('imports for parameters', () {
      const testImport = 'package:test/test.dart';
      final config = RouteConfig(
        routeWidget: const ImportableType(className: 'test'),
        parameters: [
          RouteFieldConfig(
            type: const ImportableType(className: 'test2', import: testImport),
            addToJson: true,
            defaultValue: null,
            ignore: false,
            queryName: 'test',
          ),
        ],
      );
      final directives = ImportBuilder(routes: {config}).generate();
      expect(directives.any((element) => element.url == 'dart:convert'), true);
      expect(directives.any((element) => element.url == testImport), true);
      expect(
        directives.any(
          (element) => element.url == 'package:flutter/material.dart',
        ),
        true,
      );
      expect(directives.length, 3);
    });
  });
}
