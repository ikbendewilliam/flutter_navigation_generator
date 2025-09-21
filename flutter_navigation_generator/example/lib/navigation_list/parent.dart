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
        ..goToDepth1Page(week: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('parent page'),
        leading: IconButton(onPressed: () => mainNavigator.goBack(), icon: const Icon(Icons.arrow_back)),
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
            child: ListView(
              children: [
                const Text(
                  '''Welcome to an example of a multipanel navigation.
The goal is to have multiple panels that work with parentScreens to know whether to add a screen and/or push one away, or to replace one or more screens.
To make the use case clearer The example shows a menu screen where you can select a week, then select a day, then select breakfast/lunch/dinner and finally see the details for that meal.''',
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth1Page(week: 1),
                  title: const Text('Week 1'),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth2Page(week: 1, day: 1),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text('Today (just week 1 day 1)'),
                  ),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth2Page(week: 1, day: 2),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 32),
                    child: Text('Tomorrow (just week 1 day 2)'),
                  ),
                ),
                ListTile(
                  onTap: () => mainNavigator.goToDepth3PageBreakfast(week: 1, day: 2),
                  title: const Padding(
                    padding: EdgeInsets.only(left: 64),
                    child: Text('Tomorrow breakfast'),
                  ),
                ),
                for (var week = 2; week <= 20; week++) ...[
                  ListTile(
                    onTap: () => mainNavigator.goToDepth1Page(week: week),
                    title: Text('Week $week'),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
