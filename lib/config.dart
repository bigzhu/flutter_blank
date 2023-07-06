// nhost region
import 'package:nhost_dart/nhost_dart.dart';

const region = 'ap-south-1';
// nhost subdomain
const subdomain = 'jysijxgffjwavdtqcuir';
//
const nhostURL = 'https://$subdomain.$region.nhost.run';

getAuthURL(String type) {
  final url = '${createNhostServiceEndpoint(
    subdomain: subdomain,
    region: region,
    service: 'auth',
  )}/signin/provider/$type';
  return url;
}
