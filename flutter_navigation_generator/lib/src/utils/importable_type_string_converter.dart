import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';

class ImportableTypeStringConverter {
  static String convertFromString(ImportableType p, String s) {
    if (p.isEnum) return '${p.className}.values[int.parse($s)]';
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
    if (p.isEnum) return '${p.className}.values[e]';
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
    if (p.isEnum) return '${p.className}.values[$s]';
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

  static bool _isAcceptableType(String className) {
    return ([
      'String',
      'int',
      'double',
      'num',
      'bool',
    ].contains(className));
  }

  static String convertToString(ImportableType argument) {
    final name = argument.argumentName;
    var value = '';
    if (argument.className == 'String') return name;
    if (argument.isEnum) {
      value += '$name${argument.isNullable ? '?' : ''}.index.toString()';
    } else if (_isAcceptableType(argument.className)) {
      value += '$name${argument.isNullable ? '?' : ''}.toString()';
    } else {
      if (_deepCheckForEnum(argument)) {
        return '$value base64Encode(utf8.encode(jsonEncode(${convertToStringWithEnum(argument, name)})))';
      }
      value += 'base64Encode(utf8.encode(jsonEncode($name)))';
    }
    return value;
  }

  static bool _deepCheckForEnum(ImportableType argument) {
    if (argument.isEnum) return true;
    if (argument.className != 'List' && argument.className != 'Map') {
      return false;
    }
    return argument.typeArguments.any(_deepCheckForEnum);
  }

  static String convertToStringWithEnum(ImportableType argument, String s) {
    final suffix = argument.isNullable ? '?' : '';
    if (argument.isEnum) return '$s$suffix.index';
    return switch (argument.className) {
      'List' =>
        '$s$suffix.map((e) => ${convertToStringWithEnum(argument.typeArguments.first, 'e')}).toList()',
      'Map' =>
        '$s$suffix.map((k, v) => MapEntry(${convertToStringWithEnum(argument.typeArguments.first, 'k')}, ${convertToStringWithEnum(argument.typeArguments[1], 'v')}))',
      _ => s,
    };
  }
}
