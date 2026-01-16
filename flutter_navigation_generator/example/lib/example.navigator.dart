// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// FlutterNavigatorGenerator
// **************************************************************************

// ignore_for_file: prefer_const_constructors

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:convert';

import 'package:example/custom_model.dart' as _i2;
import 'package:example/main.dart' as _i3;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' as _i1;
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_animations/flutter_navigation_generator_animations.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

import 'custom_model.dart';
import 'main.dart';

mixin BaseNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final Set<NavigatorGuard> guards = <NavigatorGuard>{
    ExampleDefaultGuard(),
    LoginGuard(),
  };

  RouteSettings? guardedRouteSettings;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final arguments =
        settings.arguments is Map
            ? (settings.arguments as Map).cast<String, dynamic>()
            : <String, dynamic>{};
    final settingsUri = Uri.parse(settings.name ?? '');
    final queryParameters = Map.from(settingsUri.queryParameters);
    switch (settingsUri.path) {
      case RouteNames.myHomePage:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(
            RouteSettings(
              arguments: settings.arguments,
              name: exampleDefaultGuard.alternativeRoute,
            ),
          );
        }
        return NativeRouteAnimation<void>(
          builder:
              (_) => MyHomePage(
                title:
                    queryParameters['page_title'] ??
                    arguments['title'] as String?,
                key: arguments['key'] as Key?,
              ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.myHomePagePopAll:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(
            RouteSettings(
              arguments: settings.arguments,
              name: exampleDefaultGuard.alternativeRoute,
            ),
          );
        }
        return NativeRouteAnimation<void>(
          builder:
              (_) => MyHomePage(
                title:
                    queryParameters['page_title'] ??
                    arguments['title'] as String?,
                key: arguments['key'] as Key?,
              ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.secondPage:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(
            RouteSettings(
              arguments: settings.arguments,
              name: exampleDefaultGuard.alternativeRoute,
            ),
          );
        }
        return FadeInRouteAnimation<bool>(
          builder: (_) => SecondPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.exampleScreenWithRequiredArgument:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(
            RouteSettings(
              arguments: settings.arguments,
              name: exampleDefaultGuard.alternativeRoute,
            ),
          );
        }
        return NativeRouteAnimation<void>(
          builder:
              (_) => ExampleScreenWithRequiredArgument(
                data:
                    queryParameters['data'] != null
                        ? (jsonDecode(
                                  utf8.decode(
                                    base64Decode(queryParameters['data']!),
                                  ),
                                )
                                as List<dynamic>)
                            .map(
                              (e) => CustomModel.fromJson(
                                e as Map<String, dynamic>,
                              ),
                            )
                            .toList()
                        : arguments['data'] as List<CustomModel>,
              ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.r404:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(
            RouteSettings(
              arguments: settings.arguments,
              name: exampleDefaultGuard.alternativeRoute,
            ),
          );
        }
        return NativeRouteAnimation<void>(
          builder: (_) => Error404(),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.errorNotLoggedIn:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(
            RouteSettings(
              arguments: settings.arguments,
              name: exampleDefaultGuard.alternativeRoute,
            ),
          );
        }
        return NativeRouteAnimation<void>(
          builder: (_) => ErrorNotLoggedIn(),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.loggedInPage:
        final loginGuard = guards.whereType<LoginGuard>().first;
        if (!loginGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(
            RouteSettings(
              arguments: settings.arguments,
              name: loginGuard.alternativeRoute,
            ),
          );
        }
        return NativeRouteAnimation<void>(
          builder: (_) => LoggedInPage(),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.fieldValueTests:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(
            RouteSettings(
              arguments: settings.arguments,
              name: exampleDefaultGuard.alternativeRoute,
            ),
          );
        }
        return NativeRouteAnimation<void>(
          builder:
              (_) => FieldValueTests(
                nonNullableString:
                    queryParameters['nonNullableString'] ??
                    arguments['nonNullableString'] as String,
                nonNullableInt:
                    queryParameters['nonNullableInt'] != null
                        ? int.parse(queryParameters['nonNullableInt']!)
                        : arguments['nonNullableInt'] as int,
                nonNullableBool:
                    queryParameters['nonNullableBool'] != null
                        ? queryParameters['nonNullableBool']! == 'true'
                        : arguments['nonNullableBool'] as bool,
                nonNullableDouble:
                    queryParameters['nonNullableDouble'] != null
                        ? double.parse(queryParameters['nonNullableDouble']!)
                        : arguments['nonNullableDouble'] as double,
                nonNullableList:
                    queryParameters['nonNullableList'] != null
                        ? (jsonDecode(
                                  utf8.decode(
                                    base64Decode(
                                      queryParameters['nonNullableList']!,
                                    ),
                                  ),
                                )
                                as List<dynamic>)
                            .map((e) => e as String)
                            .toList()
                        : arguments['nonNullableList'] as List<String>,
                nonNullableMap:
                    queryParameters['nonNullableMap'] != null
                        ? Map<String, String>.from(
                          jsonDecode(
                            utf8.decode(
                              base64Decode(queryParameters['nonNullableMap']!),
                            ),
                          ),
                        )
                        : arguments['nonNullableMap'] as Map<String, String>,
                nonNullableCustomModel:
                    queryParameters['nonNullableCustomModel'] != null
                        ? CustomModel.fromJson(
                          jsonDecode(
                            utf8.decode(
                              base64Decode(
                                queryParameters['nonNullableCustomModel']!,
                              ),
                            ),
                          ),
                        )
                        : arguments['nonNullableCustomModel'] as CustomModel,
                nullableString:
                    queryParameters['nullableString'] ??
                    arguments['nullableString'] as String?,
                nullableInt:
                    queryParameters['nullableInt'] != null
                        ? int.parse(queryParameters['nullableInt']!)
                        : arguments['nullableInt'] as int?,
                nullableBool:
                    queryParameters['nullableBool'] != null
                        ? queryParameters['nullableBool']! == 'true'
                        : arguments['nullableBool'] as bool?,
                nullableDouble:
                    queryParameters['nullableDouble'] != null
                        ? double.parse(queryParameters['nullableDouble']!)
                        : arguments['nullableDouble'] as double?,
                nullableList:
                    queryParameters['nullableList'] != null
                        ? (jsonDecode(
                                  utf8.decode(
                                    base64Decode(
                                      queryParameters['nullableList']!,
                                    ),
                                  ),
                                )
                                as List<dynamic>)
                            .map((e) => e as String)
                            .toList()
                        : arguments['nullableList'] as List<String>?,
                nullableMap:
                    queryParameters['nullableMap'] != null
                        ? Map<String, String>.from(
                          jsonDecode(
                            utf8.decode(
                              base64Decode(queryParameters['nullableMap']!),
                            ),
                          ),
                        )
                        : arguments['nullableMap'] as Map<String, String>?,
                nullableCustomModel:
                    queryParameters['nullableCustomModel'] != null
                        ? CustomModel.fromJson(
                          jsonDecode(
                            utf8.decode(
                              base64Decode(
                                queryParameters['nullableCustomModel']!,
                              ),
                            ),
                          ),
                        )
                        : arguments['nullableCustomModel'] as CustomModel?,
                nonNullableStringWithDefaultValue:
                    queryParameters['nonNullableStringWithDefaultValue'] ??
                    arguments['nonNullableStringWithDefaultValue'] as String? ??
                    'default',
                nonNullableIntWithDefaultValue:
                    queryParameters['nonNullableIntWithDefaultValue'] != null
                        ? int.parse(
                          queryParameters['nonNullableIntWithDefaultValue']!,
                        )
                        : arguments['nonNullableIntWithDefaultValue'] as int? ??
                            42,
                nonNullableBoolWithDefaultValue:
                    queryParameters['nonNullableBoolWithDefaultValue'] != null
                        ? queryParameters['nonNullableBoolWithDefaultValue']! ==
                            'true'
                        : arguments['nonNullableBoolWithDefaultValue']
                                as bool? ??
                            true,
                nonNullableDoubleWithDefaultValue:
                    queryParameters['nonNullableDoubleWithDefaultValue'] != null
                        ? double.parse(
                          queryParameters['nonNullableDoubleWithDefaultValue']!,
                        )
                        : arguments['nonNullableDoubleWithDefaultValue']
                                as double? ??
                            3.14,
                nonNullableListWithDefaultValue:
                    queryParameters['nonNullableListWithDefaultValue'] != null
                        ? (jsonDecode(
                                  utf8.decode(
                                    base64Decode(
                                      queryParameters['nonNullableListWithDefaultValue']!,
                                    ),
                                  ),
                                )
                                as List<dynamic>)
                            .map((e) => e as String)
                            .toList()
                        : arguments['nonNullableListWithDefaultValue']
                                as List<String>? ??
                            const ['default'],
                nonNullableMapWithDefaultValue:
                    queryParameters['nonNullableMapWithDefaultValue'] != null
                        ? Map<String, String>.from(
                          jsonDecode(
                            utf8.decode(
                              base64Decode(
                                queryParameters['nonNullableMapWithDefaultValue']!,
                              ),
                            ),
                          ),
                        )
                        : arguments['nonNullableMapWithDefaultValue']
                                as Map<String, String>? ??
                            const {'default': 'default'},
                nonNullableCustomModelWithDefaultValue:
                    queryParameters['nonNullableCustomModelWithDefaultValue'] !=
                            null
                        ? CustomModel.fromJson(
                          jsonDecode(
                            utf8.decode(
                              base64Decode(
                                queryParameters['nonNullableCustomModelWithDefaultValue']!,
                              ),
                            ),
                          ),
                        )
                        : arguments['nonNullableCustomModelWithDefaultValue']
                                as CustomModel? ??
                            const CustomModel('default', 0),
                nonNullableCustomModelWithDefaultValue2:
                    queryParameters['nonNullableCustomModelWithDefaultValue2'] !=
                            null
                        ? CustomModel.fromJson(
                          jsonDecode(
                            utf8.decode(
                              base64Decode(
                                queryParameters['nonNullableCustomModelWithDefaultValue2']!,
                              ),
                            ),
                          ),
                        )
                        : arguments['nonNullableCustomModelWithDefaultValue2']
                                as CustomModel? ??
                            CustomModel.testDefault,
              ),
          settings: settings,
          fullscreenDialog: false,
        );
    }
    final pathSegments = settingsUri.pathSegments;
    if (pathSegments.length == 6) {
      if (pathSegments[0] == 'home' &&
          pathSegments[4] == 'number1' &&
          pathSegments[5] == '') {
        queryParameters['id'] = pathSegments[1];
        queryParameters['name'] = pathSegments[2];
        queryParameters['nonExistingName'] = pathSegments[3];
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(
            RouteSettings(
              arguments: settings.arguments,
              name: exampleDefaultGuard.alternativeRoute,
            ),
          );
        }
        return NativeRouteAnimation<void>(
          builder:
              (_) => RouteNameWithArguments(
                id: queryParameters['id'] ?? arguments['id'] as String,
                model:
                    queryParameters['model'] != null
                        ? CustomModel.fromJson(
                          jsonDecode(
                            utf8.decode(
                              base64Decode(queryParameters['model']!),
                            ),
                          ),
                        )
                        : arguments['model'] as CustomModel?,
                name: queryParameters['name'] ?? arguments['name'] as String?,
                age:
                    queryParameters['age'] != null
                        ? int.parse(queryParameters['age']!)
                        : arguments['age'] as int?,
              ),
          settings: settings,
          fullscreenDialog: false,
        );
      }
    }
    if (pathSegments.length == 5) {
      if (pathSegments[0] == 'home' && pathSegments[2] == 'example') {
        queryParameters['id'] = pathSegments[1];
        queryParameters['exampleEnum'] = pathSegments[3];
        queryParameters['age'] = pathSegments[4];
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(
            RouteSettings(
              arguments: settings.arguments,
              name: exampleDefaultGuard.alternativeRoute,
            ),
          );
        }
        return NativeRouteAnimation<void>(
          builder:
              (_) => RouteNameWithArguments2(
                id: queryParameters['id'] ?? arguments['id'] as String,
                exampleEnum:
                    queryParameters['exampleEnum'] != null
                        ? ExampleEnum.values[int.parse(
                          queryParameters['exampleEnum']!,
                        )]
                        : arguments['exampleEnum'] as ExampleEnum,
                exampleEnum2:
                    queryParameters['exampleEnum2'] != null
                        ? ExampleEnum.values[int.parse(
                          queryParameters['exampleEnum2']!,
                        )]
                        : arguments['exampleEnum2'] as ExampleEnum,
                name: queryParameters['name'] ?? arguments['name'] as String?,
                age:
                    queryParameters['age'] != null
                        ? int.parse(queryParameters['age']!)
                        : arguments['age'] as int?,
                exampleEnum3:
                    queryParameters['exampleEnum3'] != null
                        ? ExampleEnum.values[int.parse(
                          queryParameters['exampleEnum3']!,
                        )]
                        : arguments['exampleEnum3'] as ExampleEnum?,
                exampleEnums4:
                    queryParameters['exampleEnums4'] != null
                        ? (jsonDecode(
                                  utf8.decode(
                                    base64Decode(
                                      queryParameters['exampleEnums4']!,
                                    ),
                                  ),
                                )
                                as List<dynamic>)
                            .map((e) => ExampleEnum.values[e])
                            .toList()
                        : arguments['exampleEnums4'] as List<ExampleEnum>?,
                exampleEnumsMap5:
                    queryParameters['exampleEnumsMap5'] != null
                        ? Map<String, ExampleEnum>.from(
                          jsonDecode(
                            utf8.decode(
                              base64Decode(
                                queryParameters['exampleEnumsMap5']!,
                              ),
                            ),
                          ).map((k, v) => MapEntry(k, ExampleEnum.values[v])),
                        )
                        : arguments['exampleEnumsMap5']
                            as Map<String, ExampleEnum>?,
              ),
          settings: settings,
          fullscreenDialog: false,
        );
      }
    }
    return NativeRouteAnimation<void>(
      builder: (_) => Error404(),
      settings: settings,
      fullscreenDialog: false,
    );
  }

  /// Update a specific guard, useful for events (for example after login/logout)
  Future<void> updateGuard<T extends NavigatorGuard>() =>
      guards.whereType<T>().first.updateValue();

  /// Update all guards, useful for web apps. Add to main file so it's called when navigating manually
  Future<void> updateGuards() =>
      Future.wait(guards.map((e) => e.updateValue()));

  /// Continues navigation. A guard will reroute navigation to a page. Call this method to continue navigation after the guard has rerouted
  ///
  /// Example:
  /// ```dart
  /// Future<void> login(details) async {
  ///  ...do login
  ///  await navigator.updateGuard<LoginGuard>();
  ///  if (navigator.canContinueNavigation) return navigator.continueNavigation();
  ///  return navigator.goToHome();
  /// }
  /// ```
  Future<void> continueNavigation() async {
    final settings = guardedRouteSettings;
    if (settings == null) return;
    guardedRouteSettings = null;
    return navigatorKey.currentState?.pushReplacementNamed<void, dynamic>(
      settings.name!,
      arguments: settings.arguments,
    );
  }

  /// Whether we can continues navigation. A guard will reroute navigation to a page. Call this method to continue navigation after the guard has rerouted
  ///
  /// Example:
  /// ```dart
  /// Future<void> login(details) async {
  ///  ...do login
  ///  await navigator.updateGuard<LoginGuard>();
  ///  if (navigator.canContinueNavigation) return navigator.continueNavigation();
  ///  return navigator.goToHome();
  /// }
  /// ```
  bool canContinueNavigation() => guardedRouteSettings != null;

  Future<void> goToMyHomePage({String? title, _i1.Key? key}) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        Uri(
          path: RouteNames.myHomePage,
          queryParameters:
              kIsWeb
                  ? ({
                    'page_title': title,
                    'key':
                        key == null
                            ? null
                            : base64Encode(utf8.encode(jsonEncode(key))),
                  }..removeWhere((_, v) => v == null))
                  : null,
        ).toString(),
        arguments: {'title': title, 'key': key},
      );

  void goToHomePageWithPathParameter({String? title, _i1.Key? key}) =>
      navigatorKey.currentState?.pushNamedAndRemoveUntil<dynamic>(
        Uri(
          path: RouteNames.myHomePagePopAll,
          queryParameters:
              kIsWeb
                  ? ({
                    'page_title': title,
                    'key':
                        key == null
                            ? null
                            : base64Encode(utf8.encode(jsonEncode(key))),
                  }..removeWhere((_, v) => v == null))
                  : null,
        ).toString(),
        (_) => false,
        arguments: {'title': title, 'key': key},
      );

  Future<bool?> goToSecondPage() async {
    final dynamic result = await navigatorKey.currentState?.pushNamed<dynamic>(
      RouteNames.secondPage,
      arguments: {},
    );
    return (result as bool?);
  }

  Future<bool?> popAndGoToSecondPage() async {
    final dynamic result = await navigatorKey.currentState
        ?.popAndPushNamed<dynamic, dynamic>(
          RouteNames.secondPage,
          arguments: {},
        );
    return (result as bool?);
  }

  Future<void> customName({
    required String id,
    _i2.CustomModel? model,
    String? name,
    int? age,
  }) async => navigatorKey.currentState?.pushNamed<dynamic>(
    Uri(
      path: RouteNames.homeIdNameNonExistingNameNumber1(id: id, name: name),
      queryParameters:
          kIsWeb
              ? ({
                'model':
                    model == null
                        ? null
                        : base64Encode(utf8.encode(jsonEncode(model))),
                'age': age?.toString(),
              }..removeWhere((_, v) => v == null))
              : null,
    ).toString(),
    arguments: {'id': id, 'model': model, 'name': name, 'age': age},
  );

  Future<void> goToRouteNameWithArguments2({
    required String id,
    required _i3.ExampleEnum exampleEnum,
    required _i3.ExampleEnum exampleEnum2,
    String? name,
    int? age,
    _i3.ExampleEnum? exampleEnum3,
    List<_i3.ExampleEnum>? exampleEnums4,
    Map<String, _i3.ExampleEnum>? exampleEnumsMap5,
  }) async => navigatorKey.currentState?.pushNamed<dynamic>(
    Uri(
      path: RouteNames.homeIdExampleExampleEnumAge(
        id: id,
        exampleEnum: exampleEnum.index.toString(),
        age: age?.toString(),
      ),
      queryParameters:
          kIsWeb
              ? ({
                'exampleEnum2': exampleEnum2.index.toString(),
                'name': name,
                'exampleEnum3': exampleEnum3?.index.toString(),
                'exampleEnums4': base64Encode(
                  utf8.encode(
                    jsonEncode(exampleEnums4?.map((e) => e.index).toList()),
                  ),
                ),
                'exampleEnumsMap5': base64Encode(
                  utf8.encode(
                    jsonEncode(
                      exampleEnumsMap5?.map((k, v) => MapEntry(k, v.index)),
                    ),
                  ),
                ),
              }..removeWhere((_, v) => v == null))
              : null,
    ).toString(),
    arguments: {
      'id': id,
      'exampleEnum': exampleEnum,
      'exampleEnum2': exampleEnum2,
      'name': name,
      'age': age,
      'exampleEnum3': exampleEnum3,
      'exampleEnums4': exampleEnums4,
      'exampleEnumsMap5': exampleEnumsMap5,
    },
  );

  Future<void> goToExampleScreenWithRequiredArgument({
    required List<_i2.CustomModel> data,
  }) async => navigatorKey.currentState?.pushNamed<dynamic>(
    Uri(
      path: RouteNames.exampleScreenWithRequiredArgument,
      queryParameters:
          kIsWeb ? {'data': base64Encode(utf8.encode(jsonEncode(data)))} : null,
    ).toString(),
    arguments: {'data': data},
  );

  Future<void> goToLoggedInPage() async => navigatorKey.currentState
      ?.pushNamed<dynamic>(RouteNames.loggedInPage, arguments: {});

  Future<void> goToFieldValueTests({
    required String nonNullableString,
    required int nonNullableInt,
    required bool nonNullableBool,
    required double nonNullableDouble,
    required List<String> nonNullableList,
    required Map<String, String> nonNullableMap,
    required _i2.CustomModel nonNullableCustomModel,
    String? nullableString,
    int? nullableInt,
    bool? nullableBool,
    double? nullableDouble,
    List<String>? nullableList,
    Map<String, String>? nullableMap,
    _i2.CustomModel? nullableCustomModel,
    String nonNullableStringWithDefaultValue = 'default',
    int nonNullableIntWithDefaultValue = 42,
    bool nonNullableBoolWithDefaultValue = true,
    double nonNullableDoubleWithDefaultValue = 3.14,
    List<String> nonNullableListWithDefaultValue = const ['default'],
    Map<String, String> nonNullableMapWithDefaultValue = const {
      'default': 'default',
    },
    _i2.CustomModel nonNullableCustomModelWithDefaultValue = const CustomModel(
      'default',
      0,
    ),
    _i2.CustomModel nonNullableCustomModelWithDefaultValue2 =
        CustomModel.testDefault,
  }) async => navigatorKey.currentState?.pushNamed<dynamic>(
    Uri(
      path: RouteNames.fieldValueTests,
      queryParameters:
          kIsWeb
              ? ({
                'nonNullableString': nonNullableString,
                'nonNullableInt': nonNullableInt.toString(),
                'nonNullableBool': nonNullableBool.toString(),
                'nonNullableDouble': nonNullableDouble.toString(),
                'nonNullableList': base64Encode(
                  utf8.encode(jsonEncode(nonNullableList)),
                ),
                'nonNullableMap': base64Encode(
                  utf8.encode(jsonEncode(nonNullableMap)),
                ),
                'nonNullableCustomModel': base64Encode(
                  utf8.encode(jsonEncode(nonNullableCustomModel)),
                ),
                'nullableString': nullableString,
                'nullableInt': nullableInt?.toString(),
                'nullableBool': nullableBool?.toString(),
                'nullableDouble': nullableDouble?.toString(),
                'nullableList': base64Encode(
                  utf8.encode(jsonEncode(nullableList)),
                ),
                'nullableMap': base64Encode(
                  utf8.encode(jsonEncode(nullableMap)),
                ),
                'nullableCustomModel':
                    nullableCustomModel == null
                        ? null
                        : base64Encode(
                          utf8.encode(jsonEncode(nullableCustomModel)),
                        ),
                'nonNullableStringWithDefaultValue':
                    nonNullableStringWithDefaultValue,
                'nonNullableIntWithDefaultValue':
                    nonNullableIntWithDefaultValue.toString(),
                'nonNullableBoolWithDefaultValue':
                    nonNullableBoolWithDefaultValue.toString(),
                'nonNullableDoubleWithDefaultValue':
                    nonNullableDoubleWithDefaultValue.toString(),
                'nonNullableListWithDefaultValue': base64Encode(
                  utf8.encode(jsonEncode(nonNullableListWithDefaultValue)),
                ),
                'nonNullableMapWithDefaultValue': base64Encode(
                  utf8.encode(jsonEncode(nonNullableMapWithDefaultValue)),
                ),
                'nonNullableCustomModelWithDefaultValue': base64Encode(
                  utf8.encode(
                    jsonEncode(nonNullableCustomModelWithDefaultValue),
                  ),
                ),
                'nonNullableCustomModelWithDefaultValue2': base64Encode(
                  utf8.encode(
                    jsonEncode(nonNullableCustomModelWithDefaultValue2),
                  ),
                ),
              }..removeWhere((_, v) => v == null))
              : null,
    ).toString(),
    arguments: {
      'nonNullableString': nonNullableString,
      'nonNullableInt': nonNullableInt,
      'nonNullableBool': nonNullableBool,
      'nonNullableDouble': nonNullableDouble,
      'nonNullableList': nonNullableList,
      'nonNullableMap': nonNullableMap,
      'nonNullableCustomModel': nonNullableCustomModel,
      'nullableString': nullableString,
      'nullableInt': nullableInt,
      'nullableBool': nullableBool,
      'nullableDouble': nullableDouble,
      'nullableList': nullableList,
      'nullableMap': nullableMap,
      'nullableCustomModel': nullableCustomModel,
      'nonNullableStringWithDefaultValue': nonNullableStringWithDefaultValue,
      'nonNullableIntWithDefaultValue': nonNullableIntWithDefaultValue,
      'nonNullableBoolWithDefaultValue': nonNullableBoolWithDefaultValue,
      'nonNullableDoubleWithDefaultValue': nonNullableDoubleWithDefaultValue,
      'nonNullableListWithDefaultValue': nonNullableListWithDefaultValue,
      'nonNullableMapWithDefaultValue': nonNullableMapWithDefaultValue,
      'nonNullableCustomModelWithDefaultValue':
          nonNullableCustomModelWithDefaultValue,
      'nonNullableCustomModelWithDefaultValue2':
          nonNullableCustomModelWithDefaultValue2,
    },
  );

  Future<void> showDialogExampleDialog({required String text}) async =>
      showCustomDialog<dynamic>(
        widget: _i3.ExampleDialog(text: text),
        routeName: RouteNames.exampleDialog,
      );

  Future<void> showSheetRecursiveNavigationBottomSheet({
    int layers = 1,
  }) async => showBottomSheet<dynamic>(
    widget: _i3.RecursiveNavigationBottomSheet(layers: layers),
    routeName: RouteNames.recursiveNavigationBottomSheet,
  );

  void goBack() => navigatorKey.currentState?.pop();

  void goBackWithResult<T>({T? result}) =>
      navigatorKey.currentState?.pop(result);

  void popUntil(bool Function(Route<dynamic>) predicate) =>
      navigatorKey.currentState?.popUntil(predicate);

  void goBackTo(String routeName) =>
      popUntil((route) => route.settings.name?.split('?').first == routeName);

  Future<T?> showCustomDialog<T>({Widget? widget, String? routeName}) async =>
      showDialog<T>(
        context: navigatorKey.currentContext!,
        routeSettings:
            routeName == null ? null : RouteSettings(name: routeName),
        builder: (_) => widget ?? const SizedBox.shrink(),
      );

  Future<T?> showBottomSheet<T>({Widget? widget, String? routeName}) async =>
      showModalBottomSheet<T>(
        context: navigatorKey.currentContext!,
        routeSettings:
            routeName == null ? null : RouteSettings(name: routeName),
        builder: (_) => widget ?? const SizedBox.shrink(),
      );
}

