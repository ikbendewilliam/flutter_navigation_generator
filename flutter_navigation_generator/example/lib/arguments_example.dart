import 'package:example/custom_model.dart';
import 'package:example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

@FlutterRoute(
  routeName: 'home/:id/:name/:nonExistingName/number1/',
  methodName: 'customName',
)
class RouteNameWithArguments extends StatelessWidget {
  final String id;
  final String? name;
  final int? age;
  final CustomModel? model;

  const RouteNameWithArguments({required this.id, this.model, this.name, this.age, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('RouteNameWithArguments'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('RouteNameWithArguments:'),
            Text('id: $id'),
            Text('name: $name'),
            Text('age: $age'),
            ElevatedButton(onPressed: mainNavigator.goBack, child: const Text("Back")),
          ],
        ),
      ),
    );
  }
}

@FlutterRoute(routeName: '/home/:id/example/:exampleEnum/:age')
class RouteNameWithArguments2 extends StatelessWidget {
  final String id;
  final String? name;
  final int? age;
  final ExampleEnum exampleEnum;
  final ExampleEnum exampleEnum2;
  final ExampleEnum? exampleEnum3;
  final List<ExampleEnum>? exampleEnums4;
  final Map<String, ExampleEnum>? exampleEnumsMap5;

  const RouteNameWithArguments2({
    required this.id,
    required this.exampleEnum,
    required this.exampleEnum2,
    this.name,
    this.age,
    this.exampleEnum3,
    this.exampleEnums4,
    this.exampleEnumsMap5,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('RouteNameWithArguments2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('RouteNameWithArguments2:'),
            Text('id: $id'),
            Text('name: $name'),
            Text('age: $age'),
            Text('exampleEnum: $exampleEnum'),
            Text('exampleEnum2: $exampleEnum2'),
            Text('exampleEnum3: $exampleEnum3'),
            Text('exampleEnums4: $exampleEnums4'),
            Text('exampleEnumsMap5: $exampleEnumsMap5'),
            ElevatedButton(
              onPressed: mainNavigator.goBack,
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}

@flutterRoute
class ExampleScreenWithRequiredArgument extends StatelessWidget {
  final List<CustomModel> data;

  const ExampleScreenWithRequiredArgument({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Got ${data.length} items:', style: const TextStyle(fontSize: 40)),
            for (final item in data) ...[
              Text(item.name, style: const TextStyle(fontSize: 40)),
              Text(
                item.age.toString(),
                style: const TextStyle(fontSize: 40),
              ),
            ],
            ElevatedButton(
              onPressed: mainNavigator.goBack,
              child: const Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
