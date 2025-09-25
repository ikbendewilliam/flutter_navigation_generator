import 'package:example/main.dart';
import 'package:example/main_navigator.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_navigation_generator_annotations/flutter_navigation_generator_annotations.dart';

var globalStateIsLoggedIn = false;

class LoginGuard extends NavigatorGuard {
  LoginGuard() : super(RouteNames.errorNotLoggedIn);

  @override
  Future<bool> getValue() async => globalStateIsLoggedIn;
}

@flutterRoute
class GuardExampleHome extends StatefulWidget {
  const GuardExampleHome({super.key});

  @override
  State<GuardExampleHome> createState() => _GuardExampleHomeState();
}

class _GuardExampleHomeState extends State<GuardExampleHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Guard example'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: globalStateIsLoggedIn,
                onChanged: (value) {
                  globalStateIsLoggedIn = value!;
                  setState(() {});
                  mainNavigator.updateGuard<LoginGuard>();
                },
              ),
              const Text('Is user logged in?'),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () async {
                  await mainNavigator.goToLoggedInPage();
                  setState(() {}); // This is just since the guard can log in
                },
                child: const Text("Go to logged in page"),
              ),
            ],
          ),
          if (mainNavigator.canContinueNavigation()) ...[
            ElevatedButton(
              onPressed: () async {
                globalStateIsLoggedIn = true;
                await mainNavigator.updateGuard<LoginGuard>();
                mainNavigator.continueNavigation();
              },
              child: const Text("Continue navigation (and set logged in)"),
            ),
          ],
          Text(
            "Has a navigation blocked by a guard (not logged in): ${mainNavigator.canContinueNavigation()}",
          ),
        ],
      ),
    );
  }
}

@FlutterRoute(generateMethod: false)
class ErrorNotLoggedIn extends StatelessWidget {
  const ErrorNotLoggedIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('You are not logged in'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are not logged in, sorry :('),
            ElevatedButton(
              onPressed: () => mainNavigator.goBack(),
              child: const Text("go back"),
            ),
            ElevatedButton(
              onPressed: () async {
                globalStateIsLoggedIn = true;
                await mainNavigator.updateGuard<LoginGuard>();
                mainNavigator.continueNavigation();
              },
              child: const Text("Continue navigation (and set logged in)"),
            ),
          ],
        ),
      ),
    );
  }
}

@FlutterRoute(guards: [LoginGuard])
class LoggedInPage extends StatelessWidget {
  const LoggedInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('You are logged in'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('You are logged in, yay :)'),
            ElevatedButton(
              onPressed: () => mainNavigator.goBackTo(RouteNames.guardExampleHome),
              child: const Text("go to guard home"),
            ),
          ],
        ),
      ),
    );
  }
}
