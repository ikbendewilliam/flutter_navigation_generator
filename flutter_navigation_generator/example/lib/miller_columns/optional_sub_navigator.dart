import 'package:example/example.navigator.dart';
import 'package:example/example.widgets.dart';
import 'package:flutter/material.dart';

class OptionalSubNavigator extends StatelessWidget {
  final Type parentScreen;
  final BaseNavigator parentNavigator;
  final Widget child;

  const OptionalSubNavigator({
    required this.parentScreen,
    required this.parentNavigator,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SubNavigatorListener(
      parentScreen: parentScreen,
      parentNavigator: parentNavigator,
      builder: (context, isActive) => Row(
        children: [
          Expanded(
            child: child,
          ),
          if (isActive) ...[
            const VerticalDivider(width: 1),
            Expanded(
              child: SubNavigator(
                parentNavigator: parentNavigator,
                parentScreen: parentScreen,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
