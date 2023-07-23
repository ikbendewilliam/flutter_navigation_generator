# FlutterNavigationGenerator

[FlutterNavigationGenerator](https://pub.dev/packages/flutter_navigation_generator) is a builder to generate a navigator for your pages with a simple annotation.

## Features

Generates a navigator class with:

- All routes (@flutterRoute, @flutterDialog or @flutterBottomSheet)
- Type safe navigation methods
- Navigate by GlobalKey so you can create mutliple navigators for nested navigation and don't require a context
- Flutter Navigation (no third party dependencies)

## Getting Started

First add the dependencies:

```yaml
dependencies:
  flutter_navigation_generator_annotations: current_version

dev_dependencies:
  flutter_navigation_generator: current_version
```

Create a navigator file and annotate it with `@flutterNavigator`:

```dart
@flutterNavigator
class MainNavigator extends BaseNavigator {}
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
  key: myNavigator.navigatorKey,
  onGenerateRoute: myNavigator.onGenerateRoute,
  initialRoute: RouteNames.myHomePage,
),

...

myNavigator.goToSecondPage();

```

## Customization

### FlutterNavigator

- `name`: The name of the navigator class. Default: `BaseNavigator`
- `pageType`: The type of the generated pages, must extend [PageRoute]. Default: `MaterialPageRoute`
- `removeSuffixes`: A list of suffixes to remove from the route name. Default: `['Page', 'Screen', 'View', 'Widget']` (Note: the suffixes are removed from the end of the name, so `FirstPage` becomes `First`)

### FlutterRoute

- `routeName`: The name of the route. Default: `[className]` (converted to kebab-case, as [recommended by Google for urls](<https://developers.google.com/search/docs/crawling-indexing/url-structure#:~:text=Consider%20using%20hyphens%20to%20separate,(%20_%20)%20in%20your%20URLs.>))
- `returnType`: The return type of the route. Default: `void`
- `navigationType`: The type of navigation. Default: `NavigationType.push`, valid options are: `pushAndReplaceAll`, `pushReplacement`, `popAndPush`, `push` and `dialog` to specify a dialog and `bottomSheet` to specify a bottom sheet
- `generateMethod`: If a method should be generated for the route. Default: `true` (More info in separate method/page section below)
- `generatePage`: If a page should be generated for the route. Default: `true` (More info in separate method/page section below)
- `isFullscreenDialog`: If the route should be launched fullscreen. Default: `false` (`true`` for `dialog` and `bottomSheet` navigation types)
- `pageType`: The type of the generated pages, must extend [PageRoute]. Default: `MaterialPageRoute`

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
