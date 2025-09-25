import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';
import 'package:intl/intl.dart';

@FlutterRoute(
  returnType: String,
)
class Depth3PageBreakfast extends StatelessWidget {
  final int week;
  final int day;

  const Depth3PageBreakfast({
    required this.week,
    required this.day,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Week $week > ${DateFormat('EEEE').format(DateTime(2025, 9, day))} > Breakfast'),
          ElevatedButton(
            child: const Text('Pop a screen'),
            onPressed: () => mainNavigator.goBackWithResult(result: 'Breakfast'),
          ),
        ],
      ),
    );
  }
}

@FlutterRoute(
  returnType: String,
)
class Depth3PageLunch extends StatelessWidget {
  final int week;
  final int day;

  const Depth3PageLunch({
    required this.week,
    required this.day,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Week $week > ${DateFormat('EEEE').format(DateTime(2025, 9, day))} > Lunch'),
          ElevatedButton(
            child: const Text('Pop a screen'),
            onPressed: () => mainNavigator.goBackWithResult(result: 'Lunch'),
          ),
        ],
      ),
    );
  }
}

@FlutterRoute(
  returnType: String,
)
class Depth3PageDinner extends StatelessWidget {
  final int week;
  final int day;

  const Depth3PageDinner({
    required this.week,
    required this.day,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('Week $week > ${DateFormat('EEEE').format(DateTime(2025, 9, day))} > Dinner'),
          ElevatedButton(
            child: const Text('Pop a screen'),
            onPressed: () => mainNavigator.goBackWithResult(result: 'Dinner'),
          ),
        ],
      ),
    );
  }
}
