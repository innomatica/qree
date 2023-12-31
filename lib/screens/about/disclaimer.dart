import 'package:flutter/material.dart';
import 'package:qreeapp/shared/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
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
        const SizedBox(height: 12, width: 0),
      ],
    );
  }
}
