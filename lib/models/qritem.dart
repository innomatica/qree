import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// enum QrType { url, tel, iCalendar, sms, mailto, vCard, wifi, text, geo}
enum QrType { url, tel, iCalendar, sms, mailto, vCard, wifi, text }

extension QrTypeName on QrType {
  String getName() {
    switch (this) {
      case QrType.url:
        return 'Website Link';
      case QrType.tel:
        return 'Phone Number';
      case QrType.iCalendar:
        return 'Event Schedule';
      case QrType.sms:
        return 'SMS Message';
      case QrType.mailto:
        return 'Email Address';
      case QrType.vCard:
        return 'Business Card';
      case QrType.wifi:
        return 'Wi-Fi Credential';
      // case QrType.geo:
      //   return 'Location';
      case QrType.text:
      default:
        return 'Plain Text';
    }
  }
}

const siteType = {
  'Homepage': 'https://{url}',
  'Bitbucket': 'https://bitbucket.org/{username}',
  'Dribbble': 'https://dribbble.com/{username}',
  'Facebook': 'https://facebook.com/{username}',
  'Github': 'https://github.com/{username}',
  'Instagram': 'https://instagram.com/{username}',
  'LinkedIn': 'https://www.linkedin.com/in/{username}',
  'Medium': 'https://medium.com/@{username}',
  'Twitter': 'https://twitter.com/{username}',
  'Unsplash': 'https://unsplash.com/@{username}',
  'Youtube': 'https://youtube.com/c/{username}',
  'Custom URL': 'https://{url}',
};

class QrItem {
  int? id;
  String? text;
  String title;
  QrType type;
  int position;
  Map<String, dynamic> info;

  QrItem({
    this.id,
    this.text,
    required this.title,
    required this.type,
    required this.position,
    required this.info,
  });

  factory QrItem.fromDatabase(Map<String, dynamic> snapshot) {
    return QrItem(
      id: snapshot['id'],
      text: snapshot['text'] ?? '',
      title: snapshot['title'],
      type: QrType.values[snapshot['type']],
      position: snapshot['position'],
      info: jsonDecode(snapshot['info']),
    );
  }

  factory QrItem.defaultByType(QrType qrType) {
    Map<String, dynamic> info;

    switch (qrType) {
      case QrType.url:
        info = {};
        break;
      case QrType.tel:
        info = {};
        break;
      case QrType.iCalendar:
        info = {};
        break;
      case QrType.sms:
        info = {};
        break;
      case QrType.mailto:
        info = {};
        break;
      case QrType.vCard:
        info = {};
        break;
      case QrType.wifi:
        info = {};
        break;
      // case QrType.geo:
      //   info = {};
      //   break;

      default:
        info = {};
        break;
    }

    return QrItem(title: '', text: '', type: qrType, position: -1, info: info);
  }

  Map<String, dynamic> toDatabase() {
    return {
      "id": id,
      "text": text,
      "title": title,
      "type": type.index,
      "position": position,
      "info": jsonEncode(info),
    };
  }

  @override
  String toString() {
    return toDatabase().toString();
  }

  Widget icon({Color? color}) {
    if (type == QrType.url) {
      if (info['site'].toLowerCase().contains('home')) {
        return FaIcon(FontAwesomeIcons.house, color: color);
      } else if (info['site'].toLowerCase().contains('bitbucket')) {
        return FaIcon(FontAwesomeIcons.bitbucket, color: color);
      } else if (info['site'].toLowerCase().contains('dribbble')) {
        return FaIcon(FontAwesomeIcons.dribbble, color: color);
      } else if (info['site'].toLowerCase().contains('facebook')) {
        return FaIcon(FontAwesomeIcons.facebook, color: color);
      } else if (info['site'].toLowerCase().contains('github')) {
        return FaIcon(FontAwesomeIcons.github, color: color);
      } else if (info['site'].toLowerCase().contains('instagram')) {
        return FaIcon(FontAwesomeIcons.instagram, color: color);
      } else if (info['site'].toLowerCase().contains('linkedin')) {
        return FaIcon(FontAwesomeIcons.linkedin, color: color);
      } else if (info['site'].toLowerCase().contains('medium')) {
        return FaIcon(FontAwesomeIcons.medium, color: color);
      } else if (info['site'].toLowerCase().contains('slack')) {
        return FaIcon(FontAwesomeIcons.slack, color: color);
      } else if (info['site'].toLowerCase().contains('twitter')) {
        return FaIcon(FontAwesomeIcons.twitter, color: color);
      } else if (info['site'].toLowerCase().contains('unsplash')) {
        return FaIcon(FontAwesomeIcons.unsplash, color: color);
      } else if (info['site'].toLowerCase().contains('youtube')) {
        return FaIcon(FontAwesomeIcons.twitter, color: color);
      } else {
        return FaIcon(FontAwesomeIcons.link, color: color);
      }
    } else if (type == QrType.tel) {
      return FaIcon(FontAwesomeIcons.phone, color: color);
    } else if (type == QrType.iCalendar) {
      return FaIcon(FontAwesomeIcons.calendarCheck, color: color);
    } else if (type == QrType.sms) {
      return FaIcon(FontAwesomeIcons.message, color: color);
    } else if (type == QrType.mailto) {
      return FaIcon(FontAwesomeIcons.envelope, color: color);
    } else if (type == QrType.vCard) {
      return FaIcon(FontAwesomeIcons.addressCard, color: color);
    } else if (type == QrType.wifi) {
      return FaIcon(FontAwesomeIcons.wifi, color: color);
      // } else if (type == QrType.geo) {
      //   return FaIcon(FontAwesomeIcons.locationDot, color: color);
    }
    return FaIcon(FontAwesomeIcons.noteSticky, color: color);
  }
}
