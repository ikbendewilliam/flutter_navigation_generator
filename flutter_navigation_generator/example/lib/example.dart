import 'package:example/example.navigator.dart';
import 'package:example/main.dart';
import 'package:example/miller_columns/depth_1.dart';
import 'package:example/miller_columns/parent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_animations/flutter_navigation_generator_animations.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@FlutterNavigator(pageType: NativeRouteAnimation, unknownRoute: Error404, defaultGuards: [ExampleDefaultGuard])
class MainNavigator with BaseNavigator {
  final Type? parentScreen;
  final MainNavigator? parentNavigator;
  Map<Type, BaseNavigator> subNavigators = {};

  MainNavigator([this.parentScreen, this.parentNavigator]);

  @override
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final settingsUri = Uri.parse(settings.name ?? '');
    switch (settingsUri.path) {
      case RouteNames.depth1Page1:
        if (subNavigators[ParentPage] != null) {
          subNavigators[ParentPage]!.goToDepth1Page1();
          // if (thisroute != ParentPage)
          // goToParentPage();
          return null;
        }
        final exampleDefaultGuard = guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(arguments: settings.arguments, name: exampleDefaultGuard.alternativeRoute));
        }
        return NativeRouteAnimation<void>(builder: (_) => const Depth1Page1(), settings: settings, fullscreenDialog: false);
      case RouteNames.depth1Page2:
        if (subNavigators[ParentPage] != null) {
          subNavigators[ParentPage]?.goToDepth1Page2();
          // if (thisroute != ParentPage)
          // goToParentPage();
          return null;
        }
        final exampleDefaultGuard = guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(arguments: settings.arguments, name: exampleDefaultGuard.alternativeRoute));
        }
        return NativeRouteAnimation<void>(builder: (_) => const Depth1Page2(), settings: settings, fullscreenDialog: false);
      case RouteNames.depth1Page3:
        if (subNavigators[ParentPage] != null) {
          subNavigators[ParentPage]?.goToDepth1Page3();
          // if (thisroute != ParentPage)
          // goToParentPage();
          return null;
        }
        final exampleDefaultGuard = guards.whereType<ExampleDefaultGuard>().first;
        if (!exampleDefaultGuard.value) {
          guardedRouteSettings = settings;
          return onGenerateRoute(RouteSettings(arguments: settings.arguments, name: exampleDefaultGuard.alternativeRoute));
        }
        return NativeRouteAnimation<void>(builder: (_) => const Depth1Page3(), settings: settings, fullscreenDialog: false);
      default:
        return super.onGenerateRoute(settings);
    }
  }
}
