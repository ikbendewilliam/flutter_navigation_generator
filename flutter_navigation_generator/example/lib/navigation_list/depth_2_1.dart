import 'package:example/main.dart' show mainNavigator;
import 'package:example/navigation_list/depth_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@FlutterRoute(
  parentScreen: Depth1Page1,
  routeName: '/parent/depth0/depth1-page1/depth2-page1',
)
class Depth2Page11 extends StatelessWidget {
  const Depth2Page11({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Depth 2 Page 1 > 1'),
          ListTile(
            onTap: () => mainNavigator.goToDepth2Page12(),
            title: const Text('Change this page to page 2'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth3Page111(),
            title: const Text('Go to 1 > 1 > 1'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth3Page112(),
            title: const Text('Go to 1 > 1 > 2'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth3Page113(),
            title: const Text('Go to 1 > 1 > 3'),
          ),
        ],
      ),
    );
  }
}

@FlutterRoute(
  parentScreen: Depth1Page1,
  routeName: '/parent/depth0/depth1-page1/depth2-page2',
)
class Depth2Page12 extends StatelessWidget {
  const Depth2Page12({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Depth 2 Page 1 > 2'),
          ListTile(
            onTap: () => mainNavigator.goToDepth2Page11(),
            title: const Text('Change this page to page 1'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth3Page121(),
            title: const Text('Go to 1 > 2 > 1'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth3Page122(),
            title: const Text('Go to 1 > 2 > 2'),
          ),
        ],
      ),
    );
  }
}
