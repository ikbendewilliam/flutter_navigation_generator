import 'package:example/custom_model.dart';
import 'package:example/example.dart';
import 'package:example/example.navigator.dart';
import 'package:example/fade_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

Future<void> main() async {
  await mainNavigator.updateGuards();
  runApp(const MyApp());
}

final mainNavigator = MainNavigator();

var globalStateIsLoggedIn = false;

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
      onGenerateRoute: mainNavigator.onGenerateRoute,
      navigatorKey: mainNavigator.navigatorKey,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

@FlutterRoute(
  routeName: '/',
)
@FlutterRoute(
  methodName: 'goToHomePageWithPathParameter',
  routeName: 'my-home-page-pop-all/',
  navigationType: NavigationType.pushAndReplaceAll,
)
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    this.title,
    @FlutterRouteField(ignore: false) super.key, // Key is ignored by default
  });

  @FlutterRouteConstructor(
    routeName: 'MyHomePagePopAll',
  )
  const MyHomePage.popAll({super.key, this.title = 'Popped all pages'});

  @FlutterRouteField(queryName: 'page_title')
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
          children: [
            Text(
              'Result from page 2: $_result',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: globalStateIsLoggedIn,
                  onChanged: (value) {
                    globalStateIsLoggedIn = value!;
                    setState(() {});
                    mainNavigator.updateGuard<LoginGuard>();
                  },
                ),
                const Text(
                  'Is user logged in?',
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => mainNavigator.goToLoggedInPage(),
                  child: const Text("Go to logged in page"),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                _result = await mainNavigator.goToSecondPage();
                setState(() {});
              },
              child: const Text("Go to page 2 (with fade animation)"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator
                  .goToExampleScreenWithRequiredArgument(data: [
                const CustomModel('John', 25),
                const CustomModel('Jeff', 27)
              ]),
              child: const Text("Go to ExampleScreenWithRequiredArgument"),
            ),
            ElevatedButton(
              onPressed: () =>
                  mainNavigator.customName(id: '1', name: 'John', age: 12),
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
                exampleEnums4: [ExampleEnum.first, ExampleEnum.second],
                exampleEnumsMap5: {
                  'first': ExampleEnum.first,
                  'second': ExampleEnum.second,
                },
              ),
              child: const Text("Go to RouteNameWithArguments2"),
            ),
            ElevatedButton(
              onPressed: () =>
                  mainNavigator.showSheetRecursiveNavigationBottomSheet(),
              child: const Text("Show a bottom sheet with its own navigator"),
            ),
            ElevatedButton(
              onPressed: () =>
                  mainNavigator.showDialogExampleDialog(text: 'hi there'),
              child: const Text("Show a full screen dialog"),
            ),
            Text(
                "Has a navigation blocked by a guard (not logged in): ${mainNavigator.canContinueNavigation()}"),
            if (mainNavigator.canContinueNavigation()) ...[
              ElevatedButton(
                onPressed: () async {
                  globalStateIsLoggedIn = true;
                  await mainNavigator.updateGuard<LoginGuard>();
                  mainNavigator.continueNavigation();
                },
                child: const Text("Continue navigation (and set logged in)"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

@FlutterRoute(
  returnType: bool,
  pageType: FadeInRoute,
)
@FlutterRoute(
  // If you don't specify another routeName, make sure the returnType and pagetype are the same
  navigationType: NavigationType.popAndPush,
  returnType: bool,
  pageType: FadeInRoute,
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
            const Text(
              'Second page :raised_hands:',
            ),
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

@FlutterRoute(
  routeName: 'home/:id/:name/:nonExistingName/number1/',
  methodName: 'customName',
)
class RouteNameWithArguments extends StatelessWidget {
  final String id;
  final String? name;
  final int? age;
  final CustomModel? model;

  const RouteNameWithArguments({
    required this.id,
    this.model,
    this.name,
    this.age,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('RouteNameWithArguments'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'RouteNameWithArguments:',
            ),
            Text(
              'id: $id',
            ),
            Text(
              'name: $name',
            ),
            Text(
              'age: $age',
            ),
            ElevatedButton(
              onPressed: mainNavigator.goBack,
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}

@FlutterRoute(
  routeName: '/home/:id/example/:exampleEnum/:age',
)
class RouteNameWithArguments2 extends StatelessWidget {
  final String id;
  final String? name;
  final int? age;
  final ExampleEnum exampleEnum;
  final ExampleEnum exampleEnum2;
  final ExampleEnum? exampleEnum3;
  final List<ExampleEnum>? exampleEnums4;
  final Map<String, ExampleEnum>? exampleEnumsMap5;

  const RouteNameWithArguments2({
    required this.id,
    required this.exampleEnum,
    required this.exampleEnum2,
    this.name,
    this.age,
    this.exampleEnum3,
    this.exampleEnums4,
    this.exampleEnumsMap5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('RouteNameWithArguments2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'RouteNameWithArguments2:',
            ),
            Text(
              'id: $id',
            ),
            Text(
              'name: $name',
            ),
            Text(
              'age: $age',
            ),
            Text(
              'exampleEnum: $exampleEnum',
            ),
            Text(
              'exampleEnum2: $exampleEnum2',
            ),
            Text(
              'exampleEnum3: $exampleEnum3',
            ),
            Text(
              'exampleEnums4: $exampleEnums4',
            ),
            Text(
              'exampleEnumsMap5: $exampleEnumsMap5',
            ),
            ElevatedButton(
              onPressed: mainNavigator.goBack,
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}

@FlutterRoute(
  navigationType: NavigationType.bottomSheet,
)
class RecursiveNavigationBottomSheet extends StatelessWidget {
  final myNavigator = MainNavigator();
  final int layers;

  RecursiveNavigationBottomSheet({
    this.layers = 1,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: mainNavigator.goBack,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'layer $layers',
          ),
          const Text(
            'I am a bottom sheet with my own navigator',
          ),
          Wrap(
            children: [
              ElevatedButton(
                onPressed: () => myNavigator.goToHomePageWithPathParameter(),
                child: const Text("Pop all and show home page"),
              ),
              ElevatedButton(
                onPressed: () => myNavigator.goToSecondPage(),
                child: const Text("Go to second page"),
              ),
              ElevatedButton(
                onPressed: () =>
                    myNavigator.showSheetRecursiveNavigationBottomSheet(
                        layers: layers + 1),
                child: const Text("Open another bottom sheet"),
              ),
            ],
          ),
          Expanded(
            child: Navigator(
              key: myNavigator.navigatorKey,
              onGenerateRoute: myNavigator.onGenerateRoute,
              initialRoute: RouteNames.myHomePage,
            ),
          ),
        ],
      ),
    );
  }
}

@flutterDialog
class ExampleDialog extends StatelessWidget {
  final String text;

  const ExampleDialog({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Center(
        child: Text(
          text,
        ),
      ),
    );
  }
}

@flutterRoute
class ExampleScreenWithRequiredArgument extends StatelessWidget {
  final List<CustomModel> data;

  const ExampleScreenWithRequiredArgument({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Got ${data.length} items:',
              style: const TextStyle(fontSize: 40),
            ),
            for (final item in data) ...[
              Text(
                item.name,
                style: const TextStyle(fontSize: 40),
              ),
              Text(
                item.age.toString(),
                style: const TextStyle(fontSize: 40),
              ),
            ],
            ElevatedButton(
              onPressed: mainNavigator.goBack,
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}

@FlutterRoute(
  routeName: '404',
  generateMethod: false,
)
class Error404 extends StatelessWidget {
  const Error404({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('404 not found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'We couldn\'t find this page, sorry :(',
            ),
            ElevatedButton(
              onPressed: () =>
                  mainNavigator.goToMyHomePage(title: 'returning from 404'),
              child: const Text("go home"),
            ),
          ],
        ),
      ),
    );
  }
}

@FlutterRoute(
  generateMethod: false,
)
class ErrorNotLoggedIn extends StatelessWidget {
  const ErrorNotLoggedIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('You are not logged in'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are not logged in, sorry :(',
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.goToMyHomePage(
                  title: 'returning from not logged in'),
              child: const Text("go home"),
            ),
            ElevatedButton(
              onPressed: () async {
                globalStateIsLoggedIn = true;
                await mainNavigator.updateGuard<LoginGuard>();
                mainNavigator.continueNavigation();
              },
              child: const Text("Continue navigation (and set logged in)"),
            ),
          ],
        ),
      ),
    );
  }
}

@FlutterRoute(
  guards: [
    LoginGuard,
  ],
)
class LoggedInPage extends StatelessWidget {
  const LoggedInPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('You are logged in'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You are logged in, yay :)',
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.goToMyHomePage(
                  title: 'returning from logged in'),
              child: const Text("go home"),
            ),
          ],
        ),
      ),
    );
  }
}

