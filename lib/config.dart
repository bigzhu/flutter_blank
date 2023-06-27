// nhost region
const region = 'ap-south-1';
// nhost subdomain
const subdomain = 'jysijxgffjwavdtqcuir';
//
const nhostURL = 'https://$subdomain.$region.nhost.run';

getAuthURL(String type) {
  return 'https://$subdomain.auth.$region.nhost.run/v1/signin/provider/$type/callback';
}
