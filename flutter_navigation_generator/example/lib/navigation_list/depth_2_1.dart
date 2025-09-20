import 'package:example/main.dart' show mainNavigator;
import 'package:example/navigation_list/depth_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@FlutterRoute(
  parentScreen: Depth1Page1,
)
class Depth2Page11 extends StatelessWidget {
  const Depth2Page11({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Week 1 > Monday'),
          ListTile(
            onTap: () => mainNavigator.goToDepth3Page111(),
            title: const Text('Breakfast'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth3Page112(),
            title: const Text('Lunch'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth3Page113(),
            title: const Text('Dinner'),
          ),
        ],
      ),
    );
  }
}

@FlutterRoute(
  parentScreen: Depth1Page1,
)
class Depth2Page12 extends StatelessWidget {
  const Depth2Page12({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Week 1 > Tuesday'),
          ListTile(
            onTap: () => mainNavigator.goToDepth3Page121(),
            title: const Text('Breakfast'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth3Page122(),
            title: const Text('Lunch'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Dinner'),
          ),
        ],
      ),
    );
  }
}
