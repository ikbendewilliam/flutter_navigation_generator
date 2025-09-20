import 'package:example/main.dart';
import 'package:example/navigation_list/parent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@FlutterRoute(
  parentScreen: Depth0Page,
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
      body: Column(
        children: [
          const Text('Week 1'),
          ListTile(
            onTap: () => mainNavigator.goToDepth2Page11(),
            title: const Text('Monday'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth2Page12(),
            title: const Text('Tuesday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Wednesday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Thursday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Friday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Saterday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Sunday'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth1Page2(),
            title: const Text('Week 2'),
          ),
        ],
      ),
    );
  }
}

@FlutterRoute(
  parentScreen: Depth0Page,
)
class Depth1Page2 extends StatefulWidget {
  const Depth1Page2({super.key});

  @override
  State<Depth1Page2> createState() => _Depth1Page2State();
}

class _Depth1Page2State extends State<Depth1Page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Week 2'),
          ListTile(
            onTap: () => mainNavigator.goToDepth1Page1(),
            title: const Text('< Week 1'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Monday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Tuesday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Wednesday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Thursday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Friday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Saterday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Sunday'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth1Page3(),
            title: const Text('Week 3 >'),
          ),
        ],
      ),
    );
  }
}

@FlutterRoute(
  parentScreen: Depth0Page,
)
class Depth1Page3 extends StatefulWidget {
  const Depth1Page3({super.key});

  @override
  State<Depth1Page3> createState() => _Depth1Page3State();
}

class _Depth1Page3State extends State<Depth1Page3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Week 3'),
          ListTile(
            onTap: () => mainNavigator.goToDepth1Page2(),
            title: const Text('< Week 2'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Monday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Tuesday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Wednesday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Thursday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Friday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Saterday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Sunday'),
          ),
          const ListTile(
            textColor: Colors.grey,
            title: Text('Week 4 >'),
          ),
        ],
      ),
    );
  }
}
