import 'package:flutter/material.dart';

import '../../model/qritem.dart' show QrItem, QrContent;
import '../qritem/model.dart';

class TelDetails extends StatefulWidget {
  final QrItem item;
  final QrItemViewModel model;

  const TelDetails({super.key, required this.item, required this.model});

  @override
  State<TelDetails> createState() => _TelDetailsState();
}

class _TelDetailsState extends State<TelDetails> {
  final _formKey = GlobalKey<FormState>();
  // final _titleController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  initState() {
    super.initState();
    _phoneController.text = widget.item.content.phone ?? '';
  }

  @override
  dispose() {
    _phoneController.dispose();
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
                  hintText: 'My Phone Number',
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
                  hintText: '123-456-7890',
                ),
              ),
              // phone number
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  label: Text('phone number'),
                  hintText: '+1-888-222-1111',
                ),
                validator: (value) {
                  if (value != null) {
                    debugPrint(value);
                    final regex = RegExp(
                      r'^([+]?\d{1,2}[-\s]?|)\d{3}[-\s]?\d{3}[-\s]?\d{4}$',
                    );
                    if (value.isEmpty || !regex.hasMatch(value)) {
                      return 'Please enter valid phone number';
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
                      item.content = QrContent(phone: _phoneController.text);
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
