import 'package:flutter_navigation_generator/src/extensions/navigation_type_extension.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:test/test.dart';

void main() {
  test('NavigationTypeExtension', () {
    expect(NavigationType.push.isAsync, true);
    expect(NavigationType.bottomSheet.isAsync, true);
    expect(NavigationType.dialog.isAsync, true);
    expect(NavigationType.popAndPush.isAsync, false);
    expect(NavigationType.pushAndReplaceAll.isAsync, false);
    expect(NavigationType.pushReplacement.isAsync, false);
  });
}
