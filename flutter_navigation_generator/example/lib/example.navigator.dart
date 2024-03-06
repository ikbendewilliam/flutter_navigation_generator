// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FlutterNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:example/main.dart' as _i2;
import 'package:flutter/material.dart' as _i1;
import 'package:flutter/material.dart';

import 'fade_route.dart';
import 'main.dart';

mixin BaseNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final arguments = settings.arguments is Map
        ? (settings.arguments as Map).cast<String, dynamic>()
        : null;
    switch (settings.name) {
      case RouteNames.myHomePage:
        return MaterialPageRoute<void>(
          builder: (_) => MyHomePage(
            key: arguments?['key'] as Key?,
            title: arguments?['title'] as String?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.myHomePagePopAll:
        return MaterialPageRoute<void>(
          builder: (_) => MyHomePage.popAll(
            key: arguments?['key'] as Key?,
            title: arguments?['title'] as String?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.secondPage:
        return FadeInRoute<bool>(
          builder: (_) => SecondPage(
            key: arguments?['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.popAndSecondPage:
        return MaterialPageRoute<void>(
          builder: (_) => SecondPage(
            key: arguments?['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.exampleScreenWithRequiredArgument:
        return MaterialPageRoute<void>(
          builder: (_) => ExampleScreenWithRequiredArgument(
            text: arguments!['text'] as String,
            key: arguments?['key'] as Key?,
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
        RouteNames.myHomePage,
        arguments: {'key': key, 'title': title},
      );
  void goToMyHomePagePopAll({
    _i1.Key? key,
    String? title = 'Poppedallpages',
  }) =>
      navigatorKey.currentState?.pushNamedAndRemoveUntil<dynamic>(
        RouteNames.myHomePagePopAll,
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

  void goToPopAndSecondPage({_i1.Key? key}) =>
      navigatorKey.currentState?.popAndPushNamed<dynamic, dynamic>(
        RouteNames.popAndSecondPage,
        arguments: {'key': key},
      );
  Future<void> goToExampleScreenWithRequiredArgument({
    required String text,
    _i1.Key? key,
  }) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        RouteNames.exampleScreenWithRequiredArgument,
        arguments: {'text': text, 'key': key},
      );
  Future<void> showDialogExampleDialog({
    required String text,
    _i1.Key? key,
  }) async =>
      showCustomDialog<dynamic>(
          widget: _i2.ExampleDialog(
        text: text,
        key: key,
      ));
  Future<void> showSheetRecursiveNavigationBottomSheet({
    int layers = 1,
    _i1.Key? key,
  }) async =>
      showBottomSheet<dynamic>(
          widget: _i2.RecursiveNavigationBottomSheet(
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
