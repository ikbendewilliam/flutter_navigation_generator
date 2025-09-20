import 'package:example/navigation_list/depth_2_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@FlutterRoute(
  parentScreen: Depth2Page12,
)
class Depth3Page121 extends StatelessWidget {
  const Depth3Page121({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Depth 3 Page 1 > 2 > 1'),
      ),
    );
  }
}

@FlutterRoute(
  parentScreen: Depth2Page12,
)
class Depth3Page122 extends StatelessWidget {
  const Depth3Page122({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Depth 3 Page 1 > 2 > 2'),
      ),
    );
  }
}

@FlutterRoute(
  parentScreen: Depth2Page12,
)
class Depth3Page123 extends StatelessWidget {
  const Depth3Page123({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Depth 3 Page 1 > 2 > 3'),
      ),
    );
  }
}
