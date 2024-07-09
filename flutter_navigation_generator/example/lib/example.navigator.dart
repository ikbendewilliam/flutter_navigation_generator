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

import 'custom_model.dart';
import 'fade_route.dart';
import 'main.dart';

mixin BaseNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
        return NativeRouteAnimation<void>(
          builder: (_) => MyHomePage(
            key: arguments['key'] as Key?,
            title: arguments['title'] as String?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.secondPage:
        return FadeInRoute<bool>(
          builder: (_) => SecondPage(
            key: arguments['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.exampleScreenWithRequiredArgument:
        return NativeRouteAnimation<void>(
          builder: (_) => ExampleScreenWithRequiredArgument(
            data: arguments['data'] is String
                ? CustomModel.fromJson(
                    jsonDecode(utf8.decode(base64Decode(arguments['data']))))
                : arguments['data'] as CustomModel,
            key: arguments['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.r404:
        return NativeRouteAnimation<void>(
          builder: (_) => Error404(
            key: arguments['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
    }
    final pathSegments = settingsUri.pathSegments;
    if (pathSegments.length == 5) {
      if (pathSegments[0] == 'home' && pathSegments[4] == '') {
        arguments['id'] = pathSegments[1];
        arguments['name'] = pathSegments[2];
        arguments['nonExistingName'] = pathSegments[3];
        return NativeRouteAnimation<void>(
          builder: (_) => RouteNameWithArguments(
            id: arguments['id'] as String,
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
    if (pathSegments.length == 4) {
      if (pathSegments[0] == 'home' && pathSegments[2] == 'example') {
        arguments['id'] = pathSegments[1];
        arguments['age'] = pathSegments[3];
        return NativeRouteAnimation<void>(
          builder: (_) => RouteNameWithArguments2(
            id: arguments['id'] as String,
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
    if (pathSegments.length == 2) {
      if (pathSegments[0] == 'my-home-page-pop-all') {
        arguments['title'] = pathSegments[1];
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
    String? name,
    int? age,
    _i1.Key? key,
  }) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        Uri(
          path: RouteNames.homeIdNameNonExistingName(
            id: id,
            name: name,
          ),
          queryParameters: {'age': age?.toString()}
            ..removeWhere((_, v) => v == null),
        ).toString(),
        arguments: {'id': id, 'name': name, 'age': age, 'key': key},
      );
  Future<void> goToRouteNameWithArguments2({
    required String id,
    String? name,
    int? age,
    _i1.Key? key,
  }) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        Uri(
          path: RouteNames.homeIdExampleAge(
            id: id,
            age: age?.toString(),
          ),
          queryParameters: {'name': name}..removeWhere((_, v) => v == null),
        ).toString(),
        arguments: {'id': id, 'name': name, 'age': age, 'key': key},
      );
  Future<void> goToExampleScreenWithRequiredArgument({
    required _i2.CustomModel data,
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
      popUntil((route) => route.settings.name == routeName);
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

  /// /my-home-page-pop-all/:title
  static String myHomePagePopAllTitle({String? title}) =>
      '/my-home-page-pop-all/$title';

  /// /home/:id/:name/:nonExistingName/
  static String homeIdNameNonExistingName({
    required String id,
    String? name,
    String? nonExistingName,
  }) =>
      '/home/$id/$name/$nonExistingName/';

  /// /home/:id/example/:age
  static String homeIdExampleAge({
    required String id,
    String? age,
  }) =>
      '/home/$id/example/$age';
}
