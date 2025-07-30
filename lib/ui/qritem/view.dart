import 'package:flutter/material.dart';
import 'package:qree/model/qritem.dart' show QrItem, QrType;
import 'package:go_router/go_router.dart';

import '../forms/geo.dart';
import '../forms/ical.dart';
import '../forms/mailto.dart';
import '../forms/sms.dart';
import '../forms/tel.dart';
import '../forms/text.dart';
import '../forms/url.dart';
import '../forms/vcard.dart';
import '../forms/wifi.dart';
import 'model.dart';

class QrItemView extends StatelessWidget {
  final QrItem item;
  final QrItemViewModel model;
  const QrItemView({super.key, required this.item, required this.model});

  Widget buildBody(QrItem item) {
    switch (item.type) {
      case QrType.url:
        return UrlDetails(item: item, model: model);
      case QrType.tel:
        return TelDetails(item: item, model: model);
      case QrType.ical:
        return IcalDetails(item: item, model: model);
      case QrType.sms:
        return SmsDetails(item: item, model: model);
      case QrType.mailto:
        return MailtoDetails(item: item, model: model);
      case QrType.vcard:
        return VcardDetails(item: item, model: model);
      case QrType.wifi:
        return WifiDetails(item: item, model: model);
      case QrType.geo:
        return GeoDetails(item: item, model: model);
      case QrType.text:
        return TextDetails(item: item, model: model);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('item:$item');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.keyboard_arrow_left_rounded),
        ),
        title: Text('Item Settings'),
        actions: [
          TextButton.icon(
            label: Text('delete'),
            icon: Icon(
              Icons.delete_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              model.delete(item.id);
              context.pop();
            },
          ),
        ],
      ),
      body: buildBody(item),
    );
  }
}
