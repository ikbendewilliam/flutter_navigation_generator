import 'package:example/custom_model.dart';
import 'package:example/main_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_animations/flutter_navigation_generator_animations.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

Future<void> main() async {
  await mainNavigator.updateGuards();
  runApp(const MyApp());
}

// Define a navigator in your DI
final mainNavigator = MainNavigator();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: mainNavigator.onGenerateRoute, // Set onGenerateRoute
      navigatorKey: mainNavigator.navigatorKey, // Set the navigatorKey
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

// Define your route by adding FlutterRoute
@FlutterRoute(routeName: '/') // Optionally define the routeName
@FlutterRoute(
  // You can have multiple routes for the same screen
  methodName: 'goToHomePageWithPathParameter', // But you need a separate methodName for this
  routeName: 'my-home-page-pop-all/',
  navigationType: NavigationType.pushAndReplaceAll, // You can specify how you navigate to the route
)
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    this.title, // Arguments are added automatically to the goTo method
    @FlutterRouteField(ignore: false) super.key, // You can ignore specific arguments (key is ignored automatically)
  });

  @FlutterRouteConstructor(routeName: 'MyHomePagePopAll') // If you want, you can define multiple constructors and say which constructor is used for which method
  const MyHomePage.popAll({super.key, this.title = 'Popped all pages'});

  @FlutterRouteField(queryName: 'page_title') // Set queryName in case you use web navigation and want to improve the URL's
  // You can also ignore fields here, otherwise there is no need to add FlutterRouteField
  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.title == null
          ? null
          : AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Text(widget.title!),
            ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Text('Result from page 2: $_result'),
            ElevatedButton(
              onPressed: () async {
                _result = await mainNavigator.goToSecondPage();
                setState(() {});
              },
              child: const Text("Go to page 2 (with fade animation)"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.goToExampleScreenWithRequiredArgument(
                data: [
                  const CustomModel('John', 25),
                  const CustomModel('Jeff', 27),
                ],
              ),
              child: const Text("Go to ExampleScreenWithRequiredArgument"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.customName(
                id: '1',
                name: 'John',
                age: 12,
              ),
              child: const Text("Go to RouteNameWithArguments"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.goToRouteNameWithArguments2(
                id: '3',
                name: 'Will',
                age: 43,
                exampleEnum: ExampleEnum.first,
                exampleEnum2: ExampleEnum.second,
                exampleEnum3: ExampleEnum.third,
                exampleEnums4: [
                  ExampleEnum.first,
                  ExampleEnum.second,
                ],
                exampleEnumsMap5: {
                  'first': ExampleEnum.first,
                  'second': ExampleEnum.second,
                },
              ),
              child: const Text("Go to RouteNameWithArguments2"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.showSheetRecursiveNavigationBottomSheet(),
              child: const Text("Show a bottom sheet with its own navigator"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.goToParentPage(),
              child: const Text("Multi panels example"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.goToGuardExampleHome(),
              child: const Text("Guards example (login)"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.showDialogExampleDialog(
                text: 'hi there',
              ),
              child: const Text("Show a full screen dialog"),
            ),
          ],
        ),
      ),
    );
  }
}

@FlutterRoute(
  returnType: bool,
  pageType: FadeInRouteAnimation,
)
@FlutterRoute(
  // If you don't specify another routeName, make sure the returnType and pagetype are the same
  navigationType: NavigationType.popAndPush,
  returnType: bool,
  pageType: FadeInRouteAnimation,
  methodName: 'popAndGoToSecondPage',
)
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('second page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Second page :raised_hands:'),
            ElevatedButton(
              onPressed: () => mainNavigator.goBackWithResult(result: true),
              child: const Text("I return true"),
            ),
            ElevatedButton(
              onPressed: mainNavigator.goBack,
              child: const Text("I return nothing"),
            ),
          ],
        ),
      ),
    );
  }
}

@flutterRoute
class AllTypesExample extends StatelessWidget {
  final String? nullableString;
  final String nonNullableString;
  final String nonNullableStringWithDefaultValue;
  final int? nullableInt;
  final int nonNullableInt;
  final int nonNullableIntWithDefaultValue;
  final bool? nullableBool;
  final bool nonNullableBool;
  final bool nonNullableBoolWithDefaultValue;
  final double? nullableDouble;
  final double nonNullableDouble;
  final double nonNullableDoubleWithDefaultValue;
  final ExampleEnum? nullableEnum;
  final ExampleEnum nonNullableEnum;
  final ExampleEnum nonNullableEnumWithDefaultValue;
  final List<String>? nullableList;
  final List<String> nonNullableList;
  final List<String> nonNullableListWithDefaultValue;
  final Map<String, String>? nullableMap;
  final Map<String, String> nonNullableMap;
  final Map<String, String> nonNullableMapWithDefaultValue;
  final CustomModel? nullableCustomModel;
  final CustomModel nonNullableCustomModel;
  final CustomModel nonNullableCustomModelWithDefaultValue;
  final CustomModel nonNullableCustomModelWithDefaultValue2;
  final notUsedField = const CustomModel('Not used', 0);

  const AllTypesExample({
    required this.nonNullableString,
    required this.nonNullableInt,
    required this.nonNullableBool,
    required this.nonNullableDouble,
    required this.nonNullableList,
    required this.nonNullableMap,
    required this.nonNullableCustomModel,
    required this.nonNullableEnum,
    this.nullableString,
    this.nullableInt,
    this.nullableBool,
    this.nullableDouble,
    this.nullableEnum,
    this.nullableList,
    this.nullableMap,
    this.nullableCustomModel,
    this.nonNullableStringWithDefaultValue = 'default',
    this.nonNullableIntWithDefaultValue = 42,
    this.nonNullableBoolWithDefaultValue = true,
    this.nonNullableDoubleWithDefaultValue = 3.14,
    this.nonNullableEnumWithDefaultValue = ExampleEnum.first,
    this.nonNullableListWithDefaultValue = const ['default'],
    this.nonNullableMapWithDefaultValue = const {'default': 'default'},
    this.nonNullableCustomModelWithDefaultValue = const CustomModel('default', 0),
    this.nonNullableCustomModelWithDefaultValue2 = CustomModel.testDefault,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Field value tests'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Field value tests:'),
            Text('Strings: $nullableString, $nonNullableString, $nonNullableStringWithDefaultValue'),
            Text('Ints: $nullableInt, $nonNullableInt, $nonNullableIntWithDefaultValue'),
            Text('Bools: $nullableBool, $nonNullableBool, $nonNullableBoolWithDefaultValue'),
            Text('Doubles: $nullableDouble, $nonNullableDouble, $nonNullableDoubleWithDefaultValue'),
            Text('Lists: $nullableList, $nonNullableList, $nonNullableListWithDefaultValue'),
            Text('Maps: $nullableMap, $nonNullableMap, $nonNullableMapWithDefaultValue'),
            Text('Custom models: $nullableCustomModel, $nonNullableCustomModel, $nonNullableCustomModelWithDefaultValue'),
            ElevatedButton(onPressed: mainNavigator.goBack, child: const Text("Back")),
          ],
        ),
      ),
    );
  }
}

enum ExampleEnum { first, second, third }
