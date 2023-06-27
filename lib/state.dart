import 'package:ferry/ferry.dart';
import 'package:ferry_hive_store/ferry_hive_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import './g/schema.schema.gql.dart' show possibleTypesMap;
import 'package:nhost_dart/nhost_dart.dart';
import './config.dart';

final ferryClient = FutureProvider<Client>((ref) async {
  final nhost = ref.watch(nhostClient);

  await Hive.initFlutter();
  final box = await Hive.openBox("graphql");
  final store = HiveStore(box);
  final cache = Cache(store: store, possibleTypes: possibleTypesMap);

  final nhostLink = combinedLinkForNhost(nhost);

  final client = Client(
    link: nhostLink,
    cache: cache,
  );

  return client;
});

final nhostClient = Provider<NhostClient>((ref) => NhostClient(
      subdomain: Subdomain(
        region: region,
        subdomain: subdomain,
      ),
    ));
