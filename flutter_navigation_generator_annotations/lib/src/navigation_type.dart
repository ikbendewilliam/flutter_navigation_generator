/// The type of navigation to use
enum NavigationType {
  /// Push the route with the given name onto the navigator,
  /// and then remove all the previous routes.
  ///
  /// Unlike [Route]s pushed via [pushAndReplaceAll],
  /// [Route]s pushed with this method are restored during state
  /// restoration according to the rules outlined in the state restoration
  /// section of [Navigator].
  restorablePushAndReplaceAll('restorablePushNamedAndRemoveUntil'),

  /// Replace the current route of the navigator by pushing the
  /// route named [routeName] and then disposing the previous route
  /// once the new route has finished animating in.
  ///
  /// Unlike [Route]s pushed via [pushReplacement],
  /// [Route]s pushed with this method are restored during state
  /// restoration according to the rules outlined in the state restoration
  /// section of [Navigator].
  restorablePushReplacement('restorablePushReplacementNamed'),

  /// Pop the current route off the navigator that most tightly encloses the
  /// given context and push a named route in its place.
  ///
  /// Unlike [Route]s pushed via [popAndPush],
  /// [Route]s pushed with this method are restored during state
  /// restoration according to the rules outlined in the state restoration
  /// section of [Navigator].
  restorablePopAndPush('restorablePopAndPushNamed'),

  /// Push a named route onto the navigator.
  ///
  /// Unlike [Route]s pushed via [push],
  /// [Route]s pushed with this method are restored during state
  /// restoration according to the rules outlined in the state restoration
  /// section of [Navigator].
  restorablePush('restorablePushNamed'),

  /// Push the given route onto the navigator, and then
  /// remove all the previous routes
  pushAndReplaceAll('pushNamedAndRemoveUntil'),

  /// Replace the current route of the navigator by pushing
  /// the given route and then disposing the previous route
  /// once the new route has finished animating in.
  pushReplacement('pushReplacementNamed'),

  /// Pop the current route off the navigator and
  /// push a named route in its place.
  popAndPush('popAndPushNamed'),

  /// Push the new route
  push('pushNamed'),

  /// Create a dialog
  dialog,

  /// Create a bottom sheet
  bottomSheet;

  final String? navigatorMethod;

  const NavigationType([this.navigatorMethod]);
}
