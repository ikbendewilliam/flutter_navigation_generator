import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

/// Marks a class as a Flutter route, a pageRoute and method will be generated
class FlutterRoute {
  /// Override the default name of the route
  ///
  /// optionally use `:name` to declare a parameter in the route for web.
  /// Defaults to use query parameters. Name must match queryName of the field
  /// (defaults to the variable name included in the constructor)
  final String? routeName;

  /// Override the method to open the route
  /// defaults to goTo[RouteName]
  final String? methodName;

  /// Set the type returned by the goTo method.
  final Type? returnType;

  /// Set children screens for this route. This allows
  /// you to use subNavigators which navigate within
  /// a parent screen. Note: use the type of the child screen
  /// not an instance.
  /// Also adapts routes automatically
  final List<Type>? children;

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

  /// Guards to use for this route
  ///
  /// Guards are used to prevent navigation, they can be used to check if the user is logged in
  ///
  /// Guards must extend [NavigatorGuard]
  ///
  /// Note: Navigation can be continued by calling `navigator.continueNavigation()`
  /// See the continueNavigation() method in the Navigator for more information
  final List<Type>? guards;

  /// Whether to use query parameters to provide the arguments
  /// If unset, uses the value of [FlutterNavigator.includeQueryParameters]
  final IncludeQueryParametersType? includeQueryParameters;

  const FlutterRoute({
    this.navigationType = NavigationType.push,
    this.routeName,
    this.methodName,
    this.children,
    this.pageType,
    this.returnType,
    this.isFullscreenDialog = false,
    this.generatePageRoute = true,
    this.generateMethod = true,
    this.guards,
    this.includeQueryParameters,
  });
}

/// const instance of [FlutterRoute]
/// with default arguments
const flutterRoute = FlutterRoute();
