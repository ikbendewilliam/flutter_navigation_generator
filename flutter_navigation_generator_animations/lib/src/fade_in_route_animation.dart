import 'package:flutter/widgets.dart';

class FadeInRouteAnimation<T> extends PageRouteBuilder<T> {
  final Widget Function(BuildContext context) builder;

  FadeInRouteAnimation({
    required this.builder,
    super.settings,
    super.fullscreenDialog,
    super.transitionDuration,
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
