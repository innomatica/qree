import 'package:flutter/material.dart';
import 'package:qreeapp/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
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
        const SizedBox(height: 12, width: 0),
      ],
    );
  }
}
