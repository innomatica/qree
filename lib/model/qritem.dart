import 'dart:convert' show jsonEncode, jsonDecode;

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qree/shared/constants.dart';

// https://www.meiguodizhi.com/ca-address/hot-city-Ottawa?hl=en
const defaultAddress = '3526 Olver Street, Fort Worth, TX 76102';
const defaultCompany = 'Acme Construction Inc.';
const defaultEmail = 'cdivdhjfxn@acmecon.com';
const defaultName = 'Albert Scott';
const defaultPassword = 'RALNV4rvMIks';
const defaultPhone = '817-345-6873';
const defaultSsid = 'Rogers #12345';
const defaultUrl = 'https://acmecon.com';

// enum QrType {
//   geo("Location"),
//   ical("Event Schedule"),
//   mailto("Email Address"),
//   sms("SMS Message"),
//   tel("Phone Number"),
//   text("Search Keyword"),
//   url("Website Link"),
//   vcard("Business Card"),
//   wifi("WiFi Credential");

//   final String name;
//   const QrType(this.name);
// }

enum QrType { geo, ical, mailto, sms, tel, text, url, vcard, wifi }

extension QrTypeName on QrType {
  String name() {
    switch (this) {
      case QrType.geo:
        return 'Location';
      case QrType.ical:
        return 'Event Schedule';
      case QrType.mailto:
        return 'Email Address';
      case QrType.sms:
        return 'SMS Message';
      case QrType.tel:
        return 'Phone Number';
      case QrType.text:
        return 'Simple Text';
      case QrType.url:
        return 'Website Link';
      case QrType.vcard:
        return 'Business Card';
      case QrType.wifi:
        return 'Wi-Fi Credential';
    }
  }

  Widget icon({Color? color}) {
    switch (this) {
      case QrType.geo:
        return FaIcon(FontAwesomeIcons.locationDot, color: color);
      case QrType.ical:
        return FaIcon(FontAwesomeIcons.calendarCheck, color: color);
      case QrType.mailto:
        return FaIcon(FontAwesomeIcons.envelope, color: color);
      case QrType.sms:
        return FaIcon(FontAwesomeIcons.message, color: color);
      case QrType.tel:
        return FaIcon(FontAwesomeIcons.phone, color: color);
      case QrType.text:
        FaIcon(FontAwesomeIcons.noteSticky, color: color);
      case QrType.url:
        return FaIcon(FontAwesomeIcons.link, color: color);
      case QrType.vcard:
        return FaIcon(FontAwesomeIcons.addressCard, color: color);
      case QrType.wifi:
        return FaIcon(FontAwesomeIcons.wifi, color: color);
    }
    return FaIcon(FontAwesomeIcons.locationDot, color: color);
  }
}

// ignore: constant_identifier_names
enum WifiAuth { WEP, WPA, WPA2, WPA3 }

class QrContent {
  String? address;
  String? company;
  String? description;
  String? email;
  String? end;
  String? geo;
  String? hidden;
  String? location;
  String? message;
  String? name;
  String? password;
  String? phone;
  String? protocol;
  String? ssid;
  String? start;
  String? subject;
  String? summary;
  String? text;
  String? timestamp;
  String? title;
  String? url;

  QrContent({
    this.address,
    this.company,
    this.description,
    this.email,
    this.end,
    this.geo,
    this.hidden,
    this.location,
    this.message,
    this.name,
    this.password,
    this.phone,
    this.protocol,
    this.ssid,
    this.start,
    this.subject,
    this.summary,
    this.text,
    this.timestamp,
    this.title,
    this.url,
  });

  factory QrContent.fromDbStr(String content) {
    final data = jsonDecode(content);
    return QrContent(
      address: data['address'],
      company: data["compay"],
      description: data["description"],
      email: data["email"],
      end: data["end"],
      geo: data["geo"],
      hidden: data["hidden"],
      location: data["location"],
      message: data["message"],
      name: data["name"],
      password: data["password"],
      phone: data["phone"],
      protocol: data["protocol"],
      ssid: data["ssid"],
      start: data["start"],
      subject: data["subject"],
      summary: data["summary"],
      text: data["text"],
      timestamp: data["timestamp"],
      title: data["title"],
      url: data["url"],
    );
  }

