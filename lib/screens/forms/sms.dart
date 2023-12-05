import 'package:flutter/material.dart';
import 'package:qreeapp/models/qritem.dart';
import 'package:qreeapp/services/sqlite.dart';

class SmsDetails extends StatefulWidget {
  final QrItem item;
  const SmsDetails(this.item, {super.key});

  @override
  State<SmsDetails> createState() => _SmsDetailsState();
}

class _SmsDetailsState extends State<SmsDetails> {
  final _db = SqliteService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  initState() {
    super.initState();
    _titleController.text = widget.item.title;
    _phoneController.text = widget.item.info['phone'] ?? '';
    _messageController.text = widget.item.info['message'] ?? '';
  }

  @override
  dispose() {
    _titleController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
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
                  hintText: 'Text Me',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter item title';
                  }
                  return null;
                },
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
              // message
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  label: Text('sms message'),
                  hintText: 'Hello there',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter a message';
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
                        'message': _messageController.text,
                        'data': 'sms:${_phoneController.text}'
                            '?body=${Uri.encodeComponent(_messageController.text)}',
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
