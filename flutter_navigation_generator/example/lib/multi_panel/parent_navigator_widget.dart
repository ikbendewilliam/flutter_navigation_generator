import 'package:example/example.navigator.dart';
import 'package:flutter/material.dart';

class ParentNavigatorWidget extends StatefulWidget {
  final int panels;
  final BaseNavigator navigator;
  final String parentRoute;

  const ParentNavigatorWidget({
    required this.panels,
    required this.navigator,
    required this.parentRoute,
    super.key,
  });

  @override
  State<ParentNavigatorWidget> createState() => _ParentNavigatorWidgetState();
}

class _ParentNavigatorWidgetState extends State<ParentNavigatorWidget> {
  final _screensPoppedToTheLeft = <Widget>[];
  final _previousScreens = <Widget>[];

  void _prepareAnimations(List<Widget> screens) {
    _checkPopLeft(screens);
    _previousScreens
      ..clear()
      ..addAll(screens);
  }

  void _checkPopLeft(List<Widget> screens) {
    if (_previousScreens.length < 2) return;
    final secondOldScreen = _previousScreens[1];
    if (screens.first == secondOldScreen) {
      _popLeft(_previousScreens.first);
    }
  }

  void _popLeft(Widget screen) {
    _screensPoppedToTheLeft.add(screen);
    Future.delayed(Durations.medium1, () => _screensPoppedToTheLeft.remove(screen));
  }

  @override
  Widget build(BuildContext context) {
    return MultiPanelNavigator(
      parentRoute: widget.parentRoute,
      panels: widget.panels,
      navigator: widget.navigator,
      builder: (screens) {
        screens = screens.nonNulls.toList();
        _prepareAnimations(screens as List<Widget>);
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth / (screens.length + 4);
            return Stack(
              children: [
                for (final screen in _screensPoppedToTheLeft) ...[
                  AnimatedPositioned(
                    duration: Durations.medium1,
                    key: ValueKey(screen.hashCode),
                    left: -width,
                    top: 0,
                    bottom: 0,
                    width: width,
                    child: screen,
                  ),
                ],
                for (final (index, screen) in screens.indexed.toList().reversed) ...[
                  AnimatedPositioned(
                    duration: Durations.medium1,
                    key: ValueKey(screen.hashCode),
                    left: width * index,
                    top: 0,
                    bottom: 0,
                    width: index == screens.length - 1 ? width * 5 : width,
                    child: screen ?? const SizedBox.shrink(),
                  ),
                ],
              ],
            );
          },
        );
      },
    );
  }
}
