import 'package:example/example.widgets.dart';
import 'package:example/main.dart' show mainNavigator;
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@flutterRoute
class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  final checkboxes = <String, bool>{
    'checkbox1': false,
    'checkbox2': false,
    'checkbox3': false,
    'checkbox4': false,
    'checkbox5': false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('parent page'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text('Some example selectors so you can see the state is preserved'),
                ...checkboxes.entries.map(
                  (entry) => CheckboxListTile(
                    title: Text(entry.key),
                    value: entry.value,
                    onChanged: (value) {
                      setState(() {
                        checkboxes[entry.key] = value ?? false;
                      });
                    },
                  ),
                ),
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
          const VerticalDivider(),
          Expanded(
            child: SubNavigator(
              parentScreen: ParentPage,
              parentNavigator: mainNavigator,
            ),
          ),
        ],
      ),
    );
  }
}
