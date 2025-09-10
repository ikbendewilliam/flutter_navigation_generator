import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@flutterRoute
class Depth3Page111 extends StatelessWidget {
  const Depth3Page111({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Depth 3 Page 1 > 1 > 1'),
      ),
      body: const Center(
        child: Text('Depth 3 Page 1 > 1 > 1'),
      ),
    );
  }
}

@flutterRoute
class Depth3Page112 extends StatelessWidget {
  const Depth3Page112({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Depth 3 Page 1 > 1 > 2'),
      ),
      body: const Center(
        child: Text('Depth 3 Page 1 > 1 > 2'),
      ),
    );
  }
}

@flutterRoute
class Depth3Page113 extends StatelessWidget {
  const Depth3Page113({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Depth 3 Page 1 > 1 > 3'),
      ),
      body: const Center(
        child: Text('Depth 3 Page 1 > 1 > 3'),
      ),
    );
  }
}
