import 'package:collection/collection.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/utils/importable_type_to_string.dart';
import 'package:test/test.dart';

void main() {
  String convertType(String className) =>
      ImportableTypeToStringUtils.convertFromString(
          ImportableType(className: className), 's');
  final mapRegex = RegExp(
      '[^<>]*<([^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>))?>))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>))?>))?>))?>), ?([^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>))?>))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>)(?:, ?(?:[^<>]*|[^<>]*<(?:[^<>]*)(?:, ?(?:[^<>]*))?>))?>))?>))?>)>');

  // void initRegex() {
  //   var regex = '[^<>]*<([^<>]*|(?R))(?:, ?([^<>]*|(?R)))?>';
  //   var regexReplacement = '[^<>]*<(?:[^<>]*|(?R))(?:, ?(?:[^<>]*|(?R)))?>';
  //   regexReplacement = regexReplacement.replaceAll('(?R)', regexReplacement);
  //   regexReplacement = regexReplacement.replaceAll('(?R)', regexReplacement);
  //   // This is exponential, so two times is definatly enough
  //   regexReplacement = regexReplacement.replaceAll('|(?R)', '');
  //   regex = regex.replaceAll('(?R)', regexReplacement);
  //   mapRegex = RegExp(regex);
  // }

  void checkType(String className, String expected) {
    final result = convertType(className);
    expect(result, expected);
  }

  void checkImportableType(ImportableType type, String expected) {
    final result = ImportableTypeToStringUtils.convertFromString(type, 's');
    expect(result, expected);
  }

  ImportableType? typeFromString(String string) {
    final match = mapRegex.firstMatch(string);
    if (match == null) {
      return ImportableType(
          className: string.replaceAll('?', ''),
          isNullable: string.endsWith('?'));
    }
    final String? typeKey = match.group(1);
    final String? typeValue = match.group(2);
    if (typeKey == null) return ImportableType(className: string);
    if (typeValue == null) {
      return ImportableType(
          className: 'List',
          typeArguments: [typeFromString(typeKey)].whereNotNull().toList());
    }
    return ImportableType(
        className: 'Map',
        typeArguments: [typeFromString(typeKey), typeFromString(typeValue)]
            .whereNotNull()
            .toList());
  }

  void checkMap(String type, String expected) {
    final importableType = typeFromString(type)!;
    final result =
        ImportableTypeToStringUtils.convertFromString(importableType, 's');
    expect(result, expected);
  }

  group('ImportableTypeToStringUtils', () {
    test('Dart basic types', () {
      final testTypes = {
        'int': 'int.parse(s)',
        'double': 'double.parse(s)',
        'bool': "s == 'true'",
        'num': 'num.parse(s)',
        'String': 's',
        'dynamic': 's',
      };
      for (final testType in testTypes.entries) {
        checkType(testType.key, testType.value);
      }
    });

    test('Custom object', () {
      const className = 'CustomObject';
      const expected =
          'CustomObject.fromJson(jsonDecode(utf8.decode(base64Decode(s))))';
      checkType(className, expected);
    });
  });

  group('Lists', () {
    test('List with basic types', () {
      final testTypes = ['int', 'double', 'bool', 'num', 'String', 'dynamic'];
      expectType(String type) => type == 'dynamic'
          ? '(jsonDecode(utf8.decode(base64Decode(s))) as List<dynamic>).map((e) => e).toList()'
          : '(jsonDecode(utf8.decode(base64Decode(s))) as List<dynamic>).map((e) => e as $type).toList()';
      for (final testType in testTypes) {
        checkImportableType(
            ImportableType(
                className: 'List',
                typeArguments: [ImportableType(className: testType)]),
            expectType(testType));
      }
    });

    test('List with basic types that are nullable', () {
      final testTypes = ['int', 'double', 'bool', 'num', 'String', 'dynamic'];
      expectType(String type) => type == 'dynamic'
          ? '(jsonDecode(utf8.decode(base64Decode(s))) as List<dynamic>).map((e) => e).toList()'
          : '(jsonDecode(utf8.decode(base64Decode(s))) as List<dynamic>).map((e) => e as $type?).toList()';
      for (final testType in testTypes) {
        checkImportableType(
            ImportableType(className: 'List', typeArguments: [
              ImportableType(className: testType, isNullable: true)
            ]),
            expectType(testType));
      }
    });

    test('List with custom type that might be nullable', () {
      const expectNonNullable =
          '(jsonDecode(utf8.decode(base64Decode(s))) as List<dynamic>).map((e) => CustomObject.fromJson(e as Map<String, dynamic>)).toList()';
      checkImportableType(
          const ImportableType(
              className: 'List',
              typeArguments: [ImportableType(className: 'CustomObject')]),
          expectNonNullable);

      const expectNullable =
          '(jsonDecode(utf8.decode(base64Decode(s))) as List<dynamic>).map((e) => e == null ? null : CustomObject.fromJson(e as Map<String, dynamic>)).toList()';
      checkImportableType(
          const ImportableType(className: 'List', typeArguments: [
            ImportableType(className: 'CustomObject', isNullable: true)
          ]),
          expectNullable);
    });
  });

  group('Maps', () {
    test('Map with basic types', () {
      checkMap('Map<String, dynamic>',
          'Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(s))))');
      checkMap('Map<String, int>',
          'Map<String, int>.from(jsonDecode(utf8.decode(base64Decode(s))))');
      checkMap('Map<int, int>',
          'Map<int, int>.from(jsonDecode(utf8.decode(base64Decode(s))))');
    });

    test('Map with basic types nullable', () {
      checkMap('Map<String?, dynamic>',
          'Map<String?, dynamic>.from(jsonDecode(utf8.decode(base64Decode(s))))');
      checkMap('Map<String, int?>',
          'Map<String, int?>.from(jsonDecode(utf8.decode(base64Decode(s))))');
      checkMap('Map<int?, int?>',
          'Map<int?, int?>.from(jsonDecode(utf8.decode(base64Decode(s))))');
    });

    test('Map with custom types', () {
      checkMap('Map<String, CustomObject>',
          'Map<String, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(k, CustomObject.fromJson(v as Map<String, dynamic>))))');
      checkMap('Map<CustomObject, String>',
          'Map<CustomObject, String>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(CustomObject.fromJson(k as Map<String, dynamic>), v)))');
      checkMap('Map<CustomObject, CustomObject>',
          'Map<CustomObject, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(CustomObject.fromJson(k as Map<String, dynamic>), CustomObject.fromJson(v as Map<String, dynamic>))))');
    });

    test('Map with custom nullable', () {
      checkMap('Map<String, CustomObject?>',
          'Map<String, CustomObject?>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(k, v == null ? null : CustomObject.fromJson(v as Map<String, dynamic>))))');
      checkMap('Map<CustomObject?, String>',
          'Map<CustomObject?, String>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(k == null ? null : CustomObject.fromJson(k as Map<String, dynamic>), v)))');
      checkMap('Map<CustomObject?, CustomObject?>',
          'Map<CustomObject?, CustomObject?>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(k == null ? null : CustomObject.fromJson(k as Map<String, dynamic>), v == null ? null : CustomObject.fromJson(v as Map<String, dynamic>))))');
    });
  });

  group('Maps & Lists go deeper', () {
    test('Map with map', () {
      checkMap('Map<String, Map<String, dynamic>>',
          'Map<String, Map>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(k, Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(v)))))))');
      checkMap('Map<Map<String, dynamic>, String>',
          'Map<Map, String>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(k)))), v)))');
      checkMap('Map<Map<String, dynamic>, Map<String, dynamic>>',
          'Map<Map, Map>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(k)))), Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(v)))))))');
    });

    test('Map with map with map', () {
      checkMap('Map<String, Map<String, Map<String, dynamic>>>',
          'Map<String, Map>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(k, Map<String, Map>.from(jsonDecode(utf8.decode(base64Decode(v))).map((k, v) => MapEntry(k, Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(v))))))))))');
      checkMap('Map<Map<Map<String, dynamic>, dynamic>, String>',
          'Map<Map, String>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(Map<Map, dynamic>.from(jsonDecode(utf8.decode(base64Decode(k))).map((k, v) => MapEntry(Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(k)))), v))), v)))');
      checkMap(
          'Map<Map<Map<String, dynamic>, Map<String, dynamic>>, Map<Map<String, dynamic>, Map<String, dynamic>>>',
          'Map<Map, Map>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(Map<Map, Map>.from(jsonDecode(utf8.decode(base64Decode(k))).map((k, v) => MapEntry(Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(k)))), Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(v))))))), Map<Map, Map>.from(jsonDecode(utf8.decode(base64Decode(v))).map((k, v) => MapEntry(Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(k)))), Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(v))))))))))');
    });

    test('Map with map with map with custom types', () {
      checkMap(
          'Map<CustomObject, Map<CustomObject, Map<CustomObject, dynamic>>>',
          'Map<CustomObject, Map>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(CustomObject.fromJson(k as Map<String, dynamic>), Map<CustomObject, Map>.from(jsonDecode(utf8.decode(base64Decode(v))).map((k, v) => MapEntry(CustomObject.fromJson(k as Map<String, dynamic>), Map<CustomObject, dynamic>.from(jsonDecode(utf8.decode(base64Decode(v))).map((k, v) => MapEntry(CustomObject.fromJson(k as Map<String, dynamic>), v)))))))))');
      checkMap(
          'Map<Map<Map<String, CustomObject>, CustomObject>, CustomObject>',
          'Map<Map, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(Map<Map, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(k))).map((k, v) => MapEntry(Map<String, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(k))).map((k, v) => MapEntry(k, CustomObject.fromJson(v as Map<String, dynamic>)))), CustomObject.fromJson(v as Map<String, dynamic>)))), CustomObject.fromJson(v as Map<String, dynamic>))))');
      checkMap(
          'Map<Map<Map<String, CustomObject>, Map<String, dynamic>>, Map<Map<CustomObject, dynamic>, Map<String, CustomObject>>>',
          'Map<Map, Map>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(Map<Map, Map>.from(jsonDecode(utf8.decode(base64Decode(k))).map((k, v) => MapEntry(Map<String, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(k))).map((k, v) => MapEntry(k, CustomObject.fromJson(v as Map<String, dynamic>)))), Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(v))))))), Map<Map, Map>.from(jsonDecode(utf8.decode(base64Decode(v))).map((k, v) => MapEntry(Map<CustomObject, dynamic>.from(jsonDecode(utf8.decode(base64Decode(k))).map((k, v) => MapEntry(CustomObject.fromJson(k as Map<String, dynamic>), v))), Map<String, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(v))).map((k, v) => MapEntry(k, CustomObject.fromJson(v as Map<String, dynamic>))))))))))');
    });

    test('Map with List', () {
      checkMap('Map<String, List<String>>',
          'Map<String, List<String>>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(k, List<String>.fromJson(v as Map<String, dynamic>))))');
      checkMap('Map<List<String>, String>',
          'Map<List<String>, String>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(List<String>.fromJson(k as Map<String, dynamic>), v)))');
      checkMap('Map<List<CustomObject>, CustomObject>',
          'Map<List<CustomObject>, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(List<CustomObject>.fromJson(k as Map<String, dynamic>), CustomObject.fromJson(v as Map<String, dynamic>))))');
    });

    test('List with Map', () {
      checkMap('List<Map<String, dynamic>>',
          'Map<String, dynamic>.from(jsonDecode(utf8.decode(base64Decode(s))))');
      checkMap('List<Map<CustomObject, CustomObject>>',
          'Map<CustomObject, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(CustomObject.fromJson(k as Map<String, dynamic>), CustomObject.fromJson(v as Map<String, dynamic>))))');
    });

    test('Let\'s go deeper', () {
      checkMap(
          'List<Map<double, List<Map<List<Map<CustomObject, CustomObject>>, int>>>>',
          'Map<double, Map>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(k, Map<Map, int>.from(jsonDecode(utf8.decode(base64Decode(v))).map((k, v) => MapEntry(Map<CustomObject, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(k))).map((k, v) => MapEntry(CustomObject.fromJson(k as Map<String, dynamic>), CustomObject.fromJson(v as Map<String, dynamic>)))), v))))))');
    });

    test('Let\'s go deeper with nullables', () {
      checkMap(
          'List<Map<double?, List<Map<List<Map<CustomObject?, CustomObject>>, int>>?>>',
          'Map<Map, int>.from(jsonDecode(utf8.decode(base64Decode(s))).map((k, v) => MapEntry(Map<CustomObject?, CustomObject>.from(jsonDecode(utf8.decode(base64Decode(k))).map((k, v) => MapEntry(k == null ? null : CustomObject.fromJson(k as Map<String, dynamic>), CustomObject.fromJson(v as Map<String, dynamic>)))), v)))');
    });
  });
}
