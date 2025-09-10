import 'package:example/main.dart';
import 'package:example/miller_columns/optional_sub_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@FlutterRoute(
    // childRoutes: [
    //   Depth2Page11,
    //   Depth2Page12,
    // ],
    )
class Depth1Page1 extends StatefulWidget {
  const Depth1Page1({super.key});

  @override
  State<Depth1Page1> createState() => _Depth1Page1State();
}

class _Depth1Page1State extends State<Depth1Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Depth 1 Page 1'),
      ),
      body: OptionalSubNavigator(
        parentNavigator: mainNavigator,
        parentScreen: Depth1Page1,
        child: Column(
          children: [
            const Text('Depth 1 Page 1'),
            ListTile(
              onTap: () => mainNavigator.goToDepth1Page2(),
              title: const Text('Change this page to page 2'),
            ),
            ListTile(
              onTap: () => mainNavigator.goToDepth1Page3(),
              title: const Text('Change this page to page 3'),
            ),
            ListTile(
              onTap: () => mainNavigator.goToDepth2Page11(),
              title: const Text('Go to 1 > 1'),
            ),
            ListTile(
              onTap: () => mainNavigator.goToDepth2Page12(),
              title: const Text('Go to 1 > 2'),
            ),
          ],
        ),
      ),
    );
  }
}

@flutterRoute
class Depth1Page2 extends StatefulWidget {
  const Depth1Page2({super.key});

  @override
  State<Depth1Page2> createState() => _Depth1Page2State();
}

class _Depth1Page2State extends State<Depth1Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Depth 1 Page 2'),
      ),
      body: Column(
        children: [
          const Text('Depth 1 Page 2'),
          ListTile(
            onTap: () => mainNavigator.goToDepth1Page1(),
            title: const Text('Change this page to page 1'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth1Page3(),
            title: const Text('Change this page to page 3'),
          ),
        ],
      ),
    );
  }
}

@flutterRoute
class Depth1Page3 extends StatefulWidget {
  const Depth1Page3({super.key});

  @override
  State<Depth1Page3> createState() => _Depth1Page3State();
}

class _Depth1Page3State extends State<Depth1Page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Depth 1 Page 3'),
      ),
      body: Column(
        children: [
          const Text('Depth 1 Page 3'),
          ListTile(
            onTap: () => mainNavigator.goToDepth1Page1(),
            title: const Text('Change this page to page 1'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth1Page2(),
            title: const Text('Change this page to page 2'),
          ),
        ],
      ),
    );
  }
}
