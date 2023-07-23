import 'package:flutter_navigation_generator_annotations/src/flutter_route_annotation.dart';
import 'package:flutter_navigation_generator_annotations/src/navigation_type.dart';

/// Marks a class as a Flutter bottomSheet
/// A method will be generated
/// Similar to [FlutterRoute] with navigationType = NavigationType.bottomSheet
class FlutterBottomSheet extends FlutterRoute {
  const FlutterBottomSheet({
    String? routeName,
    Type? returnType,
  }) : super(
          routeName: routeName,
          returnType: returnType,
          isFullscreenDialog: false,
          navigationType: NavigationType.bottomSheet,
          generatePageRoute: false,
          generateMethod: true,
        );
}

/// const instance of [FlutterBottomSheet]
/// with default arguments
const flutterBottomSheet = FlutterBottomSheet();