  String toDbStr() {
    return jsonEncode({
      "address": address,
      "company": company,
      "description": description,
      "email": email,
      "end": end,
      "geo": geo,
      "hidden": hidden,
      "location": location,
      "message": message,
      "name": name,
      "password": password,
      "phone": phone,
      "protocol": protocol,
      "ssid": ssid,
      "start": start,
      "subject": subject,
      "text": text,
      "timestamp": timestamp,
      "title": title,
      "url": url,
    });
  }

  @override
  String toString() => toDbStr();
}

class QrItem {
  int? id;
  String title;
  String? label;
  QrType type;
  QrContent content;

  QrItem({
    this.id,
    required this.title,
    this.label,
    required this.type,
    required this.content,
  });

  factory QrItem.fromDbMap(Map<String, dynamic> row) {
    return QrItem(
      id: row['id'],
      title: row['title'],
      label: row['label'],
      type: QrType.values[row['type']],
      content: QrContent.fromDbStr(row['content']),
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      "id": id,
      "label": label,
      "title": title,
      "type": type.index,
      "content": content.toDbStr(),
    };
  }

  @override
  String toString() {
    return toDbMap().toString();
  }

  //
  // NOTE: Use localtime instead of UTC in iCal because some calendar apps,
  // including google calendar do not understand iCal data in UTC time format.
  // Using TZID and VTIMEZONE fields may solve the problem but it will increase
  // the payload substantially.
  //
  static String toICalString(String iso) =>
      iso.split('.').first.replaceAll("-", "").replaceAll(":", "");

