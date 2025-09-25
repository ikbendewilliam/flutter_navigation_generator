import 'package:example/main.dart';
import 'package:example/main_navigator.dart';
import 'package:example/main_navigator.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@FlutterRoute(navigationType: NavigationType.bottomSheet)
class RecursiveNavigationBottomSheet extends StatelessWidget {
  final myNavigator = MainNavigator();
  final int layers;

  RecursiveNavigationBottomSheet({this.layers = 1, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: mainNavigator.goBack,
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('layer $layers'),
          const Text('I am a bottom sheet with my own navigator'),
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

  const ExampleDialog({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(child: Center(child: Text(text)));
  }
}
