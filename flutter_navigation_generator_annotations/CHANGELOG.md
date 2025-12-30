## 2.1.1 (2025-12-30)
- Updated dependencies
- Flutter Lints to v6

## 2.1.0 (2024-12-31)

- Added `@FlutterRouteField` annotation to specify fields with the following options:
    - `ignore`: Defaults to false (except for Key? key field, see `ignoreKeysByDefault`), excludes this field from the goTo method
    - `addToJson`: default true, add this field to the json serialization, only useful for web, use this to add cached values, but prevent the user from overriding them
    - `queryName`: default null, use this to specify the query parameter name, if not specified, the field name is used
- Added `ignoreKeysByDefault` to `@FlutterNavigator` to override default behaviour of ignoring keys

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
