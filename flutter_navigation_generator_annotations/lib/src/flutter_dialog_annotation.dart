import 'package:flutter_navigation_generator_annotations/src/flutter_route_annotation.dart';
import 'package:flutter_navigation_generator_annotations/src/navigation_type.dart';

/// Marks a class as a Flutter dialog
/// A method will be generated
/// Similar to [FlutterRoute] with navigationType = NavigationType.dialog
class FlutterDialog extends FlutterRoute {
  const FlutterDialog({
    String? routeName,
    Type? returnType,
  }) : super(
          routeName: routeName,
          returnType: returnType,
          isFullscreenDialog: true,
          navigationType: NavigationType.dialog,
          generatePageRoute: false,
          generateMethod: true,
        );
}

/// const instance of [FlutterDialog]
/// with default arguments
const flutterDialog = FlutterDialog();
