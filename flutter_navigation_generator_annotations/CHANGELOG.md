## 2.0.2 (2024-12-31)

- Added `includeQueryParameters` to `FlutterNavigator` and `FlutterRoute` to include query parameters in the route. Default is [IncludeQueryParametersType.onlyOnWeb] (which differs from before, which was always)
- Added [NavigationType.pushNotNamed] to push the new route without using named. Use this for routes that are not navigationable by the user on web, for example dialogs, bottom sheets, etc. that use custom transitions

## 2.0.1 (2024-07-24)

- Fixed an issue where `guards` require a value, meaning defaultGuards were never used

## 2.0.0 (2024-07-21)

- Added methodName and updated routeName to include web parameters
- Added unknownRoute to handle unknown routes
- Added guards to prevent navigation under certain conditions
- Added defaultGuards to apply to all routes where no guards are specified

## 1.0.1 (2023-11-14)

- Added restorablePush, restorablePopAndPush, restorablePushReplacement and restorablePushAndReplaceAll methods

## 1.0.0 (2023-06-23)

- Removed dependencies on Get and use Flutter navigation
