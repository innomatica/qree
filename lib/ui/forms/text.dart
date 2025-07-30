import 'package:flutter/material.dart';

import '../../model/qritem.dart' show QrItem, QrContent;
import '../qritem/model.dart';

class TextDetails extends StatefulWidget {
  final QrItem item;
  final QrItemViewModel model;

  const TextDetails({super.key, required this.item, required this.model});

  @override
  State<TextDetails> createState() => _TextDetailsState();
}

class _TextDetailsState extends State<TextDetails> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();

  @override
  initState() {
    super.initState();
    _contentController.text = widget.item.content.text ?? '';
  }

  @override
  dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  hintText: 'Things to Share',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter item title';
                  }
                  return null;
                },
              ),
              // content
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(label: Text('content')),
                maxLines: 3,
                validator: (value) {
                  if (value != null) {
                    debugPrint(value);
                    if (value.isEmpty) {
                      return 'Please enter content';
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
                      item.content = QrContent(text: _contentController.text);
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
