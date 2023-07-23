## 0.1.0 (2023-06-14)

- Updated dependencies and support for Dart 3
- Changed generation from class to mixin as you can't extend a regular class and I don't see how to generate a mixinClass
- Removed returnTypeNullable
- Added default value and copies the current default value if any is specified

## 0.0.12 (2023-03-03)

- Added support to specify `customTransition`, `transition`, `transitionDurationInMilliseconds`, `participatesInRootNavigator`, `title`, `maintainState`, `opaque`, `popGesture` and `showCupertinoParallax` for generated methods

## 0.0.11 (2023-03-02)

- Added `popUntil` and `goBackTo` methods on the generated navigator
- Added support for `navigatorId` on the generated methods to be able to use nested navigators

## 0.0.10 (2023-02-17)

- Added support for multiple annotations on the same class so you can generate multiple methods for a single page (use routeName to specify the name of the method and route)

## 0.0.9 (2023-02-08)

- Added NavigationType.dialog and getXDialog annotation
- Added support for suffixes, this removes `screen`, `page` and `view` from the route name (or any suffix you specify)

## 0.0.8 (2023-01-30)

- Added a `closeDialog` method to the generated navigator
- Changed NavigationType.popAllAndPush to NavigationType.pushAndReplaceAll so it's more in line with the Flutter API
- Changed NavigationType.pushAndReplaceAll and NavigationType.popAndPush to not be Future, unless a returnType is specified. This is to prevent the need to await the method call and keep viewmodels, or similar, in memory.

## 0.0.7 (2023-01-17)

- Added generateMethod and generatePage options
- Added isFullscreenDialog option

## 0.0.6 (2023-01-10)

- Added support for different pageType

## 0.0.5 (2023-01-09)

- Lowered the minimum required Dart SDK version to 2.18.0
- Lowered the minimum required analyzer version to 5.0.0 to prevent issue https://github.com/dart-lang/mockito/issues/579

## 0.0.4 (2023-01-08)

- Improved typing internally
- Added T type for GetPage

## 0.0.3 (2023-01-08)

- Changed generated file to .get_x_navigator.dart

## 0.0.2 (2023-01-08)

- Added support for middlewares

## 0.0.1 (2023-01-07)

- Initial release
