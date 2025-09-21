import 'package:example/main.dart' show mainNavigator;
import 'package:example/navigation_list/depth_1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:intl/intl.dart';

@FlutterRoute(
  parentScreen: Depth1Page,
  routeName: 'day/:day',
)
class Depth2Page extends StatelessWidget {
  final int day;
  final int week;

  const Depth2Page({
    required this.day,
    required this.week,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Week $week > ${DateFormat('EEEE').format(DateTime(2025, 9, day))}'),
          ListTile(
            onTap: () => mainNavigator.goToDepth3PageBreakfast(day: day, week: week),
            title: const Text('Breakfast'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth3PageLunch(day: day, week: week),
            title: const Text('Lunch'),
          ),
          ListTile(
            onTap: () => mainNavigator.goToDepth3PageDinner(day: day, week: week),
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
