import 'package:example/fade_route.dart';
import 'package:example/navigator.dart';
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

@FlutterRoute(
  returnType: bool,
  pageType: FadeInRoute,
)
class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '0',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: mainNavigator.goToSecondPage,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

@flutterRoute
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('second page'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Second page :raised_hands:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: mainNavigator.goBack,
        tooltip: 'Increment',
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}
