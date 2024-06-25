import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';
import 'package:flutter_navigation_generator/src/utils/case_utils.dart';
import 'package:flutter_navigation_generator/src/utils/utils.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

class OnGenerateRouteBuilder {
  final Set<RouteConfig> routes;
  final ImportableType? pageType;
  final Uri? targetFile;

  OnGenerateRouteBuilder({
    required this.routes,
    required this.pageType,
    required this.targetFile,
  });

  String _withPageType(RouteConfig route, String screen) {
    final pageClass = route.pageType != null
        ? typeRefer(route.pageType).symbol
        : pageType != null
            ? typeRefer(pageType).symbol
            : 'MaterialPageRoute';
    return '$pageClass<${typeRefer(route.returnType).symbol}>(builder: (_) => $screen, settings: settings, fullscreenDialog: ${route.isFullscreenDialog},)';
  }

  String _generateRoute(RouteConfig route) {
    final constructor = route.constructorName == route.routeWidget.className || route.constructorName.isEmpty
        ? route.routeWidget.className
        : '${route.routeWidget.className}.${route.constructorName}';
    final constructorCall = '$constructor(${route.parameters.asMap().map((_, p) {
          final nullableSuffix = p.isNullable ? '?' : '';
          final convertFromString = _convertFromString(p, 'arguments[\'${p.argumentName}\']');
          return MapEntry(
            p.argumentName,
            (p.className == 'Key' || p.className == 'String')
                ? "arguments['${p.argumentName}'] as ${typeRefer(p).symbol}$nullableSuffix"
                : "arguments['${p.argumentName}'] is String ? $convertFromString : arguments['${p.argumentName}'] as ${typeRefer(p).symbol}$nullableSuffix",
          );
        }).entries.map((e) => '${e.key}: ${e.value},').join('')})';
    return 'case RouteNames.${CaseUtil(route.routeName).camelCase}: return ${_withPageType(route, constructorCall)};';
  }

  Method generate() {
    final pageRoutes = routes.where((r) => r.generatePageRoute && r.navigationType != NavigationType.bottomSheet && r.navigationType != NavigationType.dialog);
    return Method(
      (m) => m
        ..name = 'onGenerateRoute'
        ..returns = const Reference('Route<dynamic>?')
        ..requiredParameters.add(
          Parameter(
            (p) => p
              ..name = 'settings'
              ..type = const Reference('RouteSettings'),
          ),
        )
        ..body = Block.of([
          if (pageRoutes.isNotEmpty) ...[
            const Code('''final arguments = settings.arguments is Map ? (settings.arguments as Map).cast<String, dynamic>() : <String, dynamic>{};
    final settingsUri = Uri.parse(settings.name ?? '');
    settingsUri.queryParameters.forEach((key, value) {
      arguments[key] ??= value;
    });'''),
            Code('switch (settingsUri.path) {${pageRoutes.map(_generateRoute).join('')}}'),
          ],
          const Code('return null;'),
        ]),
    );
  }

  String _convertFromString(ImportableType p, String s) {
    return switch (p.className) {
      'int' => 'int.parse($s)',
      'double' => 'double.parse($s)',
      'bool' => "$s == 'true'",
      'num' => 'num.parse($s)',
      'String' || 'dynamic' => s,
      'Map' => 'jsonDecode(utf8.decode(base64Decode($s)))',
      'List' => 'jsonDecode(utf8.decode(base64Decode($s)))',
      _ => '${p.className}.fromJson(jsonDecode(utf8.decode(base64Decode($s))))',
    };
  }
}
