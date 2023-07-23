/// The type of navigation to use
enum NavigationType {
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
