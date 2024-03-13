import 'package:flutter/material.dart';

import '../../models/qritem.dart';
import '../../services/sqlite.dart';

class TelDetails extends StatefulWidget {
  final QrItem item;
  const TelDetails(this.item, {super.key});

  @override
  State<TelDetails> createState() => _TelDetailsState();
}

class _TelDetailsState extends State<TelDetails> {
  final _db = SqliteService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  initState() {
    super.initState();
    _titleController.text = widget.item.title;
    _phoneController.text = widget.item.info['phone'] ?? '';
  }

  @override
  dispose() {
    _titleController.dispose();
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
                controller: _titleController,
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
              // text
              TextFormField(
                initialValue: widget.item.text,
                onChanged: (value) => widget.item.text = value,
                decoration: const InputDecoration(
                    label: Text('text'), hintText: '123-456-7890'),
              ),
              // phone number
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                    label: Text('phone number'), hintText: '+1-888-222-1111'),
                validator: (value) {
                  if (value != null) {
                    debugPrint(value);
                    final regex = RegExp(
                        r'^([+]?\d{1,2}[-\s]?|)\d{3}[-\s]?\d{3}[-\s]?\d{4}$');
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
                      item.title = _titleController.text;
                      item.info = {
                        'phone': _phoneController.text,
                        'data': 'tel:${_phoneController.text}',
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
