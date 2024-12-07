## 2.1.0 (2024-12-06)

- Added `@FlutterRouteField` annotation to specify fields with the following options:
    - `ignore`: Defaults to false (except for Key? key field), excludes this field from the goTo method
    - `addToJson`: default true, add this field to the json serialization, only useful for web, use this to add cached values, but prevent the user from overriding them
    - `queryName`: default null, use this to specify the query parameter name, if not specified, the field name is used

## 2.0.3 (2024-10-21)

- Fixed a nullability issue

## 2.0.2 (2024-07-24)

- Added support for enum arguments

## 2.0.1 (2024-07-24)

- Fixed an issue when you don't use `guards`, the import is not added, but the methods are causing an error

## 2.0.0 (2024-07-21)

- Added support for web parameters as query parameters and url path parameters
- Added support for methodName
- Added a package (flutter_navigation_generator_animations) with NativeRouteAnimation to animate between pages in a native way (Android scales, iOS uses CupertinoPageTransition, web doesn't animate, other platforms use FadeTransition)
- Added unknownRoute to handle unknown routes
- Added guards to prevent navigation under certain conditions
- Added defaultGuards to apply to all routes where no guards are specified

## 1.0.4+1 (2024-03-06)

- Fixed issue with settings.arguments error in restoration

## 1.0.3 (2023-12-04)

- Fixed issue with FlutterNavigator PageType overriding FlutterRoute PageType

## 1.0.2 (2023-11-14)

- Added restorablePush, restorablePopAndPush, restorablePushReplacement and restorablePushAndReplaceAll methods

## 1.0.1 (2023-10-30)

- Fixed issue with popAndPush

## 1.0.0 (2023-06-23)

- Removed dependencies on Get and use Flutter navigation