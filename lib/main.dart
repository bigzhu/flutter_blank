import 'dart:async';
import 'dart:io' show Platform;

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nhost_dart/nhost_dart.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/auth/index.dart';
import 'const.dart';
import 'init.dart';
import 'routes.dart';
import 'state.dart';

void main() async {
  final container = await init();
  runApp(
    // For widgets to be able to read providers, we need to wrap the entire
    // application in a "ProviderScope" widget.
    // This is where the state of our providers will be stored.
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logger = ref.read(loggerP);
    AppLinks appLinks = AppLinks();
    useEffect(
      () {
        //register the app link handler
        final linkSubscription = appLinks.uriLinkStream.listen((uri) {
          //logger.d(uri.host);
          logger.d(uri);
          logger.d(uri.host);
          if (uri.host == signInSuccessHost) {
            ref.read(authSNP.notifier).completeOAuth(uri);
          }
          if (uri.host == signInFailureHost) {
            EasyLoading.showError('login in failure');
          }
          // not run in mac
          if (Platform.isAndroid) {
            closeInAppWebView();
          }
        });

        // For sharing or opening urls/text coming from outside the app while the app is in the memory
        logger.d("run intentDataStreamSubscription");
        StreamSubscription intentDataStreamSubscription =
            ReceiveSharingIntent.getTextStream().listen((String url) {
          //if (ref.watch(authSNP) != AuthenticationState.signedIn) return;
          //ref.read(userArticlesSNP.notifier).sharedNew(url);
          logger.d(url);
        }, onError: (err) {
          EasyLoading.showError("getLinkStream error: $err");
        });

        // For sharing or opening urls/text coming from outside the app while the app is closed
        ReceiveSharingIntent.getInitialText().then((String? url) {
          logger.d(url);
          if (url != null) {
            //ref.read(userArticlesSNP.notifier).sharedNew(url);
          }
        });

        return () {
          linkSubscription.cancel();
          intentDataStreamSubscription.cancel();
        };
      },
      [],
    );
    final authenticationState = ref.watch(authSNP);
    return MaterialApp.router(
        builder: EasyLoading.init(),
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // TRY THIS: Try running your application with "flutter run". You'll see
          // the application has a blue toolbar. Then, without quitting the app,
          // try changing the seedColor in the colorScheme below to Colors.green
          // and then invoke "hot reload" (save your changes or press the "hot
          // reload" button in a Flutter-supported IDE, or press "r" if you used
          // the command line to start the app).
          //
          // Notice that the counter didn't reset back to zero; the application
          // state is not lost during the reload. To reset the state, use hot
          // restart instead.
          //
          // This works for code too, not just values: Most code changes can be
          // tested with just a hot reload.
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: GoRouter(
            routes: routes,
            redirect: (BuildContext context, GoRouterState state) {
              switch (authenticationState) {
                case AuthenticationState.signedIn:
                  final auth = ref.watch(nhostClientP).auth;
                  logger.d(auth.accessToken);
                  return state.path;
                //return '/AcquiringWords';
                //  return '/ArticleItems';
                //return '/LoggedInUserDetails';
                case AuthenticationState.inProgress:
                  EasyLoading.showInfo('login in progress');
                  return state.path;
                case AuthenticationState.signedOut:
                  return '/SignIn';
                default:
                  return state.path;
              }
            }));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
