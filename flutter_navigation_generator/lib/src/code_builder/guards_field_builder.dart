import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';

class GuardsFieldBuilder {
  final Set<RouteConfig> routes;
  final Uri? targetFile;

  GuardsFieldBuilder({required this.routes, required this.targetFile});

  Field generate() => Field(
        (f) => f
          ..name = 'guards'
          ..type = refer('Set<NavigatorGuard>')
          ..modifier = FieldModifier.final$
          ..assignment = Code(
              "<NavigatorGuard>{${routes.expand((r) => r.guards).toSet().map((g) => '${typeRefer(g, targetFile: targetFile).symbol}()').toSet().toList().join(',')}}"),
      );
}
