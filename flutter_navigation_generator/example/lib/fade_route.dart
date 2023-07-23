import 'package:flutter/material.dart';

class FadeInRoute<T> extends PageRouteBuilder<T> {
  final Function(BuildContext context) builder;
  final Curve curve;
  final Duration duration;

  FadeInRoute({
    required this.builder,
    this.curve = Curves.linear,
    RouteSettings? settings,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => builder(context),
          settings: settings,
          transitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) => FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