@flutterRoute
class FieldValueTests extends StatelessWidget {
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

  const FieldValueTests({
    required this.nonNullableString,
    required this.nonNullableInt,
    required this.nonNullableBool,
    required this.nonNullableDouble,
    required this.nonNullableList,
    required this.nonNullableMap,
    required this.nonNullableCustomModel,
    this.nullableString,
    this.nullableInt,
    this.nullableBool,
    this.nullableDouble,
    this.nullableList,
    this.nullableMap,
    this.nullableCustomModel,
    this.nonNullableStringWithDefaultValue = 'default',
    this.nonNullableIntWithDefaultValue = 42,
    this.nonNullableBoolWithDefaultValue = true,
    this.nonNullableDoubleWithDefaultValue = 3.14,
    this.nonNullableListWithDefaultValue = const ['default'],
    this.nonNullableMapWithDefaultValue = const {'default': 'default'},
    this.nonNullableCustomModelWithDefaultValue =
        const CustomModel('default', 0),
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
            const Text(
              'Field value tests:',
            ),
            Text(
              'Strings: $nullableString, $nonNullableString, $nonNullableStringWithDefaultValue',
            ),
            Text(
              'Ints: $nullableInt, $nonNullableInt, $nonNullableIntWithDefaultValue',
            ),
            Text(
              'Bools: $nullableBool, $nonNullableBool, $nonNullableBoolWithDefaultValue',
            ),
            Text(
              'Doubles: $nullableDouble, $nonNullableDouble, $nonNullableDoubleWithDefaultValue',
            ),
            Text(
              'Lists: $nullableList, $nonNullableList, $nonNullableListWithDefaultValue',
            ),
            Text(
              'Maps: $nullableMap, $nonNullableMap, $nonNullableMapWithDefaultValue',
            ),
            Text(
              'Custom models: $nullableCustomModel, $nonNullableCustomModel, $nonNullableCustomModelWithDefaultValue',
            ),
            ElevatedButton(
              onPressed: mainNavigator.goBack,
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}

enum ExampleEnum {
  first,
  second,
  third,
}

class LoginGuard extends NavigatorGuard {
  LoginGuard() : super(RouteNames.errorNotLoggedIn);

  @override
  Future<bool> getValue() async => globalStateIsLoggedIn;
}

class ExampleDefaultGuard extends NavigatorGuard {
  ExampleDefaultGuard() : super(RouteNames.r404);

  @override
  Future<bool> getValue() async => true;
}
