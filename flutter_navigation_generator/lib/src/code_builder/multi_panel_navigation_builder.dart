import 'package:code_builder/code_builder.dart';

class MultiPanelNavigationBuilder {
  final bool createMultipanelNavigation;

  MultiPanelNavigationBuilder({required this.createMultipanelNavigation});

  Iterable<Field> generateFields() {
    if (!createMultipanelNavigation) return [];
    return [
      Field(
        (f) =>
            f
              ..name = 'multiPanels'
              ..modifier = FieldModifier.final$
              ..type = refer('Map<MultiPanelListener, String>')
              ..assignment = const Code('{}'),
      ),
    ];
  }

  Iterable<Method> generateMethods() {
    if (!createMultipanelNavigation) return [];
    return [
      Method(
        (b) =>
            b
              ..name = 'registerMultiPanel'
              ..returns = refer('void')
              ..docs.addAll([
                '/// Registers a panel. When navigating to a route that matches',
                '/// a child route of [screen], the [listener] will be notified',
                '/// to add the panel and navigation in the main navigator will be prevented.',
                '///',
                '/// Make sure to call [removePanel] when the panel is disposed.',
              ])
              ..optionalParameters.addAll([
                Parameter(
                  (p) =>
                      p
                        ..name = 'screen'
                        ..type = refer('String')
                        ..required = true
                        ..named = true,
                ),
                Parameter(
                  (p) =>
                      p
                        ..name = 'listener'
                        ..type = refer('MultiPanelListener')
                        ..required = true
                        ..named = true,
                ),
              ])
              ..body = const Code('multiPanels[listener] = screen;'),
      ),
      Method(
        (b) =>
            b
              ..name = 'removePanel'
              ..returns = refer('void')
              ..docs.addAll(['/// Removes a panel. Call this when the panel is disposed.'])
              ..requiredParameters.add(
                Parameter(
                  (p) =>
                      p
                        ..name = 'listener'
                        ..type = refer('MultiPanelListener'),
                ),
              )
              ..body = const Code('multiPanels.remove(listener);'),
      ),
      Method(
        (b) =>
            b
              ..name = '_navigateInMultiPanelOr'
              ..returns = refer('dynamic')
              ..docs.addAll(['/// Internal method to execute nativation ', '/// either inside a multipanel or regular.'])
              ..requiredParameters.addAll([
                Parameter(
                  (p) =>
                      p
                        ..name = 'action'
                        ..type = refer('dynamic Function()'),
                ),
                Parameter(
                  (p) =>
                      p
                        ..name = 'routeName'
                        ..type = refer('String'),
                ),
                Parameter(
                  (p) =>
                      p
                        ..name = 'arguments'
                        ..type = refer('Object?'),
                ),
              ])
              ..body = const Code('''for (final multiPanel in multiPanels.entries) {
  if (routeName == multiPanel.value || routeName.startsWith('\${multiPanel.value}/') == true) {
    final route = onGenerateRoute(RouteSettings(name: routeName, arguments: arguments));
    if (route is! PageRouteBuilder) continue;
    multiPanel.key.addPanel(
      route.pageBuilder(navigatorKey.currentContext!, const AlwaysStoppedAnimation(1), const AlwaysStoppedAnimation(1)),
      routeName,
    );
    return route.popped;
  }
}
return action();
'''),
      ),
    ];
  }

