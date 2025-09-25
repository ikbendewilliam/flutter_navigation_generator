import 'package:example/guard_default_example.dart';
import 'package:example/main_navigator.g.dart';
import 'package:flutter_navigation_generator_animations/flutter_navigation_generator_animations.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@FlutterNavigator(
  pageType: NativeRouteAnimation,
  unknownRoute: Error404,
  defaultGuards: [ExampleDefaultGuard],
)
class MainNavigator with BaseNavigator {}
