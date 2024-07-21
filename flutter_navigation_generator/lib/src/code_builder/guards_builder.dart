import 'package:code_builder/code_builder.dart';

class GuardsBuilder {
  List<Method> generate() {
    return [
      Method(
        (b) => b
          ..name = 'updateGuard'
          ..returns = refer('Future<void>')
          ..types.add(const Reference('T extends NavigatorGuard'))
          ..docs.add('/// Update a specific guard, useful for events (for example after login/logout)')
          ..lambda = true
          ..body = const Code('guards.whereType<T>().first.updateValue()'),
      ),
      Method(
        (b) => b
          ..name = 'updateGuards'
          ..returns = refer('Future<void>')
          ..docs.add('/// Update all guards, useful for web apps. Add to main file so it\'s called when navigating manually')
          ..lambda = true
          ..body = const Code('Future.wait(guards.map((e) => e.updateValue()))'),
      ),
    ];
  }
}
