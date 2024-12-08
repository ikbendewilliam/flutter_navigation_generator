## 2.1.0 (2024-12-06)

- Added `@FlutterRouteField` annotation to specify fields with the following options:
    - `ignore`: Defaults to false (except for Key? key field, see `ignoreKeysByDefault`), excludes this field from the goTo method
    - `addToJson`: default true, add this field to the json serialization, only useful for web, use this to add cached values, but prevent the user from overriding them
    - `queryName`: default null, use this to specify the query parameter name, if not specified, the field name is used
- Added `ignoreKeysByDefault` to `@FlutterNavigator` to override default behaviour of ignoring keys

## 2.0.0 (2024-07-21)

- Added methodName and updated routeName to include web parameters
- Added unknownRoute to handle unknown routes
- Added guards to prevent navigation under certain conditions
- Added defaultGuards to apply to all routes where no guards are specified

## 1.0.1 (2023-11-14)

- Added restorablePush, restorablePopAndPush, restorablePushReplacement and restorablePushAndReplaceAll methods

## 1.0.0 (2023-06-23)

- Removed dependencies on Get and use Flutter navigation
