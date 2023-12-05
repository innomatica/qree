import 'package:flutter/material.dart';

import '../../models/qritem.dart';
import '../../services/sqlite.dart';

class UrlDetails extends StatefulWidget {
  final QrItem item;
  const UrlDetails(this.item, {super.key});

  @override
  State<UrlDetails> createState() => _UrlDetailsState();
}

class _UrlDetailsState extends State<UrlDetails> {
  final _db = SqliteService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _urlController = TextEditingController();
  late String _site;

  @override
  initState() {
    super.initState();
    _titleController.text = widget.item.title;
    _site = widget.item.info['site'] ?? siteType.keys.first;
    _urlController.text = widget.item.info['url'] ?? '';
  }

  @override
  dispose() {
    _titleController.dispose();
    _urlController.dispose();
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
                  hintText: 'Please check my page',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter item title';
                  }
                  return null;
                },
              ),
              // site type
              const SizedBox(
                height: 8.0,
              ),
              DropdownButton<String>(
                value: _site,
                isExpanded: true,
                onChanged: (value) {
                  if (value != null) {
                    _site = value;
                    _urlController.text = siteType[_site]!;
                    setState(() {});
                  }
                },
                items: siteType.keys
                    .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                    label: Text('url'),
                    hintText: 'https://www.example.com/mypage'),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty || value.contains('username')) {
                      return 'Please enter valid url';
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
                      item.title = _titleController.text;
                      item.info = {
                        'site': _site,
                        'url': _urlController.text,
                        'data': _urlController.text,
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
