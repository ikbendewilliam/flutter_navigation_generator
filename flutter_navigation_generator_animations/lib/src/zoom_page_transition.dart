// Copied from page_transitions_theme from Flutter SDK

import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ZoomPageTransition extends StatelessWidget {
  /// Creates a [ZoomPageTransition].
  ///
  /// The [animation] and [secondaryAnimation] arguments are required and must
  /// not be null.
  const ZoomPageTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.allowSnapshotting,
    required this.allowEnterRouteSnapshotting,
    this.child,
  });

  // A curve sequence that is similar to the 'fastOutExtraSlowIn' curve used in
  // the native transition.
  static final List<TweenSequenceItem<double>>
      fastOutExtraSlowInTweenSequenceItems = <TweenSequenceItem<double>>[
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.0, end: 0.4)
          .chain(CurveTween(curve: const Cubic(0.05, 0.0, 0.133333, 0.06))),
      weight: 0.166666,
    ),
    TweenSequenceItem<double>(
      tween: Tween<double>(begin: 0.4, end: 1.0)
          .chain(CurveTween(curve: const Cubic(0.208333, 0.82, 0.25, 1.0))),
      weight: 1.0 - 0.166666,
    ),
  ];
  static final TweenSequence<double> _scaleCurveSequence =
      TweenSequence<double>(fastOutExtraSlowInTweenSequenceItems);

  /// The animation that drives the [child]'s entrance and exit.
  ///
  /// See also:
  ///
  ///  * [TransitionRoute.animation], which is the value given to this property
  ///    when the [ZoomPageTransition] is used as a page transition.
  final Animation<double> animation;

  /// The animation that transitions [child] when new content is pushed on top
  /// of it.
  ///
  /// See also:
  ///
  ///  * [TransitionRoute.secondaryAnimation], which is the value given to this
  ///    property when the [ZoomPageTransition] is used as a page transition.
  final Animation<double> secondaryAnimation;

  /// Whether the [SnapshotWidget] will be used.
  ///
  /// When this value is true, performance is improved by disabling animations
  /// on both the outgoing and incoming route. This also implies that ink-splashes
  /// or similar animations will not animate during the transition.
  ///
  /// See also:
  ///
  ///  * [TransitionRoute.allowSnapshotting], which defines whether the route
  ///    transition will prefer to animate a snapshot of the entering and exiting
  ///    routes.
  final bool allowSnapshotting;

  /// The widget below this widget in the tree.
  ///
  /// This widget will transition in and out as driven by [animation] and
  /// [secondaryAnimation].
  final Widget? child;

  /// Whether to enable snapshotting on the entering route during the
  /// transition animation.
  ///
  /// If not specified, defaults to true.
  /// If false, the route snapshotting will not be applied to the route being
  /// animating into, e.g. when transitioning from route A to route B, B will
  /// not be snapshotted.
  final bool allowEnterRouteSnapshotting;

  @override
  Widget build(BuildContext context) {
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _ZoomEnterTransition(
          animation: animation,
          allowSnapshotting: allowSnapshotting && allowEnterRouteSnapshotting,
          child: child,
        );
      },
      reverseBuilder: (
        BuildContext context,
        Animation<double> animation,
        Widget? child,
      ) {
        return _ZoomExitTransition(
          animation: animation,
          allowSnapshotting: allowSnapshotting,
          reverse: true,
          child: child,
        );
      },
      child: DualTransitionBuilder(
        animation: ReverseAnimation(secondaryAnimation),
        forwardBuilder: (
          BuildContext context,
          Animation<double> animation,
          Widget? child,
        ) {
          return _ZoomEnterTransition(
            animation: animation,
            allowSnapshotting: allowSnapshotting && allowEnterRouteSnapshotting,
            reverse: true,
            child: child,
          );
        },
        reverseBuilder: (
          BuildContext context,
          Animation<double> animation,
          Widget? child,
        ) {
          return _ZoomExitTransition(
            animation: animation,
            allowSnapshotting: allowSnapshotting,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}

class _ZoomEnterTransition extends StatefulWidget {
  const _ZoomEnterTransition({
    required this.animation,
    this.reverse = false,
    required this.allowSnapshotting,
    this.child,
  });

  final Animation<double> animation;
  final Widget? child;
  final bool allowSnapshotting;
  final bool reverse;

  @override
  State<_ZoomEnterTransition> createState() => _ZoomEnterTransitionState();
}

class _ZoomEnterTransitionState extends State<_ZoomEnterTransition>
    with _ZoomTransitionBase<_ZoomEnterTransition> {
  // See SnapshotWidget doc comment, this is disabled on web because the HTML backend doesn't
  // support this functionality and the canvaskit backend uses a single thread for UI and raster
  // work which diminishes the impact of this performance improvement.
  @override
  bool get useSnapshot => !kIsWeb && widget.allowSnapshotting;

  late _ZoomEnterTransitionPainter delegate;

  static final Animatable<double> _fadeInTransition = Tween<double>(
    begin: 0.0,
    end: 1.00,
  ).chain(CurveTween(curve: const Interval(0.125, 0.250)));

  static final Animatable<double> _scaleDownTransition = Tween<double>(
    begin: 1.10,
    end: 1.00,
  ).chain(ZoomPageTransition._scaleCurveSequence);

  static final Animatable<double> _scaleUpTransition = Tween<double>(
    begin: 0.85,
    end: 1.00,
  ).chain(ZoomPageTransition._scaleCurveSequence);

  static final Animatable<double?> _scrimOpacityTween = Tween<double?>(
    begin: 0.0,
    end: 0.60,
  ).chain(CurveTween(curve: const Interval(0.2075, 0.4175)));

  void _updateAnimations() {
    fadeTransition = widget.reverse
        ? kAlwaysCompleteAnimation
        : _fadeInTransition.animate(widget.animation);

    scaleTransition =
        (widget.reverse ? _scaleDownTransition : _scaleUpTransition)
            .animate(widget.animation);

    widget.animation.addListener(onAnimationValueChange);
    widget.animation.addStatusListener(onAnimationStatusChange);
  }

  @override
  void initState() {
    _updateAnimations();
    delegate = _ZoomEnterTransitionPainter(
      reverse: widget.reverse,
      fade: fadeTransition,
      scale: scaleTransition,
      animation: widget.animation,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _ZoomEnterTransition oldWidget) {
    if (oldWidget.reverse != widget.reverse ||
        oldWidget.animation != widget.animation) {
      oldWidget.animation.removeListener(onAnimationValueChange);
      oldWidget.animation.removeStatusListener(onAnimationStatusChange);
      _updateAnimations();
      delegate.dispose();
      delegate = _ZoomEnterTransitionPainter(
        reverse: widget.reverse,
        fade: fadeTransition,
        scale: scaleTransition,
        animation: widget.animation,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.animation.removeListener(onAnimationValueChange);
    widget.animation.removeStatusListener(onAnimationStatusChange);
    delegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SnapshotWidget(
      painter: delegate,
      controller: controller,
      mode: SnapshotMode.permissive,
      autoresize: true,
      child: widget.child,
    );
  }
}

class _ZoomExitTransition extends StatefulWidget {
  const _ZoomExitTransition({
    required this.animation,
    this.reverse = false,
    required this.allowSnapshotting,
    this.child,
  });

  final Animation<double> animation;
  final bool allowSnapshotting;
  final bool reverse;
  final Widget? child;

  @override
  State<_ZoomExitTransition> createState() => _ZoomExitTransitionState();
}

class _ZoomExitTransitionState extends State<_ZoomExitTransition>
    with _ZoomTransitionBase<_ZoomExitTransition> {
  late _ZoomExitTransitionPainter delegate;

  // See SnapshotWidget doc comment, this is disabled on web because the HTML backend doesn't
  // support this functionality and the canvaskit backend uses a single thread for UI and raster
  // work which diminishes the impact of this performance improvement.
  @override
  bool get useSnapshot => !kIsWeb && widget.allowSnapshotting;

  static final Animatable<double> _fadeOutTransition = Tween<double>(
    begin: 1.0,
    end: 0.0,
  ).chain(CurveTween(curve: const Interval(0.0825, 0.2075)));

  static final Animatable<double> _scaleUpTransition = Tween<double>(
    begin: 1.00,
    end: 1.05,
  ).chain(ZoomPageTransition._scaleCurveSequence);

  static final Animatable<double> _scaleDownTransition = Tween<double>(
    begin: 1.00,
    end: 0.90,
  ).chain(ZoomPageTransition._scaleCurveSequence);

  void _updateAnimations() {
    fadeTransition = widget.reverse
        ? _fadeOutTransition.animate(widget.animation)
        : kAlwaysCompleteAnimation;
    scaleTransition =
        (widget.reverse ? _scaleDownTransition : _scaleUpTransition)
            .animate(widget.animation);

    widget.animation.addListener(onAnimationValueChange);
    widget.animation.addStatusListener(onAnimationStatusChange);
  }

  @override
  void initState() {
    _updateAnimations();
    delegate = _ZoomExitTransitionPainter(
      reverse: widget.reverse,
      fade: fadeTransition,
      scale: scaleTransition,
      animation: widget.animation,
    );
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _ZoomExitTransition oldWidget) {
    if (oldWidget.reverse != widget.reverse ||
        oldWidget.animation != widget.animation) {
      oldWidget.animation.removeListener(onAnimationValueChange);
      oldWidget.animation.removeStatusListener(onAnimationStatusChange);
      _updateAnimations();
      delegate.dispose();
      delegate = _ZoomExitTransitionPainter(
        reverse: widget.reverse,
        fade: fadeTransition,
        scale: scaleTransition,
        animation: widget.animation,
      );
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.animation.removeListener(onAnimationValueChange);
    widget.animation.removeStatusListener(onAnimationStatusChange);
    delegate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SnapshotWidget(
      painter: delegate,
      controller: controller,
      mode: SnapshotMode.permissive,
      autoresize: true,
      child: widget.child,
    );
  }
}

mixin _ZoomTransitionBase<S extends StatefulWidget> on State<S> {
  bool get useSnapshot;

  // Don't rasterize if:
  // 1. Rasterization is disabled by the platform.
  // 2. The animation is paused/stopped.
  // 3. The values of the scale/fade transition do not
  //    benefit from rasterization.
  final SnapshotController controller = SnapshotController();

  late Animation<double> fadeTransition;
  late Animation<double> scaleTransition;

  void onAnimationValueChange() {
    if ((scaleTransition.value == 1.0) &&
        (fadeTransition.value == 0.0 || fadeTransition.value == 1.0)) {
      controller.allowSnapshotting = false;
    } else {
      controller.allowSnapshotting = useSnapshot;
    }
  }

  void onAnimationStatusChange(AnimationStatus status) {
    controller.allowSnapshotting = switch (status) {
      AnimationStatus.dismissed || AnimationStatus.completed => false,
      AnimationStatus.forward || AnimationStatus.reverse => useSnapshot,
    };
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class _ZoomEnterTransitionPainter extends SnapshotPainter {
  _ZoomEnterTransitionPainter({
    required this.reverse,
    required this.scale,
    required this.fade,
    required this.animation,
  }) {
    animation.addListener(notifyListeners);
    animation.addStatusListener(_onStatusChange);
    scale.addListener(notifyListeners);
    fade.addListener(notifyListeners);
  }

  void _onStatusChange(_) {
    notifyListeners();
  }

  final bool reverse;
  final Animation<double> animation;
  final Animation<double> scale;
  final Animation<double> fade;

  final Matrix4 _transform = Matrix4.zero();
  final LayerHandle<OpacityLayer> _opacityHandle = LayerHandle<OpacityLayer>();
  final LayerHandle<TransformLayer> _transformHandler =
      LayerHandle<TransformLayer>();

  void _drawScrim(PaintingContext context, Offset offset, Size size) {
    double scrimOpacity = 0.0;
    // The transition's scrim opacity only increases on the forward transition.
    // In the reverse transition, the opacity should always be 0.0.
    //
    // Therefore, we need to only apply the scrim opacity animation when
    // the transition is running forwards.
    //
    // The reason that we check that the animation's status is not `completed`
    // instead of checking that it is `forward` is that this allows
    // the interrupted reversal of the forward transition to smoothly fade
    // the scrim away. This prevents a disjointed removal of the scrim.
    if (!reverse && animation.status != AnimationStatus.completed) {
      scrimOpacity =
          _ZoomEnterTransitionState._scrimOpacityTween.evaluate(animation)!;
    }
    assert(!reverse || scrimOpacity == 0.0);
    if (scrimOpacity > 0.0) {
      context.canvas.drawRect(
        offset & size,
        Paint()..color = Colors.black.withOpacity(scrimOpacity),
      );
    }
  }

  @override
  void paint(PaintingContext context, ui.Offset offset, Size size,
      PaintingContextCallback painter) {
    switch (animation.status) {
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        return painter(context, offset);
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
    }

    _drawScrim(context, offset, size);
    _updateScaledTransform(_transform, scale.value, size);
    _transformHandler.layer = context.pushTransform(true, offset, _transform,
        (PaintingContext context, Offset offset) {
      _opacityHandle.layer = context.pushOpacity(
          offset, (fade.value * 255).round(), painter,
          oldLayer: _opacityHandle.layer);
    }, oldLayer: _transformHandler.layer);
  }

  @override
  void paintSnapshot(PaintingContext context, Offset offset, Size size,
      ui.Image image, Size sourceSize, double pixelRatio) {
    _drawScrim(context, offset, size);
    _drawImageScaledAndCentered(
        context, image, scale.value, fade.value, pixelRatio);
  }

  @override
  void dispose() {
    animation.removeListener(notifyListeners);
    animation.removeStatusListener(_onStatusChange);
    scale.removeListener(notifyListeners);
    fade.removeListener(notifyListeners);
    _opacityHandle.layer = null;
    _transformHandler.layer = null;
    super.dispose();
  }

  @override
  bool shouldRepaint(covariant _ZoomEnterTransitionPainter oldDelegate) {
    return oldDelegate.reverse != reverse ||
        oldDelegate.animation.value != animation.value ||
        oldDelegate.scale.value != scale.value ||
        oldDelegate.fade.value != fade.value;
  }
}

class _ZoomExitTransitionPainter extends SnapshotPainter {
  _ZoomExitTransitionPainter({
    required this.reverse,
    required this.scale,
    required this.fade,
    required this.animation,
  }) {
    scale.addListener(notifyListeners);
    fade.addListener(notifyListeners);
    animation.addStatusListener(_onStatusChange);
  }

  void _onStatusChange(_) {
    notifyListeners();
  }

  final bool reverse;
  final Animation<double> scale;
  final Animation<double> fade;
  final Animation<double> animation;
  final Matrix4 _transform = Matrix4.zero();
  final LayerHandle<OpacityLayer> _opacityHandle = LayerHandle<OpacityLayer>();
  final LayerHandle<TransformLayer> _transformHandler =
      LayerHandle<TransformLayer>();

  @override
  void paintSnapshot(PaintingContext context, Offset offset, Size size,
      ui.Image image, Size sourceSize, double pixelRatio) {
    _drawImageScaledAndCentered(
        context, image, scale.value, fade.value, pixelRatio);
  }

  @override
  void paint(PaintingContext context, ui.Offset offset, Size size,
      PaintingContextCallback painter) {
    switch (animation.status) {
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        return painter(context, offset);
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        break;
    }

    _updateScaledTransform(_transform, scale.value, size);
    _transformHandler.layer = context.pushTransform(true, offset, _transform,
        (PaintingContext context, Offset offset) {
      _opacityHandle.layer = context.pushOpacity(
          offset, (fade.value * 255).round(), painter,
          oldLayer: _opacityHandle.layer);
    }, oldLayer: _transformHandler.layer);
  }

  @override
  bool shouldRepaint(covariant _ZoomExitTransitionPainter oldDelegate) {
    return oldDelegate.reverse != reverse ||
        oldDelegate.fade.value != fade.value ||
        oldDelegate.scale.value != scale.value;
  }

  @override
  void dispose() {
    _opacityHandle.layer = null;
    _transformHandler.layer = null;
    scale.removeListener(notifyListeners);
    fade.removeListener(notifyListeners);
    animation.removeStatusListener(_onStatusChange);
    super.dispose();
  }
}

void _drawImageScaledAndCentered(PaintingContext context, ui.Image image,
    double scale, double opacity, double pixelRatio) {
  if (scale <= 0.0 || opacity <= 0.0) {
    return;
  }
  final Paint paint = Paint()
    ..filterQuality = ui.FilterQuality.low
    ..color = Color.fromRGBO(0, 0, 0, opacity);
  final double logicalWidth = image.width / pixelRatio;
  final double logicalHeight = image.height / pixelRatio;
  final double scaledLogicalWidth = logicalWidth * scale;
  final double scaledLogicalHeight = logicalHeight * scale;
  final double left = (logicalWidth - scaledLogicalWidth) / 2;
  final double top = (logicalHeight - scaledLogicalHeight) / 2;
  final Rect dst =
      Rect.fromLTWH(left, top, scaledLogicalWidth, scaledLogicalHeight);
  context.canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      dst,
      paint);
}

void _updateScaledTransform(Matrix4 transform, double scale, Size size) {
  transform.setIdentity();
  if (scale == 1.0) {
    return;
  }
  transform.scale(scale, scale);
  final double dx = ((size.width * scale) - size.width) / 2;
  final double dy = ((size.height * scale) - size.height) / 2;
  transform.translate(-dx, -dy);
}
