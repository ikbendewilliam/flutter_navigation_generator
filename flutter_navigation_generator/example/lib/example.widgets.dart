import 'dart:async';

import 'package:example/example.navigator.dart';
import 'package:flutter/material.dart';

class SubNavigator extends StatefulWidget {
  final Type parentScreen;
  final BaseNavigator parentNavigator;

  const SubNavigator({
    required this.parentScreen,
    required this.parentNavigator,
    super.key,
  });

  @override
  State<SubNavigator> createState() => _SubNavigatorState();
}

class _SubNavigatorState extends State<SubNavigator> {
  late final BaseNavigator subNavigator = widget.parentNavigator.createSubNavigator(
    parentScreen: widget.parentScreen,
  );

  @override
  void dispose() {
    subNavigator.dispose();
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

  const SubNavigatorListener({
    required this.parentScreen,
    required this.parentNavigator,
    required this.builder,
    super.key,
  });

  @override
  State<SubNavigatorListener> createState() => _SubNavigatorListenerState();
}

class _SubNavigatorListenerState extends State<SubNavigatorListener> {
  var _isActive = false;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.parentNavigator.subNavigatorStream(widget.parentScreen).listen(_onActiveChanged);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _onActiveChanged(bool isActive) {
    if (_isActive != isActive) {
      setState(() {
        _isActive = isActive;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _isActive,
    );
  }
}
