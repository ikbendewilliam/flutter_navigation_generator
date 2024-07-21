/// Marks a class as a navigator and create
/// a base navigator mixin for it
class FlutterNavigator {
  /// The name of the navigator mixin to generate
  /// If not provided 'BaseNavigator' will be used
  final String? navigatorClassName;

  /// Override the default page type [MaterialPageRoute] to
  /// use a custom page type so you can customize the
  /// transition. Must extend [PageRoute]
  ///
  /// Add `flutter_navigation_generator_animations`
  /// to use [NativeRouteAnimation]
  final Type? pageType;

  /// Set a screen to be used when no route is found
  final Type? unknownRoute;

  /// Adds these guards to all routes where no guards
  /// are specified. Useful for adding e.g. login guards
  /// without having to add them to every route
  ///
  /// Guards must extend [NavigatorGuard]
  ///
  /// Note: Navigation can be continued by calling `navigator.continueNavigation()`
  /// See the continueNavigation() method in the Navigator for more information
  final List<Type> defaultGuards;

  /// Remove the suffixes from the class name in
  /// the routename. Does not effect custom route names
  final List<String> removeSuffixes;

  const FlutterNavigator({
    this.navigatorClassName,
    this.pageType,
    this.unknownRoute,
    this.defaultGuards = const [],
    this.removeSuffixes = const ['Page', 'Screen', 'View', 'Widget'],
  });
}

/// const instance of [FlutterNavigator]
/// with default arguments
const flutterNavigator = FlutterNavigator();
