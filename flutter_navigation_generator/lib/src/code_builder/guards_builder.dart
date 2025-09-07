import 'package:code_builder/code_builder.dart';

class GuardsBuilder {
  List<Method> generate() {
    return [
      Method(
        (b) =>
            b
              ..name = 'updateGuard'
              ..returns = refer('Future<void>')
              ..types.add(const Reference('T extends NavigatorGuard'))
              ..docs.add(
                '/// Update a specific guard, useful for events (for example after login/logout)',
              )
              ..lambda = true
              ..body = const Code('guards.whereType<T>().first.updateValue()'),
      ),
      Method(
        (b) =>
            b
              ..name = 'updateGuards'
              ..returns = refer('Future<void>')
              ..docs.add(
                '/// Update all guards, useful for web apps. Add to main file so it\'s called when navigating manually',
              )
              ..lambda = true
              ..body = const Code(
                'Future.wait(guards.map((e) => e.updateValue()))',
              ),
      ),
      Method(
        (b) =>
            b
              ..name = 'continueNavigation'
              ..returns = refer('Future<void>')
              ..docs.add(
                '/// Continues navigation. A guard will reroute navigation to a page. Call this method to continue navigation after the guard has rerouted',
              )
              ..docs.add('/// ')
              ..docs.add('/// Example: ')
              ..docs.add('/// ```dart')
              ..docs.add('/// Future<void> login(details) async {')
              ..docs.add('///  ...do login')
              ..docs.add('///  await navigator.updateGuard<LoginGuard>();')
              ..docs.add(
                '///  if (navigator.canContinueNavigation) return navigator.continueNavigation();',
              )
              ..docs.add('///  return navigator.goToHome();')
              ..docs.add('/// }')
              ..docs.add('/// ```')
              ..modifier = MethodModifier.async
              ..body = Block.of([
                const Code('final settings = guardedRouteSettings;'),
                const Code('if (settings == null) return;'),
                const Code('guardedRouteSettings = null;'),
                const Code(
                  'return navigatorKey.currentState?.pushReplacementNamed<void, dynamic>(settings.name!, arguments: settings.arguments);',
                ),
              ]),
      ),
      Method(
        (b) =>
            b
              ..name = 'canContinueNavigation'
              ..returns = refer('bool')
              ..docs.add(
                '/// Whether we can continues navigation. A guard will reroute navigation to a page. Call this method to continue navigation after the guard has rerouted',
              )
              ..docs.add('/// ')
              ..docs.add('/// Example: ')
              ..docs.add('/// ```dart')
              ..docs.add('/// Future<void> login(details) async {')
              ..docs.add('///  ...do login')
              ..docs.add('///  await navigator.updateGuard<LoginGuard>();')
              ..docs.add(
                '///  if (navigator.canContinueNavigation) return navigator.continueNavigation();',
              )
              ..docs.add('///  return navigator.goToHome();')
              ..docs.add('/// }')
              ..docs.add('/// ```')
              ..lambda = true
              ..body = const Code('guardedRouteSettings != null'),
      ),
    ];
  }
}
