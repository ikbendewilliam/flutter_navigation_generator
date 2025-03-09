import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_navigation_generator_animations/src/zoom_page_transition.dart';

class NativeRouteAnimation<T> extends PageRouteBuilder<T> {
  final Widget Function(BuildContext context) builder;
  final bool iOSLinearTransition;
  final bool androidAllowSnapshotting;
  final bool androidAllowEnterRouteSnapshotting;

  NativeRouteAnimation({
    required this.builder,
    this.iOSLinearTransition = true,
    this.androidAllowSnapshotting = true,
    this.androidAllowEnterRouteSnapshotting = true,
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
              return ZoomPageTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                allowSnapshotting: androidAllowSnapshotting,
                allowEnterRouteSnapshotting: androidAllowEnterRouteSnapshotting,
                child: child,
              );
            }
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        );
}
