import 'package:flutter/material.dart';

import '../../model/qritem.dart' show QrItem, QrContent;
import '../qritem/model.dart';

class UrlDetails extends StatefulWidget {
  final QrItem item;
  final QrItemViewModel model;

  const UrlDetails({super.key, required this.item, required this.model});

  @override
  State<UrlDetails> createState() => _UrlDetailsState();
}

class _UrlDetailsState extends State<UrlDetails> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  @override
  initState() {
    super.initState();
    _urlController.text = widget.item.content.url ?? '';
  }

  @override
  dispose() {
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
                initialValue: widget.item.title,
                onChanged: (value) => widget.item.title = value,
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
              // label
              TextFormField(
                initialValue: widget.item.label,
                onChanged: (value) => widget.item.label = value,
                decoration: const InputDecoration(
                  label: Text('label'),
                  hintText: 'www.example.com',
                ),
              ),
              // url
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  label: Text('url'),
                  hintText: 'https://www.example.com/mypage',
                ),
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
                      item.content = QrContent(url: _urlController.text);
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
