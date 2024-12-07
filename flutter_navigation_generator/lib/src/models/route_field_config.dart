import 'dart:convert';

import 'package:flutter_navigation_generator/src/models/importable_type.dart';

class RouteFieldConfig {
  final ImportableType type;
  final dynamic defaultValue;
  final bool ignore;
  final bool addToJson;
  final String queryName;

  RouteFieldConfig({
    required this.type,
    required this.defaultValue,
    required this.ignore,
    required this.addToJson,
    required this.queryName,
  });

  RouteFieldConfig copyWith({
    ImportableType? type,
    dynamic defaultValue,
    bool? ignore,
    bool? addToJson,
    String? queryName,
  }) {
    return RouteFieldConfig(
      type: type ?? this.type,
      defaultValue: defaultValue ?? this.defaultValue,
      ignore: ignore ?? this.ignore,
      addToJson: addToJson ?? this.addToJson,
      queryName: queryName ?? this.queryName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.toMap(),
      'defaultValue': defaultValue,
      'ignore': ignore,
      'addToJson': addToJson,
      'queryName': queryName,
    };
  }

  factory RouteFieldConfig.fromMap(Map<String, dynamic> map) {
    return RouteFieldConfig(
      type: ImportableType.fromMap(map['type']),
      defaultValue: map['defaultValue'],
      ignore: map['ignore'],
      addToJson: map['addToJson'] ?? true,
      queryName: map['queryName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteFieldConfig.fromJson(String source) => RouteFieldConfig.fromMap(json.decode(source));

  @override
  String toString() {
    return 'RouteFieldConfig(type: $type, defaultValue: $defaultValue, ignore: $ignore, addToJson: $addToJson, queryName: $queryName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RouteFieldConfig &&
        other.type == type &&
        other.defaultValue == defaultValue &&
        other.ignore == ignore &&
        other.addToJson == addToJson &&
        other.queryName == queryName;
  }

  @override
  int get hashCode {
    return type.hashCode ^ defaultValue.hashCode ^ ignore.hashCode ^ addToJson.hashCode ^ queryName.hashCode;
  }
}
