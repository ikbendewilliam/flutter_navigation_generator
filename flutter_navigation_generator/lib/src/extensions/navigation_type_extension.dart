import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

extension NavigationTypeExtension on NavigationType? {
  bool get isAsync => switch (this) {
        NavigationType.push || NavigationType.pushNotNamed || NavigationType.restorablePush || NavigationType.bottomSheet || NavigationType.dialog || null => true,
        NavigationType.popAndPush ||
        NavigationType.pushReplacement ||
        NavigationType.pushAndReplaceAll ||
        NavigationType.restorablePopAndPush ||
        NavigationType.restorablePushReplacement ||
        NavigationType.restorablePushAndReplaceAll =>
          false,
      };
}
