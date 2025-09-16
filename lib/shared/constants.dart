// app info
const appName = 'QRee';
const appVersion = '1.0.2+3';
const appId = 'com.innomatic.qree';

const developerWebsite = 'https://innomatic.ca';
const sourceRepository = 'https://github.com/innomatica/qree';
const releaseUrl = 'https://github.com/innomatica/qree/releases';

final emailRegEx = RegExp(r'^\S+@\S+\.\S+$');
final phoneRegEx = RegExp(
  r'^([+]?\d{1,2}[-\s]?|)\d{1,3}[-\s]?\d{3,4}[-\s]?\d{4}$',
);
final geocodeRegEx = RegExp(
  r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$',
);
