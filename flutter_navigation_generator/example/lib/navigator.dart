import 'package:example/main.dart';
import 'package:flutter/material.dart';

class MainNavigator with BaseNavigator {}

mixin BaseNavigator {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final strippedPath = settings.name?.replaceFirst('/', '');
    return switch (strippedPath) {
      '/' => MaterialPageRoute(
          builder: (_) => const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      '/second' => MaterialPageRoute(
          builder: (_) => const SecondPage(),
        ),
      _ => null,
    };
  }

  Future<void> goToSecondPage() async => navigatorKey.currentState?.pushNamed('/second');

  void goBack() => navigatorKey.currentState?.pop();

  void popUntil(String name) => navigatorKey.currentState?.popUntil(
        (route) => route.settings.name == name,
      );

  void showCustomDialog(Widget widget) async => showDialog(
        context: navigatorKey.currentContext!,
        builder: (_) => widget,
      );

  void acshowBottomSheet(Widget widget) async => showModalBottomSheet(
        context: navigatorKey.currentContext!,
        builder: (_) => widget,
      );
}
