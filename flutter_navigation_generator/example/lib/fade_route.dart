import 'package:flutter/material.dart';

class FadeInRoute<T> extends PageRouteBuilder<T> {
  final Function(BuildContext context) builder;
  final Curve curve;

  FadeInRoute({
    required this.builder,
    this.curve = Curves.linear,
    super.settings,
    super.fullscreenDialog,
    super.transitionDuration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
