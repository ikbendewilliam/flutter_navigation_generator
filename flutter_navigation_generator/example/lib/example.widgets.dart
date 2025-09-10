import 'dart:async';

import 'package:example/example.dart';
import 'package:example/example.navigator.dart';
import 'package:flutter/material.dart';

class SubNavigator extends StatefulWidget {
  final Type parentScreen;
  final MainNavigator parentNavigator;

  const SubNavigator({required this.parentScreen, required this.parentNavigator, super.key});

  @override
  State<SubNavigator> createState() => _SubNavigatorState();
}

class _SubNavigatorState extends State<SubNavigator> {
  late final BaseNavigator subNavigator = widget.parentNavigator.createSubNavigator(widget.parentScreen);

  @override
  void dispose() {
    (subNavigator as MainNavigator).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: subNavigator.navigatorKey,
      // initialRoute: subNavigator.initialRoute,
      onGenerateRoute: subNavigator.onGenerateRoute,
    );
  }
}

class SubNavigatorListener extends StatefulWidget {
  final Type parentScreen;
  final BaseNavigator parentNavigator;
  final Widget Function(BuildContext context, bool isActive) builder;

  const SubNavigatorListener({required this.parentScreen, required this.parentNavigator, required this.builder, super.key});

  @override
  State<SubNavigatorListener> createState() => _SubNavigatorListenerState();
}

class _SubNavigatorListenerState extends State<SubNavigatorListener> {
  var _isActive = false;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    // _subscription = widget.parentNavigator.subNavigatorStream(widget.parentScreen).listen(_onActiveChanged);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  // ignore: unused_element
  void _onActiveChanged(bool isActive) {
    if (_isActive != isActive) {
      setState(() {
        _isActive = isActive;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _isActive);
  }
}

extension on MainNavigator {
  BaseNavigator createSubNavigator(Type parentScreen) {
    final subNavigator = MainNavigator(parentScreen, this);
    subNavigators[parentScreen] = subNavigator;
    return subNavigator;
  }

  void dispose() {
    for (final subNavigator in subNavigators.values) {
      subNavigator is MainNavigator ? subNavigator.dispose() : null;
    }
    parentNavigator?.subNavigators.remove(parentScreen);
    subNavigators.clear();
  }
}
