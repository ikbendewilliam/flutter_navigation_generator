import 'package:example/main.dart';
import 'package:example/main_navigator.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class ExampleDefaultGuard extends NavigatorGuard {
  ExampleDefaultGuard() : super(RouteNames.r404);

  @override
  Future<bool> getValue() async => true;
}

@FlutterRoute(routeName: '404', generateMethod: false)
class Error404 extends StatelessWidget {
  const Error404({super.key});

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
            const Text('We couldn\'t find this page, sorry :('),
            ElevatedButton(
              onPressed: () => mainNavigator.goToMyHomePage(title: 'returning from 404'),
              child: const Text("go home"),
            ),
          ],
        ),
      ),
    );
  }
}
