import 'dart:io';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:qreeapp/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:qreeapp/screens/about/app_info.dart';
// import 'package:qreeapp/screens/about/attribution.dart';
// import 'package:qreeapp/screens/about/disclaimer.dart';
// import 'package:qreeapp/screens/about/privacy.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  String? _getStoreUrl() {
    if (Platform.isAndroid) {
      return urlPlayStore;
    } else if (Platform.isIOS) {
      return urlAppStore;
    }
    return urlHomePage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text('About'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'Version',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            subtitle: const Text(appVersion),
          ),
          ListTile(
            title: Text(
              'Visit Our Store',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            subtitle:
                const Text('Review App, Report Bugs, Share Your Thoughts'),
            onTap: () async {
              final url = _getStoreUrl();
              if (url != null) {
                launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              }
            },
          ),
          ListTile(
            title: Text(
              'Recommand to Others',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            subtitle: const Text('Show QR Code'),
            onTap: () async {
              final url = _getStoreUrl();
              if (url != null) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: EdgeInsets.zero,
                      title: Center(
                        child: Text(
                          'Visit Qree Store',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 18,
                              left: 20,
                              right: 20,
                              bottom: 40,
                            ),
                            child: Center(
                              child: BarcodeWidget(
                                barcode: Barcode.qrCode(
                                    errorCorrectLevel:
                                        BarcodeQRCorrectionLevel.high),
                                data: url,
                                width: 250,
                                height: 250,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
          ListTile(
            title: Text(
              'About Us',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            subtitle: const Text(urlHomePage),
            onTap: () {
              launchUrl(
                Uri.parse(urlHomePage),
                mode: LaunchMode.externalApplication,
              );
              // launchUrl(Uri(
              //   scheme: 'mailto',
              //   path: emailDeveloper,
              //   queryParameters: {'subject': 'Inquiry:$appName'},
              // ));
            },
          ),
          ListTile(
            title: Text(
              'App Icons',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            subtitle:
                const Text("Ui icons created by Rizki Ahmad Fauzi - Flaticon"),
            onTap: () {
              launchUrl(Uri.parse(urlAppIconSource));
            },
          ),
          ListTile(
            title: Text(
              'Store Background Image',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            subtitle: const Text("Photo by David Dvořáček at unsplash.com"),
            onTap: () {
              launchUrl(Uri.parse(urlStoreImageSource));
            },
          ),
          ListTile(
            title: Text(
              'No Responsibility',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            subtitle: const Text(
                'The Company assumes no responsibility for errors or omissions '
                'in the contents of the Service. (tap for the full text).'),
            onTap: () {
              launchUrl(Uri.parse(urlDisclaimer));
            },
          ),
          ListTile(
            title: Text(
              'No Personal Data Collected',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            subtitle: const Text('We do not collect any Personal Data. '
                'We do not collect any Usage Data (tap for the full text).'),
            onTap: () {
              launchUrl(Uri.parse(urlPrivacyPolicy));
            },
          ),
        ],
      ),
    );
  }
}
