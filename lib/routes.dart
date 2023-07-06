import 'package:go_router/go_router.dart';

import '../components/Auth/index.dart';
import '../main.dart' show MyHomePage;

final routes = [
  GoRoute(
    path: '/',
    builder: (context, state) => const MyHomePage(
      title: 'test',
    ),
  ),
  GoRoute(
    path: '/SignIn',
    builder: (context, state) => const SignIn(),
  ),
];
