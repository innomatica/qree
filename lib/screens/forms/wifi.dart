import 'package:flutter/material.dart';
import 'package:qreeapp/models/qritem.dart';
import 'package:qreeapp/services/sqlite.dart';

class WifiDetails extends StatefulWidget {
  final QrItem item;
  const WifiDetails(this.item, {super.key});

  @override
  State<WifiDetails> createState() => _WifiDetailsState();
}

// https://en.wikipedia.org/wiki/QR_code#Joining_a_Wi%E2%80%91Fi_network
// https://github.com/zxing/zxing/wiki/Barcode-Contents#wi-fi-network-config-android-ios-11
class _WifiDetailsState extends State<WifiDetails> {
  final _db = SqliteService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _ssidController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idController = TextEditingController();
  final _publicKeyController = TextEditingController();
  late bool _isSsidHidden;
  bool _hidePassword = true;

  @override
  initState() {
    super.initState();
    _titleController.text = widget.item.title;
    _ssidController.text = widget.item.info['ssid'] ?? '';
    _passwordController.text = widget.item.info['password'] ?? '';
    _idController.text = widget.item.info['id'] ?? '';
    _publicKeyController.text = widget.item.info['publicKey'] ?? '';
    _isSsidHidden = widget.item.info['hidden'] ?? false;
  }

  @override
  dispose() {
    _titleController.dispose();
    _ssidController.dispose();
    _passwordController.dispose();
    _idController.dispose();
    _publicKeyController.dispose();
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
                controller: _titleController,
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
              // ssid
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ssidController,
                      decoration: const InputDecoration(
                          label: Text('ssid'), hintText: 'My Access Point'),
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
                  Stack(
                    children: [
                      Positioned(
                        bottom: 35.0,
                        left: 12.0,
                        child: Text(
                          'hidden',
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                      Switch(
                        value: _isSsidHidden,
                        onChanged: (value) {
                          _isSsidHidden = value;
                          setState(() {});
                        },
                      ),
                    ],
                  )
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
                    )),
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
                      String data = 'WIFI:T:WPA;';
                      // data = data +
                      //     'S:${Uri.encodeComponent(_ssidController.text)};';
                      // if (_isSsidHidden) {
                      //   data = data + 'H:true;';
                      // }
                      // data = data +
                      //     'P:${Uri.encodeComponent(_passwordController.text)};';
                      // data = data + ';';
                      data = '$data'
                          'S:${Uri.encodeComponent(_ssidController.text)};';
                      if (_isSsidHidden) {
                        data = '$data H:true;';
                      }
                      data = '$data'
                          'P:${Uri.encodeComponent(_passwordController.text)};;';

                      final item = widget.item;
                      item.title = _titleController.text;
                      item.info = {
                        'ssid': _ssidController.text,
                        'password': _passwordController.text,
                        'hidden': _isSsidHidden,
                        'data': data,
                      };
                      _db.addQrItem(item);
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