class RouteNames {
  /// /
  static const myHomePage = '/';

  /// /my-home-page-pop-all/
  static const myHomePagePopAll = '/my-home-page-pop-all/';

  /// /second
  static const secondPage = '/second';

  /// /recursive-navigation-bottom-sheet
  static const recursiveNavigationBottomSheet =
      '/recursive-navigation-bottom-sheet';

  /// /example-dialog
  static const exampleDialog = '/example-dialog';

  /// /example-screen-with-required-argument
  static const exampleScreenWithRequiredArgument =
      '/example-screen-with-required-argument';

  /// /404
  static const r404 = '/404';

  /// /error-not-logged-in
  static const errorNotLoggedIn = '/error-not-logged-in';

  /// /logged-in
  static const loggedInPage = '/logged-in';

  /// /field-value-tests
  static const fieldValueTests = '/field-value-tests';

  /// /home/:id/:name/:nonExistingName/number1/
  static String homeIdNameNonExistingNameNumber1({
    required String id,
    String? name,
    String? nonExistingName,
  }) => '/home/$id/$name/$nonExistingName/number1/';

  /// /home/:id/example/:exampleEnum/:age
  static String homeIdExampleExampleEnumAge({
    required String id,
    required String exampleEnum,
    String? age,
  }) => '/home/$id/example/$exampleEnum/$age';
}
