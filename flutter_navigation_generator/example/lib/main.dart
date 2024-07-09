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
  routeName: 'my-home-page-pop-all/:title',
  navigationType: NavigationType.pushAndReplaceAll,
)
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.title,
  });

  @FlutterRouteConstructor(
    routeName: 'MyHomePagePopAll',
  )
  const MyHomePage.popAll({super.key, this.title = 'Popped all pages'});

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
              onPressed: () =>
                  mainNavigator.goToExampleScreenWithRequiredArgument(
                      data: CustomModel('John', 25)),
              child: const Text("Go to ExampleScreenWithRequiredArgument"),
            ),
            ElevatedButton(
              onPressed: () =>
                  mainNavigator.customName(id: '1', name: 'John', age: 12),
              child: const Text("Go to RouteNameWithArguments"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.goToRouteNameWithArguments2(
                  id: '3', name: 'Will', age: 43),
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
  routeName: 'home/:id/:name/:nonExistingName/',
  methodName: 'customName',
)
class RouteNameWithArguments extends StatelessWidget {
  final String id;
  final String? name;
  final int? age;

  const RouteNameWithArguments({
    required this.id,
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
  routeName: '/home/:id/example/:age',
)
class RouteNameWithArguments2 extends StatelessWidget {
  final String id;
  final String? name;
  final int? age;

  const RouteNameWithArguments2({
    required this.id,
    this.name,
    this.age,
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
  final CustomModel data;

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
              data.name,
              style: const TextStyle(fontSize: 40),
            ),
            Text(
              data.age.toString(),
              style: const TextStyle(fontSize: 40),
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

class LoginGuard extends NavigatorGuard {
  LoginGuard() : super(RouteNames.errorNotLoggedIn);

  @override
  Future<bool> getValue() async => globalStateIsLoggedIn;
}
