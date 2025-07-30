import 'package:flutter/material.dart';

import '../../model/qritem.dart' show QrItem, QrContent, WifiAuth;
import '../qritem/model.dart';

class WifiDetails extends StatefulWidget {
  final QrItem item;
  final QrItemViewModel model;

  const WifiDetails({super.key, required this.item, required this.model});

  @override
  State<WifiDetails> createState() => _WifiDetailsState();
}

// https://en.wikipedia.org/wiki/QR_code#Joining_a_Wi%E2%80%91Fi_network
// https://github.com/zxing/zxing/wiki/Barcode-Contents#wi-fi-network-config-android-ios-11
class _WifiDetailsState extends State<WifiDetails> {
  final _formKey = GlobalKey<FormState>();
  final _protocolController = TextEditingController();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool _isSsidHidden;
  bool _hidePassword = true;

  @override
  initState() {
    super.initState();
    _protocolController.text = widget.item.content.protocol ?? 'WPA';
    _ssidController.text = widget.item.content.ssid ?? '';
    _passwordController.text = widget.item.content.password ?? '';
    _isSsidHidden = widget.item.content.hidden == 'true';
  }

  @override
  dispose() {
    _protocolController.dispose();
    _ssidController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint(widget.item.toString());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // title
              TextFormField(
                initialValue: widget.item.title,
                onChanged: (value) => widget.item.title = value,
                decoration: const InputDecoration(
                  label: Text('title'),
                  hintText: 'Use My Wi-Fi',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter item title';
                  }
                  return null;
                },
              ),
              // authentication protocol
              Row(
                children: [
                  DropdownMenu<WifiAuth>(
                    controller: _protocolController,
                    inputDecorationTheme: InputDecorationTheme(filled: false),
                    dropdownMenuEntries: WifiAuth.values
                        .map((e) => DropdownMenuEntry(value: e, label: e.name))
                        .toList(),
                    label: Text('authentication'),
                  ),
                ],
              ),
              // ssid
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ssidController,
                      decoration: const InputDecoration(
                        label: Text('ssid'),
                        hintText: 'My Access Point',
                      ),
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'Please enter SSID';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'hidden',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        value: _isSsidHidden,
                        onChanged: (value) {
                          _isSsidHidden = value ?? false;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ],
              ),
              // password
              TextFormField(
                controller: _passwordController,
                obscureText: _hidePassword,
                decoration: InputDecoration(
                  label: const Text('password'),
                  suffixIcon: IconButton(
                    icon: _hidePassword
                        ? const Icon(Icons.visibility_rounded)
                        : const Icon(Icons.visibility_off_rounded),
                    onPressed: () {
                      _hidePassword = !_hidePassword;
                      setState(() {});
                    },
                  ),
                ),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return 'Please enter password';
                    }
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final item = widget.item;
                      item.content = QrContent(
                        protocol: _protocolController.text,
                        ssid: _ssidController.text,
                        password: _passwordController.text,
                        hidden: _isSsidHidden ? 'true' : 'false',
                      );
                      widget.model.upsert(item);
                      Navigator.of(context).pop(true);
                    }
                  },
                  child: widget.item.id == null
                      ? const Text('Create New Entry')
                      : const Text('Update Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
