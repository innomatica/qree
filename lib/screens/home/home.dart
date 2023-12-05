import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qreeapp/models/qritem.dart';
import 'package:qreeapp/screens/about/about.dart';
import 'package:qreeapp/screens/forms/ical.dart';
import 'package:qreeapp/screens/forms/mailto.dart';
import 'package:qreeapp/screens/forms/sms.dart';
import 'package:qreeapp/screens/forms/tel.dart';
import 'package:qreeapp/screens/forms/text.dart';
import 'package:qreeapp/screens/forms/url.dart';
import 'package:qreeapp/screens/forms/vcard.dart';
import 'package:qreeapp/screens/forms/wifi.dart';
import 'package:qreeapp/services/sqlite.dart';
import 'package:qreeapp/shared/constants.dart';

import 'item_details.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _db = SqliteService();
  final _menuList = <Map<String, dynamic>>[
    {
      'menu': 'About',
      'icon': Icons.info_rounded,
    },
  ];
  bool _isFabVisible = true;

  //
  // Scaffold.Menu
  //
  Widget _buildScaffoldMenu() {
    return PopupMenuButton(
      onSelected: (value) {
        switch (value) {
          case 'About':
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => const About()),
              ),
            );
            break;
          default:
            break;
        }
      },
      itemBuilder: (context) => _menuList
          .map(
            (e) => PopupMenuItem(
              value: e['menu'],
              child: Row(
                children: [
                  Icon(
                    e['icon'],
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(e['menu']),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  //
  // Details Button
  //
  void _navigateToItemDetailPage(QrItem item) {
    switch (item.type) {
      case QrType.url:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => UrlDetails(item))))
            .then((value) => setState(() {}));
        break;
      case QrType.tel:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => TelDetails(item))))
            .then((value) => setState(() {}));
        break;
      case QrType.iCalendar:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => IcalDetails(item))))
            .then((value) => setState(() {}));
        break;
      case QrType.sms:
        // message payload not recognized
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => SmsDetails(item))))
            .then((value) => setState(() {}));
        break;
      // case QrType.geo:
      // not recognized
      //   break;
      case QrType.mailto:
        Navigator.of(context)
            .push(
                MaterialPageRoute(builder: ((context) => MailtoDetails(item))))
            .then((value) => setState(() {}));
        break;
      case QrType.vCard:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => VcardDetails(item))))
            .then((value) => setState(() {}));
        break;
      case QrType.wifi:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => WifiDetails(item))))
            .then((value) => setState(() {}));
        break;
      case QrType.text:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => TextDetails(item))))
            .then((value) => setState(() {}));
        break;
      default:
        break;
    }
  }

  //
  // ListTile
  //
  Widget _buildListTile(QrItem item) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        onTap: () {
          //
          // QR Code
          //
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 24),
                      child: BarcodeWidget(
                        barcode: Barcode.qrCode(
                          errorCorrectLevel: BarcodeQRCorrectionLevel.high,
                        ),
                        data: item.info['data'],
                        width: 280,
                        height: 280,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(
                          color: Theme.of(context).colorScheme.error,
                        )),
                        child: Text(
                          dialogSubTitle,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        leading: item.icon(color: Theme.of(context).colorScheme.tertiary),
        title: Text(item.title),
        //
        // Item Details
        //
        trailing: IconButton(
          icon: Icon(
            Icons.settings_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
          onPressed: () {
            // _navigateToItemDetailPage(item);
            Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ItemDetails(item: item)))
                .then(
              (value) {
                if (value == true) {
                  setState(() {});
                }
              },
            );
          },
        ),
      ),
    );
  }

  //
  // Floating Action Button
  //
  FloatingActionButton? _buildFab() {
    return _isFabVisible
        ? FloatingActionButton(
            elevation: 8,
            // backgroundColor: fabColor,
            onPressed: () {
              showDialog<QrType>(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: const Text('Choose QR code type'),
                    children: QrType.values
                        .map((e) => SimpleDialogOption(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                e.getName(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(e);
                            }))
                        .toList(),
                  );
                },
              ).then((value) {
                if (value is QrType) {
                  final item = QrItem.defaultByType(value);
                  _navigateToItemDetailPage(item);
                }
              });
            },
            child: const Icon(Icons.add_rounded),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QRee'),
        actions: <Widget>[
          _buildScaffoldMenu(),
        ],
      ),
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.direction == ScrollDirection.forward) {
            if (!_isFabVisible) setState(() => _isFabVisible = true);
          } else if (notification.direction == ScrollDirection.reverse) {
            if (_isFabVisible) setState(() => _isFabVisible = false);
          }
          return false;
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder<List<QrItem>>(
            future: _db.getQrItems(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final qrItems = snapshot.data!;
                return ListView.builder(
                    itemCount: qrItems.length,
                    itemBuilder: (context, index) {
                      return _buildListTile(qrItems[index]);
                    });
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