  String data() {
    debugPrint('item: ${toString()}');
    String result = "";
    // https://github.com/zxing/zxing/wiki/Barcode-Contents
    if (type == QrType.geo) {
      result = "geo:${content.location}";
    } else if (type == QrType.ical) {
      // https://github.com/zxing/zxing/wiki/Barcode-Contents#calendar-events
      // https://datatracker.ietf.org/doc/html/rfc5545
      // https://en.wikipedia.org/wiki/ICalendar
      result =
          "BEGIN:VCALENDAR\nVERSION:2.0\n"
          "PRODID:-//innomatic//NONSGML $appName//EN\n"
          "BEGIN:VEVENT";
      if (content.name != null) {
        result = "$result;CN=${content.name}";
        if (content.email != null) {
          result = "$result:MAILTO:${content.email}";
        }
      }
      if (content.timestamp != null) {
        result = "$result\nDTSTAMP:${toICalString(content.timestamp!)}";
      }
      if (content.start != null) {
        result = "$result\nDTSTART:${toICalString(content.start!)}";
      }
      if (content.end != null) {
        result = "$result\nDTEND:${toICalString(content.end!)}";
      }
      if (content.summary != null) {
        result = "$result\nSUMMARY:${content.summary}";
      }
      if (content.description != null) {
        result = "$result\nDESCRIPTION:${content.description}";
      }
      if (content.location != null) {
        result = "$result\nLOCATION:${content.location}";
      }
      if (content.geo != null) {
        result = "$result\nGEO:${content.geo}";
      }
      result = "$result\nEND:VEVENT\nEND:VCALENDAR";
    } else if (type == QrType.mailto) {
      // https://datatracker.ietf.org/doc/html/rfc6068
      result = "mailto:${content.email}";
      if (content.subject != null) {
        result = "$result?subject=${content.subject}";
      }
      if (content.message != null) {
        result = "$result&body=${content.message}";
      }
    } else if (type == QrType.sms) {
      // https://github.com/zxing/zxing/wiki/Barcode-Contents#smsmmsfacetime
      // https://datatracker.ietf.org/doc/rfc5724/
      result = "sms:${content.phone}";
      if (content.message != null) {
        result = "$result?body=${content.message}";
      }
    } else if (type == QrType.tel) {
      // https://github.com/zxing/zxing/wiki/Barcode-Contents#telephone-numbers
      result = "tel:${content.phone}";
    } else if (type == QrType.text) {
      result = content.text ?? '';
    } else if (type == QrType.url) {
      // https://github.com/zxing/zxing/wiki/Barcode-Contents#url
      final url = content.url ?? defaultUrl;
      result = url.startsWith('http') ? url : 'https://$url';
    } else if (type == QrType.vcard) {
      // https://github.com/zxing/zxing/wiki/Barcode-Contents#vcard
      // https://en.wikipedia.org/wiki/VCard
      // https://datatracker.ietf.org/doc/html/rfc6350
      result = "BEGIN:VCARD\nVERSION:4.0\nFN:${content.name}";
      if (content.title != null) {
        result = "$result\nTITLE:${content.title}";
      }
      if (content.company != null) {
        result = "$result\nORG;TYPE=work:${content.company}";
      }
      if (content.email != null) {
        result = "$result\nEMAIL;TYPE=work:${content.email}";
      }
      if (content.phone != null) {
        result = "$result\nTEL;TYPE=work:${content.phone}";
      }
      if (content.address != null) {
        result = "$result\nADR;TYPE=work:${content.address}";
      }
      if (content.url != null) {
        result = "$result\nURL;TYPE=work:${content.url}";
      }
      result = "$result\nEND:VCARD";
    } else if (type == QrType.wifi) {
      // https://github.com/zxing/zxing/wiki/Barcode-Contents#wi-fi-network-config-android-ios-11
      result = "WIFI:";
      if (content.protocol != null) {
        result = "${result}T:${content.protocol};";
      }
      result = "${result}S:${content.ssid};";
      if (content.password != null) {
        final escaped = content.password!
            .replaceAll(r"\", r"\\")
            .replaceAll(";", r"\;")
            .replaceAll(",", r"\,")
            .replaceAll('"', r'\"')
            .replaceAll(':', r'\:');
        result = "${result}P:$escaped;";
      }
      if (content.hidden != null) {
        result = "${result}H:${content.hidden};";
      }
      result = "$result;";
    }
    // return content.toString();
    debugPrint('result:$result');
    return result;
  }

  Widget icon({Color? color}) {
    if (type == QrType.url && content.url != null) {
      if (content.url!.toLowerCase().contains('home')) {
        return FaIcon(FontAwesomeIcons.house, color: color);
      } else if (content.url!.toLowerCase().contains('bitbucket')) {
        return FaIcon(FontAwesomeIcons.bitbucket, color: color);
      } else if (content.url!.toLowerCase().contains('dribbble')) {
        return FaIcon(FontAwesomeIcons.dribbble, color: color);
      } else if (content.url!.toLowerCase().contains('facebook')) {
        return FaIcon(FontAwesomeIcons.facebook, color: color);
      } else if (content.url!.toLowerCase().contains('github')) {
        return FaIcon(FontAwesomeIcons.github, color: color);
      } else if (content.url!.toLowerCase().contains('instagram')) {
        return FaIcon(FontAwesomeIcons.instagram, color: color);
      } else if (content.url!.toLowerCase().contains('linkedin')) {
        return FaIcon(FontAwesomeIcons.linkedin, color: color);
      } else if (content.url!.toLowerCase().contains('medium')) {
        return FaIcon(FontAwesomeIcons.medium, color: color);
      } else if (content.url!.toLowerCase().contains('slack')) {
        return FaIcon(FontAwesomeIcons.slack, color: color);
      } else if (content.url!.toLowerCase().contains('twitter')) {
        return FaIcon(FontAwesomeIcons.twitter, color: color);
      } else if (content.url!.toLowerCase().contains('unsplash')) {
        return FaIcon(FontAwesomeIcons.unsplash, color: color);
      } else if (content.url!.toLowerCase().contains('youtube')) {
        return FaIcon(FontAwesomeIcons.twitter, color: color);
      } else {
        return FaIcon(FontAwesomeIcons.link, color: color);
      }
    } else if (type == QrType.tel) {
      return FaIcon(FontAwesomeIcons.phone, color: color);
    } else if (type == QrType.ical) {
      return FaIcon(FontAwesomeIcons.calendarCheck, color: color);
    } else if (type == QrType.sms) {
      return FaIcon(FontAwesomeIcons.message, color: color);
    } else if (type == QrType.mailto) {
      return FaIcon(FontAwesomeIcons.envelope, color: color);
    } else if (type == QrType.vcard) {
      return FaIcon(FontAwesomeIcons.addressCard, color: color);
    } else if (type == QrType.wifi) {
      return FaIcon(FontAwesomeIcons.wifi, color: color);
    } else if (type == QrType.geo) {
      return FaIcon(FontAwesomeIcons.locationDot, color: color);
    }
    return FaIcon(FontAwesomeIcons.noteSticky, color: color);
  }
}
