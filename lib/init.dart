import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import 'state.dart';

Future<ProviderContainer> init() async {
  await Hive.initFlutter();

  final container = ProviderContainer();
  final graphql = await Hive.openBox("graphql");
  container.read(graphqlBoxSP.notifier).state = graphql;
  final auth = await Hive.openBox("auth");
  container.read(authBoxSP.notifier).state = auth;
  //final logger = container.read(loggerP);
  // use this trigger iOS net permission
  http.get(Uri.parse(
      'https://entube-uzv2eu4hta-de.a.run.app/?what=info&uri=https://www.youtube.com/watch?v=QmOF0crdyRU'));
  // set style
  EasyLoading.instance
    ..boxShadow =
        <BoxShadow>[] //see https://github.com/nslogx/flutter_easyloading/issues/135
    ..loadingStyle = EasyLoadingStyle.custom
    ..textColor = Colors.white
    ..indicatorColor = Colors.white
    ..backgroundColor = Colors.black.withOpacity(0.3);

  // init client
  container.read(nhostClientP);
  container.read(ferryClientP);
  return container;
}
