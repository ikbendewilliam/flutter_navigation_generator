import 'package:example/main.dart';
import 'package:example/multi_panel/depth_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:intl/intl.dart';

@FlutterRoute(
  children: [Depth2Page],
  routeName: 'week/:week',
)
class Depth1Page extends StatefulWidget {
  final int week;

  const Depth1Page({
    required this.week,
    super.key,
  });

  @override
  State<Depth1Page> createState() => _Depth1PageState();
}

class _Depth1PageState extends State<Depth1Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Week ${widget.week}'),
          if (widget.week > 1) ...[
            ListTile(
              onTap: () => mainNavigator.goToDepth1Page(week: widget.week - 1),
              title: Text('< Week ${widget.week - 1}'),
            ),
          ],
          const Divider(),
          for (var day = 1; day <= 7; day++) ...[
            ListTile(
              onTap: () => mainNavigator.goToDepth2Page(week: widget.week, day: day),
              title: Text(DateFormat('EEEE').format(DateTime(2025, 9, day))),
            ),
          ],
          const Divider(),
          ListTile(
            onTap: () => mainNavigator.goToDepth1Page(week: widget.week + 1),
            title: Text('Week ${widget.week + 1} >'),
          ),
          ElevatedButton(
            child: const Text('Pop a screen'),
            onPressed: () => mainNavigator.goBack(),
          ),
        ],
      ),
    );
  }
}
