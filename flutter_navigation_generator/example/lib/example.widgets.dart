import 'package:example/example.navigator.dart';
import 'package:flutter/material.dart';

class MultiPanelNavigator extends StatefulWidget {
  final MultiPanelNavigation navigator;
  final String parentRoute;
  final int panels;
  final Axis direction;
  final Widget Function()? emptyPanelBuilder;
  final Widget Function()? separatorBuilder;

  const MultiPanelNavigator({
    required this.parentRoute,
    required this.navigator,
    required this.panels,
    this.direction = Axis.horizontal,
    this.emptyPanelBuilder,
    this.separatorBuilder,
    super.key,
  });

  @override
  State<MultiPanelNavigator> createState() => _MultiPanelNavigatorState();
}

class _MultiPanelNavigatorState extends State<MultiPanelNavigator> with MultiPanelListener {
  final _navigationStack = <_MultiPanelItem>[];

  @override
  void initState() {
    super.initState();
    widget.navigator.registerMultiPanel(
      screen: widget.parentRoute,
      listener: this,
    );
  }

  @override
  void dispose() {
    widget.navigator.removePanel(this);
    super.dispose();
  }

  @override
  void addPanel(Widget route, String routeName) {
    final splittedRouteName = routeName.split('/');
    final firstDifferentIndex = _navigationStack.indexWhere((r) {
      final splitted = r.routeName.split('/');
      final startsWith = splittedRouteName.startsWith(splitted);
      print('comparing \n$splittedRouteName with \n$splitted, startsWith: $startsWith');
      return !startsWith;
    });
    print('firstDifferentIndex: $firstDifferentIndex');
    if (firstDifferentIndex != -1) {
      _navigationStack.removeRange(firstDifferentIndex, _navigationStack.length);
    }
    _navigationStack.add(
      _MultiPanelItem(
        route: route,
        routeName: routeName,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final renderStack = _navigationStack.length <= widget.panels ? _navigationStack : _navigationStack.skip(_navigationStack.length - widget.panels).toList();
    return Flex(
      direction: widget.direction,
      children: List.generate(widget.panels, (index) {
        final Widget child;
        if (renderStack.length <= index) {
          child =
              widget.emptyPanelBuilder?.call() ??
              const Expanded(
                child: SizedBox.shrink(),
              );
        } else {
          child = Expanded(
            child: renderStack[index].route,
          );
        }
        return [
          child,
          if (index < widget.panels - 1)
            widget.separatorBuilder?.call() ?? (widget.direction == Axis.horizontal ? const VerticalDivider(width: 1, thickness: 1) : const Divider(height: 1)),
        ];
      }).expand((e) => e).toList(),
    );
  }
}

mixin MultiPanelNavigation on BaseNavigator {
  final multiPanels = <MultiPanelListener, String>{};

  void registerMultiPanel({
    required String screen,
    required MultiPanelListener listener,
  }) {
    multiPanels[listener] = screen;
  }

  void removePanel(MultiPanelListener listener) {
    multiPanels.remove(listener);
  }

  // @override
  // Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  //   print('onGenerateRoute: ${settings.name}');
  //   for (final multiPanel in multiPanels.entries) {
  //     if (settings.name == multiPanel.value || settings.name?.startsWith('${multiPanel.value}/') == true) {
  //       final route = super.onGenerateRoute(settings);
  //       if (route is! PageRouteBuilder) continue;
  //       multiPanel.key.addPanel(
  //         route.pageBuilder(navigatorKey.currentContext!, const AlwaysStoppedAnimation(1), const AlwaysStoppedAnimation(1)),
  //         settings.name!,
  //       );
  //       return null;
  //     }
  //   }
  //   return super.onGenerateRoute(settings);
  // }

  dynamic navigateInMultiPanelOr(dynamic Function() action, String routeName) {
    for (final multiPanel in multiPanels.entries) {
      if (routeName == multiPanel.value || routeName.startsWith('${multiPanel.value}/') == true) {
        final route = onGenerateRoute(RouteSettings(name: routeName));
        if (route is! PageRouteBuilder) continue;
        multiPanel.key.addPanel(
          route.pageBuilder(navigatorKey.currentContext!, const AlwaysStoppedAnimation(1), const AlwaysStoppedAnimation(1)),
          routeName,
        );
        return route.popped;
      }
    }
    return action();
  }

  @override
  Future<void> goToDepth0Page() => navigateInMultiPanelOr(super.goToDepth0Page, RouteNames.parentDepth0);
  @override
  Future<void> goToDepth1Page1() => navigateInMultiPanelOr(super.goToDepth1Page1, RouteNames.parentDepth0Depth1Page1);
  @override
  Future<void> goToDepth1Page2() => navigateInMultiPanelOr(super.goToDepth1Page2, RouteNames.parentDepth0Depth1Page2);
  @override
  Future<void> goToDepth1Page3() => navigateInMultiPanelOr(super.goToDepth1Page3, RouteNames.parentDepth0Depth1Page3);
  @override
  Future<void> goToDepth2Page11() => navigateInMultiPanelOr(super.goToDepth2Page11, RouteNames.parentDepth0Depth1Page1Depth2Page1);
  @override
  Future<void> goToDepth2Page12() => navigateInMultiPanelOr(super.goToDepth2Page12, RouteNames.parentDepth0Depth1Page1Depth2Page2);
  @override
  Future<void> goToDepth3Page111() => navigateInMultiPanelOr(super.goToDepth3Page111, RouteNames.parentDepth0Depth1Page1Depth2Page1Depth3Page1);
  @override
  Future<void> goToDepth3Page112() => navigateInMultiPanelOr(super.goToDepth3Page112, RouteNames.parentDepth0Depth1Page1Depth2Page1Depth3Page2);
  @override
  Future<void> goToDepth3Page113() => navigateInMultiPanelOr(super.goToDepth3Page113, RouteNames.parentDepth0Depth1Page1Depth2Page1Depth3Page3);
  @override
  Future<void> goToDepth3Page121() => navigateInMultiPanelOr(super.goToDepth3Page121, RouteNames.parentDepth0Depth1Page1Depth2Page2Depth3Page1);
  @override
  Future<void> goToDepth3Page122() => navigateInMultiPanelOr(super.goToDepth3Page122, RouteNames.parentDepth0Depth1Page1Depth2Page2Depth3Page2);
  @override
  Future<void> goToDepth3Page123() => navigateInMultiPanelOr(super.goToDepth3Page123, RouteNames.parentDepth0Depth1Page1Depth2Page2Depth3Page3);
}

mixin MultiPanelListener {
  void addPanel(Widget route, String routeName);
}

class _MultiPanelItem {
  final Widget route;
  final String routeName;

  _MultiPanelItem({
    required this.route,
    required this.routeName,
  });
}

extension E<T> on Iterable<T> {
  bool startsWith(Iterable<T> other) {
    for (final (i, element) in indexed) {
      if (i >= other.length) return true;
      if (element != other.elementAt(i)) return false;
    }
    return false;
  }
}