  List<Spec> generateClasses(String navigatorMixinName) {
    if (!createMultipanelNavigation) return [];
    return [
      Mixin(
        (b) =>
            b
              ..name = 'MultiPanelListener'
              ..methods.addAll([
                Method(
                  (b) =>
                      b
                        ..name = 'addPanel'
                        ..returns = refer('void')
                        ..requiredParameters.addAll([
                          Parameter(
                            (p) =>
                                p
                                  ..name = 'route'
                                  ..type = refer('Widget'),
                          ),
                          Parameter(
                            (p) =>
                                p
                                  ..name = 'routeName'
                                  ..type = refer('String'),
                          ),
                        ]),
                ),
              ]),
      ),
      Class(
        (b) =>
            b
              ..name = '_MultiPanelItem'
              ..fields.addAll([
                Field(
                  (f) =>
                      f
                        ..name = 'route'
                        ..type = refer('Widget')
                        ..modifier = FieldModifier.final$,
                ),
                Field(
                  (f) =>
                      f
                        ..name = 'routeName'
                        ..type = refer('String')
                        ..modifier = FieldModifier.final$,
                ),
              ])
              ..constructors.add(Constructor((c) => c..optionalParameters.addAll([_parameter('route'), _parameter('routeName')]))),
      ),
      Extension(
        (b) =>
            b
              ..name = 'I<T>'
              ..on = refer('Iterable<T>')
              ..methods.add(
                Method(
                  (b) =>
                      b
                        ..name = 'startsWith'
                        ..returns = refer('bool')
                        ..requiredParameters.add(
                          Parameter(
                            (p) =>
                                p
                                  ..name = 'other'
                                  ..type = refer('Iterable<T>'),
                          ),
                        )
                        ..body = const Code('''for (final (i, element) in indexed) {
  if (i >= other.length) return true;
  if (element != other.elementAt(i)) return false;
}
return false;'''),
                ),
              ),
      ),
      Class(
        (b) =>
            b
              ..name = 'MultiPanelNavigator'
              ..extend = refer('StatefulWidget')
              ..fields.addAll([
                _field(refer(navigatorMixinName), 'navigator'),
                _field(refer('String'), 'parentRoute'),
                _field(refer('int'), 'panels'),
                _field(const Reference('Widget Function(List<Widget?> screens)'), 'builder'),
              ])
              ..constructors.add(
                Constructor(
                  (c) =>
                      c
                        ..optionalParameters.addAll([
                          _parameter('navigator'),
                          _parameter('parentRoute'),
                          _parameter('panels'),
                          _parameter('builder'),
                          Parameter(
                            (b) =>
                                b
                                  ..toSuper = true
                                  ..name = 'key',
                          ),
                        ])
                        ..constant = true,
                ),
              )
              ..methods.add(
                Method(
                  (b) =>
                      b
                        ..annotations.add(const Reference('override'))
                        ..name = 'createState'
                        ..returns = TypeReference(
                          (t) =>
                              t
                                ..symbol = 'State'
                                ..types.add(refer('MultiPanelNavigator')),
                        )
                        ..lambda = true
                        ..body = const Code('MultiPanelNavigatorState()'),
                ),
              ),
      ),
      Class(
        (b) =>
            b
              ..name = 'MultiPanelNavigatorState'
              ..extend = TypeReference(
                (t) =>
                    t
                      ..symbol = 'State'
                      ..types.add(refer('MultiPanelNavigator')),
              )
              ..mixins.add(refer('MultiPanelListener'))
              ..fields.add(_field(const Reference('List<_MultiPanelItem>'), '_navigationStack', const Code('<_MultiPanelItem>[]')))
              ..methods.addAll([
                Method(
                  (b) =>
                      b
                        ..annotations.add(const Reference('override'))
                        ..name = 'initState'
                        ..returns = refer('void')
                        ..body = const Code('''super.initState();
widget.navigator.registerMultiPanel(
  screen: widget.parentRoute,
  listener: this,
);'''),
                ),
                Method(
                  (b) =>
                      b
                        ..annotations.add(const Reference('override'))
                        ..name = 'dispose'
                        ..returns = refer('void')
                        ..body = const Code('''widget.navigator.removePanel(this);
super.dispose();'''),
                ),
                Method(
                  (b) =>
                      b
                        ..annotations.add(const Reference('override'))
                        ..name = 'addPanel'
                        ..returns = refer('void')
                        ..requiredParameters.addAll([_typedParameter(refer('Widget'), 'route'), _typedParameter(refer('String'), 'routeName')])
                        ..body = const Code('''final splittedRouteName = routeName.split('/');
final firstDifferentIndex = _navigationStack.indexWhere((r) {
  return !splittedRouteName.startsWith(r.routeName.split('/'));
});
if (firstDifferentIndex != -1) {
  _navigationStack.removeRange(firstDifferentIndex, _navigationStack.length);
}
_navigationStack.add(
  _MultiPanelItem(
    route: route,
    routeName: routeName,
  ),
);
setState(() {});'''),
                ),
                Method(
                  (b) =>
                      b
                        ..annotations.add(const Reference('override'))
                        ..name = 'build'
                        ..returns = refer('Widget')
                        ..requiredParameters.addAll([_typedParameter(refer('BuildContext'), 'context')])
                        ..body = const Code('''final renderStack =
  _navigationStack.length <= widget.panels
        ? _navigationStack.cast<_MultiPanelItem?>().toList()
        : _navigationStack
              .cast<_MultiPanelItem?>()
              .skip(_navigationStack.length - widget.panels)
              .toList()
    ..addAll([
      for (var i = 0; i < widget.panels - _navigationStack.length; i++)
        null,
    ]);
return widget.builder(renderStack.map<Widget?>((e) => e?.route).toList());'''),
                ),
              ]),
      ),
    ];
  }
}

Field _field(Reference type, String name, [Code? assignment]) {
  return Field(
    (b) =>
        b
          ..name = name
          ..type = type
          ..modifier = FieldModifier.final$
          ..assignment = assignment,
  );
}

Parameter _parameter(String name, {bool required = true}) {
  return Parameter(
    (b) =>
        b
          ..name = name
          ..toThis = true
          ..required = required
          ..named = true,
  );
}

Parameter _typedParameter(Reference type, String name) {
  return Parameter(
    (b) =>
        b
          ..name = name
          ..type = type,
  );
}
