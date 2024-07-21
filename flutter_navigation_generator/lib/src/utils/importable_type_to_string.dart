import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';

class ImportableTypeToStringUtils {
  static String convertFromString(ImportableType p, String s) {
    return switch (p.className) {
      'int' => 'int.parse($s)',
      'double' => 'double.parse($s)',
      'bool' => "$s == 'true'",
      'num' => 'num.parse($s)',
      'String' || 'dynamic' => s,
      'List' =>
        '(jsonDecode(utf8.decode(base64Decode($s))) as List<dynamic>).map((e) => ${convertTypeArguments(p.typeArguments.first)}).toList()',
      'Map' => convertMap(p, s),
      _ =>
        '${typeRefer(p).symbol}.fromJson(jsonDecode(utf8.decode(base64Decode($s))))',
    };
  }

  static String convertTypeArguments(ImportableType p) {
    final suffix = p.isNullable ? '?' : '';
    return switch (p.className) {
      'int' ||
      'double' ||
      'bool' ||
      'num' ||
      'String' =>
        'e as ${p.className}$suffix',
      'dynamic' => 'e',
      'Map' => convertMap(p, ('e')),
      'List' =>
        '(e as List<dynamic>).map((e) => ${convertTypeArguments(p.typeArguments.first)}).toList()',
      _ =>
        '${p.isNullable ? 'e == null ? null : ' : ''}${p.className}.fromJson(e as Map<String, dynamic>)',
    };
  }

  static String convertMap(ImportableType p, String s) {
    final typeKey = p.typeArguments.first;
    final typeValue = p.typeArguments[1];
    final mapFrom =
        'Map<${typeKey.className}${typeKey.isNullable ? '?' : ''}, ${typeValue.className}${typeValue.isNullable ? '?' : ''}>.from';
    final decode = 'jsonDecode(utf8.decode(base64Decode($s)))';
    final keyTransformer = convertMapTransformer(typeKey, 'k');
    final valueTransformer = convertMapTransformer(typeValue, 'v');
    if (keyTransformer.length == 1 && valueTransformer.length == 1) {
      return '$mapFrom($decode)';
    }
    return '$mapFrom($decode.map((k, v) => MapEntry($keyTransformer, $valueTransformer)))';
  }

  static String convertMapTransformer(ImportableType p, String s) {
    return switch (p.className) {
      'int' || 'double' || 'bool' || 'num' || 'String' || 'dynamic' => s,
      'Map' =>
        '${p.isNullable ? '$s == null ? null : ' : ''}${convertMap(p, s)}',
      'List' =>
        '${p.isNullable ? '$s == null ? null : ' : ''}($s as List<dynamic>).map((e) => ${convertTypeArguments(p.typeArguments.first)}).toList()',
      _ =>
        '${p.isNullable ? '$s == null ? null : ' : ''}${p.className}.fromJson($s as Map<String, dynamic>)',
    };
  }
}
