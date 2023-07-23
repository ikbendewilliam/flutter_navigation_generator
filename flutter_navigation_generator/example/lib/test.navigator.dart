// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FlutterNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i1;
import 'package:flutter/material.dart';

import 'main.dart';

mixin BaseNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.myHomePage:
        return MaterialPageRoute<bool>(
          builder: (_) => MyHomePage(
            key: (settings.arguments as Map<String, dynamic>?)?['key'] as Key?,
            title:
                (settings.arguments as Map<String, dynamic>)['title'] as String,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
      case RouteNames.secondPage:
        return MaterialPageRoute<void>(
          builder: (_) => SecondPage(
            key: (settings.arguments as Map<String, dynamic>?)?['key'] as Key?,
          ),
          settings: settings,
          fullscreenDialog: false,
        );
    }
    return null;
  }

  Future<bool?> goToMyHomePage({
    _i1.Key? key,
    required String title,
  }) async {
    final dynamic result = await navigatorKey.currentState?.pushNamed<dynamic>(
      RouteNames.myHomePage,
      arguments: {'key': key, 'title': title},
    );
    return (result as bool?);
  }

  Future<void> goToSecondPage({_i1.Key? key}) async =>
      navigatorKey.currentState?.pushNamed<dynamic>(
        RouteNames.secondPage,
        arguments: {'key': key},
      );
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

  static const secondPage = '/second';
}
