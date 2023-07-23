/// The constructor or static method to use to create a page route
/// The arguments will be used to generate the goTo method
///
/// Set the routeName to specify for which method this constructor should be used
class FlutterRouteConstructor {
  /// Set for which routeName this constructor should be used
  /// If not set, the constructor will be used for all routes
  /// that don't have a constructor with a routeName set
  final String? routeName;

  const FlutterRouteConstructor({
    this.routeName,
  });
}

/// const instance of [FlutterRouteConstructor]
const flutterRouteConstructor = FlutterRouteConstructor();
