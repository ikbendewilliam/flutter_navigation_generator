# FlutterNavigationGenerator

[FlutterNavigationGenerator](https://pub.dev/packages/flutter_navigation_generator) is a builder to generate a navigator for your pages with a simple annotation.

## Features

Generates a navigator class with:

- All routes (@flutterRoute, @flutterDialog or @flutterBottomSheet)
- Type safe navigation methods
- Navigate by GlobalKey so you can create mutliple navigators for nested navigation and don't require a context
- Flutter Navigation (no third party dependencies)
- Web support with automatic encoding and decoding of route arguments

## Getting Started

First add the dependencies:

```yaml
dependencies:
  flutter_navigation_generator_annotations: current_version
  flutter_navigation_generator_animations: current_version # Optional, for route animations

dev_dependencies:
  flutter_navigation_generator: current_version
```

Create a navigator file and annotate the class in it with `@flutterNavigator`:

```dart
@flutterNavigator
class MainNavigator with BaseNavigator {}
```

Then annotate your pages with `@flutterRoute`:

```dart
@flutterRoute
class FirstPage extends StatefulWidget {
  const FirstPage({super.key});
  ...
```

Run build runner and you can start using the navigator:

```dart
// In your Dependency Injection:
final myNavigator = MainNavigator();

...

MaterialApp(
  navigatorKey: myNavigator.navigatorKey,
  onGenerateRoute: myNavigator.onGenerateRoute,
  initialRoute: RouteNames.myHomePage,
),

...

myNavigator.goToSecondPage();

```

## Customization

### FlutterNavigator

- `navigatorClassName`: The name of the navigator class. Default: `BaseNavigator`
- `pageType`: The type of the generated pages, must extend [PageRoute]. Default: `MaterialPageRoute`, use `NativeRouteAnimation` from `flutter_navigation_generator_animations` to have a native feel across Android, iOS and Web
- `removeSuffixes`: A list of suffixes to remove from the route name. Default: `['Page', 'Screen', 'View', 'Widget']` (Note: the suffixes are removed from the end of the name, so `FirstPage` becomes `First`)
- `unknownRoute`: The screen to use when a route is not found, similar to/use this for a 404 page on web
- `defaultGuards`: Adds these guards to all routes where no guards are specified. Useful for adding e.g. login guards without having to add them to every route. Guards must extend [NavigatorGuard]. Note: Navigation can be continued by calling `navigator.continueNavigation()`. See the continueNavigation() method in the Navigator for more information

### FlutterRoute

- `routeName`: The name of the route. Optionally use `:name` to declare a parameter in the route for web. Defaults to use query parameters. Name must match the variable name included in the constructor (for example: `/events/:eventId/sponsors`). Default: `[className]` (converted to kebab-case, as [recommended by Google for urls](<https://developers.google.com/search/docs/crawling-indexing/url-structure#:~:text=Consider%20using%20hyphens%20to%20separate,(%20_%20)%20in%20your%20URLs.>))
- `methodName`: The name of the method. Default: `goTo[ClassName]`
- `returnType`: The return type of the route. Default: `void`
- `navigationType`: The type of navigation. Default: `NavigationType.push`, valid options are: `pushAndReplaceAll`, `pushReplacement`, `popAndPush`, `push` and `dialog` to specify a dialog and `bottomSheet` to specify a bottom sheet
- `generateMethod`: If a method should be generated for the route. Default: `true` (More info in separate method/page section below)
- `generatePage`: If a page should be generated for the route. Default: `true` (More info in separate method/page section below)
- `isFullscreenDialog`: If the route should be launched fullscreen. Default: `false` (` true`` for  `dialog`and`bottomSheet` navigation types)
- `pageType`: The type of the generated pages, must extend [PageRoute]. Default: `MaterialPageRoute`
- `guards`: A list of guards to use for this route. Guards are used to prevent navigation, they can be used to check if the user is logged in. Guards must extend [NavigatorGuard]. Note: Navigation can be continued by calling `navigator.continueNavigation()`. See the continueNavigation() method in the Navigator for more information

- `@flutterRouteConstructor`: The constructor to use for the route. Defaults to unnamed constructor. This can be any constructor or static method
- `@FlutterRouteConstructor(routeName)`: routeName specifies for which FlutterRoute this constructor is used

```dart
@FlutterRoute(
  routeName: 'custom-name',
  returnType: bool,
  navigationType: NavigationType.popAndPush,
)
class FirstPage extends StatelessWidget {
    final int someValue;
    final int someOtherValue;

    const FirstPage({required this.someValue, this.someOtherValue = 1, super.key});

    @flutterRouteConstructor
    static FirstPage doubleValue(int someValue, {Key? key, int someOtherValue = 2}) => FirstPage(someValue: someValue * 2, key: key, someOtherValue: someOtherValue);
```

## Separate method/page

For some projects, you may have multiple projects/packages/navigators and it can happen that you want to generate a method in a different navigator than the page.

An example would be a goToHelpScreen in a shared package and an implementation in different apps. In this case, you can use the `generateMethod` and `generatePage` options to generate only the method or only the page.

**Note** that the `routeName` must be the same for both the method and the page.

If you want to generate different arguments for the page than the base Widget has, you can use the `@flutterRouteConstructor` annotation to specify a named constructor to use for the method arguments.

```dart
// In your shared package:
@FlutterRoute(
  generatePageRoute: false,
  routeName: '/help',
)
class BaseHelp extends StatelessWidget {
  final String appTitle;

  const BaseHelp({required this.appTitle, super.key});

  @getXRouteConstructor
  static BaseHelp.implementationConstructor()

...

// In your implementation:
@FlutterRoute(
  generateMethod: false,
  routeName: '/help',
)
class Help extends StatelessWidget {
  const Help();

  Widget build(BuildContext context) {
    return BaseHelp(appTitle: 'My app');
  }
```

## Nested navigators

To use nested Navigators, simply create a new instance of the navigator. This will create a new GlobalKey for the navigator. Use this key in a Navigator widget and you can navigate to the pages in the nested navigator.

```dart
// In your Dependency Injection:
final myNestedNavigator = MainNavigator();

...

Navigator(
  key: myNestedNavigator.navigatorKey,
  onGenerateRoute: myNestedNavigator.onGenerateRoute,
  initialRoute: RouteNames.myHomePage,
),

...

myNestedNavigator.goToPageWithinNestedNavigation();
```

## Deep linking to any page
Out of the box the navigator generates and supports url-only navigation. Meaning you can navigate to any page by providing the url. This is useful for deep linking and sharing links to specific pages. Simply use the `navigator.navigatorKey.currentState?.pushNamed(url)` method to navigate to any page in your app.

If you want to improve UX it is recommended to set the parameters inside the routeName. This way the url will be more user friendly and easier to share. For example: `/events/:eventId/sponsors` instead of `/events/sponsors?eventId=123`.

Be aware that some screens you might not want to have navigation for (e.g. debug screens). In this case I suggest you use a guard to prevent navigation to these pages in production or add checks in the deeplinking method before calling `pushNamed`.
