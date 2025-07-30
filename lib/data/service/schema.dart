import 'package:qree/model/qritem.dart';

const dbName = "qree";
const dbVersion = 1;

const schemaV1Create = [
  "CREATE TABLE qr_items ("
      "id INTEGER PRIMARY KEY,"
      "label TEXT,"
      "title TEXT NOT NULL,"
      "type INTEGER NOT NULL,"
      "content TEXT NOT NULL"
      ");",
];

final demoItems = [
  QrItem(
    type: QrType.url,
    title: 'Company Homepage',
    label: defaultUrl,
    content: QrContent(url: defaultUrl),
  ),
  QrItem(
    type: QrType.tel,
    title: 'Phone Number',
    label: defaultPhone,
    content: QrContent(phone: defaultPhone),
  ),
  QrItem(
    type: QrType.ical,
    title: 'Event Schedule',
    label: 'Babylon at 6pm',
    content: QrContent(
      timestamp: "20250829T080000",
      start: "20250907T181500",
      end: "20250907T193500",
      summary: "Monthly Meetup",
      description:
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
      location: "Babylon",
    ),
  ),
  QrItem(
    title: 'SMS Number',
    type: QrType.sms,
    label: defaultPhone,
    content: QrContent(phone: defaultPhone, message: 'Hi'),
  ),
  QrItem(
    title: 'Business Email',
    type: QrType.mailto,
    label: defaultEmail,
    content: QrContent(
      email: defaultEmail,
      subject: "I want to connect",
      message: "Hello,",
    ),
  ),
  QrItem(
    title: 'Business Card',
    type: QrType.vcard,
    label: defaultName,
    content: QrContent(
      name: defaultName,
      company: defaultCompany,
      email: defaultEmail,
      phone: defaultPhone,
      address: defaultAddress,
      url: defaultUrl,
    ),
  ),
  QrItem(
    title: 'Guest Wi-Fi',
    type: QrType.wifi,
    content: QrContent(
      protocol: 'WPA',
      password: defaultPassword,
      ssid: defaultSsid,
    ),
  ),
  QrItem(
    title: 'Office Location',
    type: QrType.geo,
    label: "Ottawa, ON",
    content: QrContent(location: '45.420873, -75.696672'),
  ),
  QrItem(
    title: 'Things to Share',
    type: QrType.text,
    content: QrContent(text: 'Lorem ipsum dolor sit amet, consectetur'),
  ),
];
