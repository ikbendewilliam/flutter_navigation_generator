// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// FlutterNavigatorGenerator
// **************************************************************************

import 'package:flutter/material.dart';

import 'main.dart';

mixin BaseNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.myHomePage:
        return MaterialPageRoute<void>(
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
}

class RouteNames {
  static const myHomePage = '/my-home';

  static const secondPage = '/second';
}
