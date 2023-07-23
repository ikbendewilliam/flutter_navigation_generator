# FlutterNavigationGenerator

[FlutterNavigationGenerator](https://pub.dev/packages/flutter_navigation_generator) is a builder to generate a navigator for your pages with a simple annotation.

## Features

Generates a navigator class with:
- All routes (@route, @dialog or @bottomSheet)
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

Create a navigator file and annotate it with `@navigator`:

```dart
@navigator
class MainNavigator extends BaseNavigator {}
```

Then annotate your pages with `@route`:

```dart
@route
class FirstPage extends StatefulWidget {
  const FirstPage({super.key});
  ...
```

Run build runner and you get the following result:

```dart
TODO
```

## Customization

### FlutterNavigator

- `name`: The name of the navigator class. Default: `BaseNavigator`
- `pageType`: The type of the generated pages, must extend [PageRoute]. Default: `MaterialPageRoute`
- `removeSuffixes`: A list of suffixes to remove from the route name. Default: `['Page', 'Screen', 'View', 'Widget']` (Note: the suffixes are removed from the end of the name, so `FirstPage` becomes `First`)

### FlutterRoute

- `routeName`: The name of the route. Default: `[className]` (converted to kebab-case, as [recommended by Google for urls](<https://developers.google.com/search/docs/crawling-indexing/url-structure#:~:text=Consider%20using%20hyphens%20to%20separate,(%20_%20)%20in%20your%20URLs.>))
- `returnType`: The return type of the route. Default: `void` (Note: `?` is not valid, use `returnTypeNullable` instead)
- `returnTypeNullable`: If the return type is nullable. Default: `false`
- `navigationType`: The type of navigation. Default: `NavigationType.push`, valid options are: `pushAndReplaceAll`, `popAndPush` and `push` and `dialog` to specify a dialog
- `middlewares`: A list of middleware types to use for the route. Default: `[]`. **Note:** an annotation needs to be constant and middlewares are not, so you need to pass the type of the middleware
- `generateMethod`: If a method should be generated for the route. Default: `true` (More info in separate method/page section below)
- `generatePage`: If a page should be generated for the route. Default: `true` (More info in separate method/page section below)
- `isFullscreenDialog`: If the route should be launched fullscreen. Default: `false`
- `customTransition`:  A custom transition to use for this route, needs to extend [CustomTransition]
- `transition`:  The transition to use for this route.
- `transitionDurationInMilliseconds`:  The duration of the transition to use for this route
- `participatesInRootNavigator`:  Whether this route participates in the root navigator
- `title`:  The title to use for this route
- `maintainState`:  Whether to maintain the state of this route
- `opaque`:  Whether this route is opaque
- `popGesture`:  Whether to enable the pop gesture for this route
- `showCupertinoParallax`: Whether to show the parallax effect on iOS

- `@getXRouteConstructor`: The constructor to use for the route. Defaults to unnamed constructor. This can be any constructor or static method

```dart
@GetXRoute(
  routeName: 'custom-name',
  returnType: bool,
  navigationType: NavigationType.popAndPush,
  middlewares: [
    MiddlewareExample,
  ],
)
class FirstPage extends StatelessWidget {
    final int someValue;

    const FirstPage({required this.someValue, super.key});

    @getXRouteConstructor
    static FirstPage doubleValue(int someValue, {Key? key}) => FirstPage(someValue: someValue * 2, key: key);
```

## Separate method/page

For some projects, you may have multiple projects/packages/navigators and it can happen that you want to generate a method in a different navigator than the page.

An example would be a goToHelpScreen in a shared package and an implementation in different apps. In this case, you can use the `generateMethod` and `generatePage` options to generate only the method or only the page.

**Note** that the `routeName` must be the same for both the method and the page.

If you want to generate different arguments for the page than the base Widget has, you can use the `@getXRouteConstructor` annotation to specify a named constructor to use for the method arguments.

```dart
// In your shared package:
@GetXRoute(
  generatePage: false,
  routeName: '/help',
)
class BaseHelp extends StatelessWidget {
  final String appTitle;

  const BaseHelp({required this.appTitle, super.key});

  @getXRouteConstructor
  static BaseHelp.implementationConstructor()

...

// In your implementation:
@GetXRoute(
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

This package supports nested navigators. To use them, you need to specify a `id` for the navigator and use the `navigatorId` argument in the methods.

```dart
Navigator(
  key: Get.nestedKey(widget.id),
  onGenerateRoute: (settings) {
    final page = MainNavigator.pages.firstWhere((element) => element.name == settings.name);
    return GetPageRoute<dynamic>(
      page: page.page,
      settings: settings,
      binding: page.binding,
      transition: page.transition,
      opaque: page.opaque,
      popGesture: page.popGesture,
      fullscreenDialog: page.fullscreenDialog,
      maintainState: page.maintainState,
      curve: page.curve,
      middlewares: page.middlewares,
    );
  },
);

...

_navigator.goToPageWithinNestedNavigation(navigatorId: widget.id);
```
