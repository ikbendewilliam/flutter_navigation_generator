import 'package:example/custom_model.dart';
import 'package:example/example.dart';
import 'package:example/example.navigator.dart';
import 'package:example/fade_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

void main() {
  runApp(const MyApp());
}

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
      onGenerateRoute: mainNavigator.onGenerateRoute,
      navigatorKey: mainNavigator.navigatorKey,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

@flutterRoute
@FlutterRoute(
  routeName: 'MyHomePagePopAll',
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
            ElevatedButton(
              onPressed: () async {
                _result = await mainNavigator.goToSecondPage();
                setState(() {});
              },
              child: const Text("Go to page 2"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.goToExampleScreenWithRequiredArgument(data: CustomModel('John', 25)),
              child: const Text("Go to ExampleScreenWithRequiredArgument"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.showSheetRecursiveNavigationBottomSheet(),
              child: const Text("Show a bottom sheet with its own navigator"),
            ),
            ElevatedButton(
              onPressed: () => mainNavigator.showDialogExampleDialog(text: 'hi there'),
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
  navigationType: NavigationType.popAndPush,
  routeName: 'PopAndSecondPage',
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
                onPressed: () => myNavigator.goToMyHomePagePopAll(),
                child: const Text("Pop all and show home page"),
              ),
              ElevatedButton(
                onPressed: () => myNavigator.goToSecondPage(),
                child: const Text("Go to second page"),
              ),
              ElevatedButton(
                onPressed: () => myNavigator.showSheetRecursiveNavigationBottomSheet(layers: layers + 1),
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
    return Center(
      child: Row(
        children: [
          Text(
            data.name,
          ),
          Text(
            data.age.toString(),
          ),
        ],
      ),
    );
  }
}
