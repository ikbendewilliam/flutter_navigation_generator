import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NativeRouteAnimation<T> extends PageRouteBuilder<T> {
  final Function(BuildContext context) builder;
  final bool iOSLinearTransition;

  NativeRouteAnimation({
    required this.builder,
    this.iOSLinearTransition = true,
    super.settings,
    super.fullscreenDialog,
    super.transitionDuration,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            if (kIsWeb) return child;
            if (Platform.isIOS || Platform.isMacOS) {
              return CupertinoPageTransition(
                primaryRouteAnimation: animation,
                secondaryRouteAnimation: secondaryAnimation,
                linearTransition: iOSLinearTransition,
                child: child,
              );
            }
            if (Platform.isAndroid) {
              return ZoomPageTransitionsBuilder().buildTransitions(
                null,
                context,
                animation,
                secondaryAnimation,
                child,
              );
            }
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
