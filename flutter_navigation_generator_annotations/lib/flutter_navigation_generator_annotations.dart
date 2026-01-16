export 'src/flutter_bottom_sheet_annotation.dart';
export 'src/flutter_dialog_annotation.dart';
export 'src/flutter_navigator_annotation.dart';
export 'src/flutter_route_annotation.dart';
export 'src/flutter_route_field.dart';
export 'src/flutter_route_constructor.dart';
export 'src/include_query_parameters_type.dart';
export 'src/navigation_type.dart';

/// Base class for all navigator guards
///
/// A navigator guard is a class that can be used to prevent navigation
abstract class NavigatorGuard {
  /// The alternative route to use if the guard is not passed
  /// or null to use the default/next route
  final String? alternativeRoute;

  /// The value of the guard
  /// True means the guard is passed, false means the guard
  bool value = true;

  NavigatorGuard([this.alternativeRoute]);

  /// Intended to be called by the generated navigator
  Future<void> updateValue() async => value = await getValue();

  /// Override this method to return the value of the guard
  /// True means the guard is passed, false means the guard
  /// is not passed and the alternative route should be used
  Future<bool> getValue();
}
