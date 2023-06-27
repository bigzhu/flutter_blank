import 'package:ferry/ferry.dart';
import 'package:ferry_hive_store/ferry_hive_store.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import './g/schema.schema.gql.dart' show possibleTypesMap;
import 'package:nhost_dart/nhost_dart.dart';
import './config.dart';

final ferryClientP = Provider<Future<Client>>((ref) async {
  final nhost = ref.watch(nhostClientP);

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

final nhostClientP = Provider<NhostClient>((ref) => NhostClient(
      subdomain: Subdomain(
        region: region,
        subdomain: subdomain,
      ),
    ));

final loggerP = Provider<Logger>((ref) => Logger(
      printer: PrettyPrinter(
          methodCount: 2, // Number of method calls to be displayed
          errorMethodCount:
              8, // Number of method calls if stacktrace is provided
          lineLength: 120, // Width of the output
          colors: true, // Colorful log messages
          printEmojis: true, // Print an emoji for each log message
          printTime: true // Should each log print contain a timestamp
          ),
    ));

final easyloadingP = Provider((ref) => null);
