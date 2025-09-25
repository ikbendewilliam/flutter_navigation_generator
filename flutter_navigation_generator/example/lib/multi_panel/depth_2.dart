import 'package:example/main.dart' show mainNavigator;
import 'package:example/multi_panel/depth_3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:intl/intl.dart';

@FlutterRoute(
  routeName: 'day/:day',
  children: [
    Depth3PageBreakfast,
    Depth3PageLunch,
    Depth3PageDinner,
  ],
)
class Depth2Page extends StatefulWidget {
  final int day;
  final int week;

  const Depth2Page({
    required this.day,
    required this.week,
    super.key,
  });

  @override
  State<Depth2Page> createState() => _Depth2PageState();
}

class _Depth2PageState extends State<Depth2Page> {
  String? _result = 'No result yet';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Week ${widget.week} > ${DateFormat('EEEE').format(DateTime(2025, 9, widget.day))}'),
          Text('Result: $_result'),
          ListTile(
            onTap: () async {
              _result = await mainNavigator.goToDepth3PageBreakfast(day: widget.day, week: widget.week);
              setState(() {});
            },
            title: const Text('Breakfast'),
          ),
          ListTile(
            onTap: () async {
              _result = await mainNavigator.goToDepth3PageLunch(day: widget.day, week: widget.week);
              setState(() {});
            },
            title: const Text('Lunch'),
          ),
          ListTile(
            onTap: () async {
              _result = await mainNavigator.goToDepth3PageDinner(day: widget.day, week: widget.week);
              setState(() {});
            },
            title: const Text('Dinner'),
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
