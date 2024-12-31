// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FlutterNavigatorGenerator
// **************************************************************************

// ignore_for_file: prefer_const_constructors

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:convert';

import 'package:example/custom_model.dart' as _i2;
import 'package:example/main.dart' as _i3;
import 'package:flutter/material.dart' as _i1;
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_animations/flutter_navigation_generator_animations.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

import 'custom_model.dart';
import 'fade_route.dart';
import 'main.dart';

mixin BaseNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  final Set<NavigatorGuard> guards = <NavigatorGuard>{
    ExampleDefaultGuard(),
    LoginGuard()
  };

  RouteSettings? guardedRouteSettings;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments is Map
        ? (settings.arguments as Map).cast<String, dynamic>()
        : <String, dynamic>{};
    final settingsUri = Uri.parse(settings.name ?? '');
    settingsUri.queryParameters.forEach((key, value) {
      arguments[key] ??= value;
    });
    switch (settingsUri.path) {
      case RouteNames.myHomePage:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(
            arguments: settings.arguments,
            name: exampleDefaultGuard.alternativeRoute,
          ));
        }
        return NativeRouteAnimation<void>(
          builder: (_) => MyHomePage(
            key: arguments['key'] as Key?,
            title: arguments['title'] as String?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.secondPage:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(
            arguments: settings.arguments,
            name: exampleDefaultGuard.alternativeRoute,
          ));
        }
        return FadeInRoute<bool>(
          builder: (_) => SecondPage(
            key: arguments['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.exampleScreenWithRequiredArgument:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(
            arguments: settings.arguments,
            name: exampleDefaultGuard.alternativeRoute,
          ));
        }
        return NativeRouteAnimation<void>(
          builder: (_) => ExampleScreenWithRequiredArgument(
            data: arguments['data'] is String
                ? (jsonDecode(utf8.decode(base64Decode(arguments['data'])))
                        as List<dynamic>)
                    .map((e) => CustomModel.fromJson(e as Map<String, dynamic>))
                    .toList()
                : arguments['data'] as List<CustomModel>,
            key: arguments['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.r404:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(
            arguments: settings.arguments,
            name: exampleDefaultGuard.alternativeRoute,
          ));
        }
        return NativeRouteAnimation<void>(
          builder: (_) => Error404(
            key: arguments['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.errorNotLoggedIn:
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(
            arguments: settings.arguments,
            name: exampleDefaultGuard.alternativeRoute,
          ));
        }
        return NativeRouteAnimation<void>(
          builder: (_) => ErrorNotLoggedIn(
            key: arguments['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.loggedInPage:
        final loginGuard = guards.whereType<LoginGuard>().first;
        if (!loginGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(
            arguments: settings.arguments,
            name: loginGuard.alternativeRoute,
          ));
        }
        return NativeRouteAnimation<void>(
          builder: (_) => LoggedInPage(
            key: arguments['key'] as Key?,
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
        arguments['id'] = pathSegments[1];
        arguments['name'] = pathSegments[2];
        arguments['nonExistingName'] = pathSegments[3];
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(
            arguments: settings.arguments,
            name: exampleDefaultGuard.alternativeRoute,
          ));
        }
        return NativeRouteAnimation<void>(
          builder: (_) => RouteNameWithArguments(
            id: arguments['id'] as String,
            model: arguments['model'] is String
                ? CustomModel.fromJson(
                    jsonDecode(utf8.decode(base64Decode(arguments['model']))))
                : arguments['model'] as CustomModel?,
            name: arguments['name'] as String?,
            age: arguments['age'] is String
                ? int.parse(arguments['age'])
                : arguments['age'] as int?,
            key: arguments['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      }
    }
    if (pathSegments.length == 5) {
      if (pathSegments[0] == 'home' && pathSegments[2] == 'example') {
        arguments['id'] = pathSegments[1];
        arguments['exampleEnum'] = pathSegments[3];
        arguments['age'] = pathSegments[4];
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(
            arguments: settings.arguments,
            name: exampleDefaultGuard.alternativeRoute,
          ));
        }
        return NativeRouteAnimation<void>(
          builder: (_) => RouteNameWithArguments2(
            id: arguments['id'] as String,
            exampleEnum: arguments['exampleEnum'] is String
                ? ExampleEnum.values[int.parse(arguments['exampleEnum'])]
                : arguments['exampleEnum'] as ExampleEnum,
            exampleEnum2: arguments['exampleEnum2'] is String
                ? ExampleEnum.values[int.parse(arguments['exampleEnum2'])]
                : arguments['exampleEnum2'] as ExampleEnum,
            name: arguments['name'] as String?,
            age: arguments['age'] is String
                ? int.parse(arguments['age'])
                : arguments['age'] as int?,
            exampleEnum3: arguments['exampleEnum3'] is String
                ? ExampleEnum.values[int.parse(arguments['exampleEnum3'])]
                : arguments['exampleEnum3'] as ExampleEnum?,
            exampleEnums4: arguments['exampleEnums4'] is String
                ? (jsonDecode(utf8
                            .decode(base64Decode(arguments['exampleEnums4'])))
                        as List<dynamic>)
                    .map((e) => ExampleEnum.values[e])
                    .toList()
                : arguments['exampleEnums4'] as List<ExampleEnum>?,
            exampleEnumsMap5: arguments['exampleEnumsMap5'] is String
                ? Map<String, ExampleEnum>.from(jsonDecode(utf8
                        .decode(base64Decode(arguments['exampleEnumsMap5'])))
                    .map((k, v) => MapEntry(k, ExampleEnum.values[v])))
                : arguments['exampleEnumsMap5'] as Map<String, ExampleEnum>?,
            key: arguments['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      }
    }
    if (pathSegments.length == 2) {
      if (pathSegments[0] == 'my-home-page-pop-all') {
        arguments['title'] = pathSegments[1];
        final exampleDefaultGuard =
            guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(
            arguments: settings.arguments,
            name: exampleDefaultGuard.alternativeRoute,
          ));
        }
        return NativeRouteAnimation<void>(
          builder: (_) => MyHomePage(
            key: arguments['key'] as Key?,
            title: arguments['title'] as String?,
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
        arguments: settings.arguments);
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
  Future<void> goToMyHomePage({
    _i1.Key? key,
    String? title,
  }) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        Uri(
          path: RouteNames.myHomePage,
          queryParameters: {'title': title}..removeWhere((_, v) => v == null),
        ).toString(),
        arguments: {'key': key, 'title': title},
      );
  void goToHomePageWithPathParameter({
    _i1.Key? key,
    String? title,
  }) =>
      navigatorKey.currentState?.pushNamedAndRemoveUntil<dynamic>(
        RouteNames.myHomePagePopAllTitle(title: title),
        (_) => false,
        arguments: {'key': key, 'title': title},
      );
  Future<bool?> goToSecondPage({_i1.Key? key}) async {
    final dynamic result = await navigatorKey.currentState?.pushNamed<dynamic>(
      RouteNames.secondPage,
      arguments: {'key': key},
    );
    return (result as bool?);
  }

  Future<bool?> popAndGoToSecondPage({_i1.Key? key}) async {
    final dynamic result =
        await navigatorKey.currentState?.popAndPushNamed<dynamic, dynamic>(
      RouteNames.secondPage,
      arguments: {'key': key},
    );
    return (result as bool?);
  }

  Future<void> customName({
    required String id,
    _i2.CustomModel? model,
    String? name,
    int? age,
    _i1.Key? key,
  }) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        Uri(
          path: RouteNames.homeIdNameNonExistingNameNumber1(
            id: id,
            name: name,
          ),
          queryParameters: {
            'model': model == null
                ? null
                : base64Encode(utf8.encode(jsonEncode(model))),
            'age': age?.toString()
          }..removeWhere((_, v) => v == null),
        ).toString(),
        arguments: {
          'id': id,
          'model': model,
          'name': name,
          'age': age,
          'key': key
        },
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
    _i1.Key? key,
  }) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        Uri(
          path: RouteNames.homeIdExampleExampleEnumAge(
            id: id,
            exampleEnum: exampleEnum.index.toString(),
            age: age?.toString(),
          ),
          queryParameters: {
            'exampleEnum2': exampleEnum2.index.toString(),
            'name': name,
            'exampleEnum3': exampleEnum3?.index.toString(),
            'exampleEnums4': base64Encode(utf8.encode(
                jsonEncode(exampleEnums4?.map((e) => e.index).toList()))),
            'exampleEnumsMap5': base64Encode(utf8.encode(jsonEncode(
                exampleEnumsMap5?.map((k, v) => MapEntry(k, v.index)))))
          }..removeWhere((_, v) => v == null),
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
          'key': key
        },
      );
  Future<void> goToExampleScreenWithRequiredArgument({
    required List<_i2.CustomModel> data,
    _i1.Key? key,
  }) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        Uri(
          path: RouteNames.exampleScreenWithRequiredArgument,
          queryParameters: {
            'data': base64Encode(utf8.encode(jsonEncode(data)))
          },
        ).toString(),
        arguments: {'data': data, 'key': key},
      );
  Future<void> goToLoggedInPage({_i1.Key? key}) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        RouteNames.loggedInPage,
        arguments: {'key': key},
      );
  Future<void> showDialogExampleDialog({
    required String text,
    _i1.Key? key,
  }) async =>
      showCustomDialog<dynamic>(
          widget: _i3.ExampleDialog(
        text: text,
        key: key,
      ));
  Future<void> showSheetRecursiveNavigationBottomSheet({
    int layers = 1,
    _i1.Key? key,
  }) async =>
      showBottomSheet<dynamic>(
          widget: _i3.RecursiveNavigationBottomSheet(
        layers: layers,
        key: key,
      ));
  void goBack() => navigatorKey.currentState?.pop();
  void goBackWithResult<T>({T? result}) =>
      navigatorKey.currentState?.pop(result);
  void popUntil(bool Function(Route<dynamic>) predicate) =>
      navigatorKey.currentState?.popUntil(predicate);
  void goBackTo(String routeName) =>
      popUntil((route) => route.settings.name?.split('?').first == routeName);
  Future<T?> showCustomDialog<T>({Widget? widget}) async => showDialog<T>(
        context: navigatorKey.currentContext!,
        builder: (_) => widget ?? const SizedBox.shrink(),
      );
  Future<T?> showBottomSheet<T>({Widget? widget}) async =>
      showModalBottomSheet<T>(
        context: navigatorKey.currentContext!,
        builder: (_) => widget ?? const SizedBox.shrink(),
      );
}

class RouteNames {
  /// /
  static const myHomePage = '/';

  /// /second
  static const secondPage = '/second';

  /// /example-screen-with-required-argument
  static const exampleScreenWithRequiredArgument =
      '/example-screen-with-required-argument';

  /// /404
  static const r404 = '/404';

  /// /error-not-logged-in
  static const errorNotLoggedIn = '/error-not-logged-in';

  /// /logged-in
  static const loggedInPage = '/logged-in';

  /// /my-home-page-pop-all/:title
  static String myHomePagePopAllTitle({String? title}) =>
      '/my-home-page-pop-all/$title';

  /// /home/:id/:name/:nonExistingName/number1/
  static String homeIdNameNonExistingNameNumber1({
    required String id,
    String? name,
    String? nonExistingName,
  }) =>
      '/home/$id/$name/$nonExistingName/number1/';

  /// /home/:id/example/:exampleEnum/:age
  static String homeIdExampleExampleEnumAge({
    required String id,
    required String exampleEnum,
    String? age,
  }) =>
      '/home/$id/example/$exampleEnum/$age';
}
