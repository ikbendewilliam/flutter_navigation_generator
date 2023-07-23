import 'package:code_builder/code_builder.dart';
import 'package:flutter_navigation_generator/src/code_builder/on_generate_route_builder.dart';
import 'package:flutter_navigation_generator/src/models/importable_type.dart';
import 'package:flutter_navigation_generator/src/models/route_config.dart';

class NavigatorBuilder {
  static Field buildNavigatorKey() {
    return Field(
      (f) => f
        ..name = 'navigatorKey'
        ..type = const Reference('GlobalKey<NavigatorState>')
        ..modifier = FieldModifier.final$
        ..assignment = const Code('GlobalKey<NavigatorState>()'),
    );
  }

  static Spec buildNavigator({
    required Set<RouteConfig> routes,
    required String className,
    required Uri? targetFile,
    required ImportableType? pageType,
  }) {
    return Mixin(
      (b) => b
        ..name = className
        ..fields.add(buildNavigatorKey())
        ..methods.add(
          OnGenerateRouteBuilder(
            routes: routes,
            pageType: pageType,
            targetFile: targetFile,
          ).generate(),
        ),
    );

    // final navigatorIdParameter = Parameter(
    //   (b) => b
    //     ..name = 'navigatorId'
    //     ..named = true
    //     ..type = const Reference('int?'),
    // );
    // final navigatorKeyParameter = Parameter(
    //   (b) => b
    //     ..name = 'navigatorKey'
    //     ..named = true
    //     ..type = TypeReference(
    //       (b) => b
    //         ..symbol = 'GlobalKey'
    //         ..url = 'package:flutter/material.dart'
    //         ..isNullable = true
    //         ..types.add(const Reference('NavigatorState', 'package:flutter/material.dart')),
    //     ),
    // );

    // return Mixin((b) => b
    //   ..name = className
    //   ..methods.addAll(routes.where((route) => route.generateMethod && route.navigationType != NavigationType.dialog).map((route) {
    //     final bodyCall = TypeReference(
    //       (b) => b
    //         ..symbol = 'Get.${route.navigationTypeAsString}'
    //         ..types.add(const Reference('dynamic')),
    //     ).call(
    //       [
    //         Reference('RouteNames.${CaseUtil(route.routeName).camelCase}'),
    //       ],
    //       {
    //         'id': const Reference('navigatorId'),
    //         'arguments': Reference('${route.parameters.asMap().map((_, p) => MapEntry("'${p.argumentName}'", p.argumentName))}'),
    //         if (route.navigationType == NavigationType.push) ...{
    //           'preventDuplicates': literalBool(route.preventDuplicates),
    //         },
    //       },
    //     );
    //     Code body;
    //     if (route.returnType != null) {
    //       body = Block((b) => b
    //         ..statements.add(declareFinal('result', type: const Reference('dynamic')).assign(bodyCall.awaited).statement)
    //         ..statements.add(const Reference('result').asA(typeRefer(route.returnType, targetFile: targetFile, forceNullable: true)).returned.statement));
    //     } else {
    //       body = bodyCall.code;
    //     }
    //     return Method(
    //       (b) {
    //         final isAsync = route.navigationType.isAsync || route.returnType != null;
    //         b
    //           ..name = 'goTo${CaseUtil(route.routeName).upperCamelCase}'
    //           ..lambda = route.returnType == null
    //           ..modifier = isAsync ? MethodModifier.async : null
    //           ..optionalParameters.addAll(route.parameters.map((p) {
    //             return Parameter(
    //               (b) => b
    //                 ..name = p.argumentName
    //                 ..named = true
    //                 ..required = p.isRequired && route.defaultValues[p.name] == null
    //                 ..defaultTo = route.defaultValues[p.name] != null ? Code(route.defaultValues[p.name]! as String) : null
    //                 ..type = typeRefer(p, targetFile: targetFile),
    //             );
    //           }))
    //           ..optionalParameters.add(navigatorIdParameter)
    //           ..returns = typeRefer(
    //             route.returnType,
    //             targetFile: targetFile,
    //             forceNullable: true,
    //             forceFuture: isAsync,
    //           )
    //           ..body = body;
    //       },
    //     );
    //   }))
    //   ..methods.addAll(routes.where((route) => route.navigationType == NavigationType.dialog).map((route) {
    //     final body = TypeReference((b) => b
    //       ..symbol = 'showCustomDialog'
    //       ..types.add(route.returnType == null ? const Reference('dynamic') : typeRefer(route.returnType!, targetFile: targetFile))).call(
    //       [],
    //       {
    //         'navigatorKey': const Reference('navigatorKey'),
    //         'widget': Reference(
    //           route.constructorName == route.type.className || route.constructorName.isEmpty ? route.type.className : '${route.type.className}.${route.constructorName}',
    //           typeRefer(route.type, targetFile: targetFile).url,
    //         ).call([], route.parameters.asMap().map((_, p) => MapEntry(p.argumentName, Reference(p.argumentName)))),
    //       },
    //     ).code;
    //     return Method(
    //       (b) {
    //         b
    //           ..name = 'show${CaseUtil(route.routeName).upperCamelCase}'
    //           ..lambda = true
    //           ..modifier = MethodModifier.async
    //           ..optionalParameters.addAll(route.parameters.map((p) => Parameter(
    //                 (b) => b
    //                   ..name = p.argumentName
    //                   ..named = true
    //                   ..required = p.isRequired && route.defaultValues[p.name] == null
    //                   ..defaultTo = route.defaultValues[p.name] != null ? Reference(route.defaultValues[p.name]! as String).code : null
    //                   ..type = typeRefer(p, targetFile: targetFile),
    //               )))
    //           ..optionalParameters.add(navigatorKeyParameter)
    //           ..returns = typeRefer(
    //             route.returnType,
    //             targetFile: targetFile,
    //             forceNullable: true,
    //             forceFuture: true,
    //           )
    //           ..body = body;
    //       },
    //     );
    //   }))
    //   ..methods.add(Method(
    //     (b) => b
    //       ..name = 'goBack'
    //       ..lambda = true
    //       ..types.add(const Reference('T'))
    //       ..optionalParameters.add(Parameter(
    //         (b) => b
    //           ..name = 'result'
    //           ..named = true
    //           ..type = const Reference('T?'),
    //       ))
    //       ..optionalParameters.add(navigatorIdParameter)
    //       ..returns = const Reference('void')
    //       ..body = const Reference('Get.back<T>').call([], {
    //         'result': const Reference('result'),
    //         'id': const Reference('navigatorId'),
    //       }).code,
    //   ))
    //   ..methods.add(Method(
    //     (b) => b
    //       ..name = 'closeDialog'
    //       ..lambda = true
    //       ..optionalParameters.add(navigatorIdParameter)
    //       ..returns = const Reference('void')
    //       ..body = const Reference('goBack<void>').call([], {
    //         'navigatorId': const Reference('navigatorId'),
    //       }).code,
    //   ))
    //   ..methods.add(Method(
    //     (b) => b
    //       ..name = 'popUntil'
    //       ..lambda = true
    //       ..requiredParameters.add(Parameter(
    //         (b) => b
    //           ..name = 'predicate'
    //           ..type = FunctionType((b) => b
    //             ..returnType = const Reference('bool')
    //             ..requiredParameters.add(const Reference('Route<dynamic>', 'package:flutter/material.dart'))),
    //       ))
    //       ..optionalParameters.add(navigatorIdParameter)
    //       ..returns = const Reference('void')
    //       ..body = const Reference('Get.until').call([
    //         const Reference('predicate')
    //       ], {
    //         'id': const Reference('navigatorId'),
    //       }).code,
    //   ))
    //   ..methods.add(Method(
    //     (b) => b
    //       ..name = 'goBackTo'
    //       ..lambda = true
    //       ..requiredParameters.add(Parameter((b) => b
    //         ..name = 'routeName'
    //         ..type = const Reference('String')))
    //       ..optionalParameters.add(navigatorIdParameter)
    //       ..returns = const Reference('void')
    //       ..body = const Reference('Get.until').call([
    //         const Reference('(route) => Get.currentRoute == routeName'),
    //       ], {
    //         'id': const Reference('navigatorId'),
    //       }).code,
    //   ))
    //   ..methods.add(Method(
    //     (b) => b
    //       ..name = 'showCustomDialog'
    //       ..lambda = true
    //       ..modifier = MethodModifier.async
    //       ..types.add(const Reference('T'))
    //       ..optionalParameters.add(Parameter(
    //         (b) => b
    //           ..name = 'widget'
    //           ..named = true
    //           ..type = const Reference('Widget?', 'package:flutter/material.dart'),
    //       ))
    //       ..optionalParameters.add(navigatorKeyParameter)
    //       ..returns = const Reference('Future<T?>')
    //       ..body = const Reference('Get.dialog<T>').call([
    //         const Reference('widget').ifNullThen(const Reference('SizedBox.shrink', 'package:flutter/material.dart').constInstance([]))
    //       ], {
    //         'navigatorKey': const Reference('navigatorKey'),
    //       }).code,
    //   )));
  }
}
