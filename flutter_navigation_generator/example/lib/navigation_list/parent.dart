import 'package:example/example.navigator.dart';
import 'package:example/example.widgets.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@flutterRoute
class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  var _panels = 3;
  var _direction = Axis.horizontal;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainNavigator
        ..goToDepth0Page()
        ..goToDepth1Page1();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('parent page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Slider(
                value: _panels.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: '$_panels panels',
                onChanged: (value) {
                  setState(() {
                    _panels = value.toInt();
                  });
                },
              ),
              Text('$_panels panels'),
              const SizedBox(width: 16),
              if (_direction == Axis.horizontal) ...[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _direction = Axis.vertical;
                    });
                  },
                  child: const Text('Switch to vertical'),
                ),
              ] else ...[
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _direction = Axis.horizontal;
                    });
                  },
                  child: const Text('Switch to horizontal'),
                ),
              ],
            ],
          ),
          const Divider(),
          Expanded(
            child: MultiPanelNavigator(
              parentRoute: RouteNames.parentPage,
              panels: _panels,
              direction: _direction,
              navigator: mainNavigator,
            ),
          ),
        ],
      ),
    );
  }
}

@FlutterRoute(
  parentScreen: ParentPage,
  routeName: '/parent/depth0',
)
class Depth0Page extends StatelessWidget {
  const Depth0Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ListTile(
                  onTap: () => mainNavigator.goToDepth1Page1(),
                  title: const Text('Go to Depth 1 Page 1'),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth2Page11(),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text('Go to Depth 2 Page 1 > 1'),
                  ),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth2Page12(),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text('Go to Depth 2 Page 1 > 2'),
                  ),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth1Page2(),
                  title: const Text('Go to Depth 1 Page 2'),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth1Page3(),
                  title: const Text('Go to Depth 1 Page 3'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
