import 'package:example/navigation_list/depth_2_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@FlutterRoute(
  parentScreen: Depth2Page11,
  routeName: '/parent/depth0/depth1-page1/depth2-page1/depth3-page1',
)
class Depth3Page111 extends StatelessWidget {
  const Depth3Page111({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Depth 3 Page 1 > 1 > 1'),
      ),
    );
  }
}

@FlutterRoute(
  parentScreen: Depth2Page11,
  routeName: '/parent/depth0/depth1-page1/depth2-page1/depth3-page2',
)
class Depth3Page112 extends StatelessWidget {
  const Depth3Page112({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Depth 3 Page 1 > 1 > 2'),
      ),
    );
  }
}

@FlutterRoute(
  parentScreen: Depth2Page11,
  routeName: '/parent/depth0/depth1-page1/depth2-page1/depth3-page3',
)
class Depth3Page113 extends StatelessWidget {
  const Depth3Page113({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Depth 3 Page 1 > 1 > 3'),
      ),
    );
  }
}
