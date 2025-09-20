import 'package:example/main.dart';
import 'package:example/navigation_list/parent_navigator_widget.dart';
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
            ],
          ),
          const Divider(),
          Expanded(
            child: ParentNavigatorWidget(
              panels: _panels,
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
                const Text(
                  '''Welcome to an example of a multipanel navigation.
The goal is to have multiple panels that work with parentScreens to know whether to add a screen and/or push one away, or to replace one or more screens.
To make the use case clearer The example shows a menu screen where you can select a week, then select a day, then select breakfast/lunch/dinner and finally see the details for that meal.''',
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth1Page1(),
                  title: const Text('Week 1'),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth2Page11(),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text('Today'),
                  ),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth2Page12(),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text('Tomorrow'),
                  ),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth1Page2(),
                  title: const Text('Week 2'),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth1Page3(),
                  title: const Text('Week 3'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
