import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

/// Marks a class as a Flutter route, a pageRoute and method will be generated
class FlutterRoute {
  /// Override the default name of the route
  final String? routeName;

  /// Set the type returned by the goTo method.
  final Type? returnType;

  /// Override the default page type [MaterialPageRoute] or
  /// the Navigator [pageType] to use a custom page type so
  /// you can customize the transition. Must extend [PageRoute]
  /// and must contain builder(context), isFullscreenDialog
  /// and settings arguments
  final Type? pageType;

  /// The type of navigation to use
  final NavigationType navigationType;

  /// Open the route in fullscreen mode
  final bool isFullscreenDialog;

  /// Enable/Disable the generation of the pageRoute, use this if you separate the
  /// declaration of the pageRoute and the method. This is useful if you have
  /// a shared package that declares the method and a project that declares
  /// the pageRoute.
  ///
  /// **Note** that the routeName has to match with the generated method routeName
  ///
  /// if the pageRoute has different arguments than the method, you can create a
  /// named constructor and add the [@flutterRouteConstructor] annotation to the BaseWidget
  final bool generatePageRoute;

  /// Enable/Disable the generation of the method, use this if you separate the
  /// declaration of the pageRoute and the method. This is useful if you have
  /// a shared package that declares the method and a project that declares
  /// the pageRoute.
  ///
  /// **Note** that the routeName has to match with the generated pageRoute routeName
  ///
  /// if the pageRoute has different arguments than the method, you can create a
  /// named constructor and add the [@flutterRouteConstructor] annotation to the BaseWidget
  final bool generateMethod;

  const FlutterRoute({
    this.navigationType = NavigationType.push,
    this.routeName,
    this.pageType,
    this.returnType,
    this.isFullscreenDialog = false,
    this.generatePageRoute = true,
    this.generateMethod = true,
  });
}

/// const instance of [FlutterRoute]
/// with default arguments
const flutterRoute = FlutterRoute();
