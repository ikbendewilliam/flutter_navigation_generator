/// Marks a class as a navigator and create
/// a base navigator mixin for it
class FlutterNavigator {
  /// The name of the navigator mixin to generate
  /// If not provided 'BaseNavigator' will be used
  final String? navigatorClassName;

  /// Override the default page type [MaterialPageRoute] to
  /// use a custom page type so you can customize the
  /// transition. Must extend [PageRoute]
  final Type? pageType;

  /// Remove the suffixes from the class name in
  /// the routename. Does not effect custom route names
  final List<String> removeSuffixes;

  const FlutterNavigator({
    this.navigatorClassName,
    this.pageType,
    this.removeSuffixes = const ['Page', 'Screen', 'View', 'Widget'],
  });
}

/// const instance of [FlutterNavigator]
/// with default arguments
const flutterNavigator = FlutterNavigator();
