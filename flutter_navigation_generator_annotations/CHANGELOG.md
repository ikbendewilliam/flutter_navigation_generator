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
