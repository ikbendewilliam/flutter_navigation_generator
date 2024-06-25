// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FlutterNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:convert';

import 'package:example/custom_model.dart' as _i2;
import 'package:example/main.dart' as _i3;
import 'package:flutter/material.dart' as _i1;
import 'package:flutter/material.dart';

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
        return MaterialPageRoute<void>(
          builder: (_) => MyHomePage(
            key: arguments['key'] as Key?,
            title: arguments['title'] as String?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.myHomePagePopAll:
        return MaterialPageRoute<void>(
          builder: (_) => MyHomePage.popAll(
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
      case RouteNames.popAndSecondPage:
        return MaterialPageRoute<void>(
          builder: (_) => SecondPage(
            key: arguments['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.exampleScreenWithRequiredArgument:
        return MaterialPageRoute<void>(
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
    }
    return null;
  }

  Future<void> goToMyHomePage({
    _i1.Key? key,
    String? title,
  }) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        Uri(
          path: RouteNames.myHomePage,
          queryParameters: {'title': title.toString()},
        ).toString(),
        arguments: {'key': key, 'title': title},
      );
  void goToMyHomePagePopAll({
    _i1.Key? key,
    String? title = 'Poppedallpages',
  }) =>
      navigatorKey.currentState?.pushNamedAndRemoveUntil<dynamic>(
        Uri(
          path: RouteNames.myHomePagePopAll,
          queryParameters: {'title': title.toString()},
        ).toString(),
        (_) => false,
        arguments: {'key': key, 'title': title},
      );
  Future<bool?> goToSecondPage({_i1.Key? key}) async {
    final dynamic result = await navigatorKey.currentState?.pushNamed<dynamic>(
      Uri(
        path: RouteNames.secondPage,
        queryParameters: {},
      ).toString(),
      arguments: {'key': key},
    );
    return (result as bool?);
  }

  void goToPopAndSecondPage({_i1.Key? key}) =>
      navigatorKey.currentState?.popAndPushNamed<dynamic, dynamic>(
        Uri(
          path: RouteNames.popAndSecondPage,
          queryParameters: {},
        ).toString(),
        arguments: {'key': key},
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
  static const myHomePage = '/my-home';

  static const myHomePagePopAll = '/MyHomePagePopAll';

  static const secondPage = '/second';

  static const popAndSecondPage = '/PopAndSecond';

  static const exampleScreenWithRequiredArgument =
      '/example-screen-with-required-argument';
}
