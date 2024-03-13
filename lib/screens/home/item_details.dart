import 'package:flutter/material.dart';

import '../../models/qritem.dart';
import '../../services/sqlite.dart';
// import '../forms/geo.dart';
import '../forms/ical.dart';
import '../forms/mailto.dart';
import '../forms/sms.dart';
import '../forms/tel.dart';
import '../forms/text.dart';
import '../forms/url.dart';
import '../forms/vcard.dart';
import '../forms/wifi.dart';

class ItemDetails extends StatelessWidget {
  final QrItem item;
  final _db = SqliteService();
  ItemDetails({required this.item, super.key});

  Widget _getItemEditView(QrItem item) {
    switch (item.type) {
      case QrType.url:
        return UrlDetails(item);
      case QrType.tel:
        return TelDetails(item);
      case QrType.iCalendar:
        return IcalDetails(item);
      case QrType.sms:
        return SmsDetails(item);
      case QrType.mailto:
        return MailtoDetails(item);
      case QrType.vCard:
        return VcardDetails(item);
      case QrType.wifi:
        return WifiDetails(item);
      // case QrType.geo:
      //   return GeoDetails(item);
      case QrType.text:
        return TextDetails(item);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.type.getName()),
        actions: [
          item.id == null
              ? Container()
              : TextButton.icon(
                  onPressed: () {
                    if (item.id != null) {
                      _db.deleteQrItemById(item.id!);
                      Navigator.of(context).pop(true);
                    }
                  },
                  icon: Icon(Icons.delete_rounded,
                      color: Theme.of(context).colorScheme.error),
                  label: const Text('delete'),
                )
        ],
      ),
      body: _getItemEditView(item),
    );
  }
}
