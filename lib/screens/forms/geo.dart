import 'package:flutter/material.dart';
import 'package:qreeapp/models/qritem.dart';
import 'package:qreeapp/services/sqlite.dart';

//
// THIS FEATURE IS NOT RECOGNISED BY GOOGLE
//
class GeoDetails extends StatefulWidget {
  final QrItem item;
  const GeoDetails(this.item, {super.key});

  @override
  State<GeoDetails> createState() => _GeoDetailsState();
}

class _GeoDetailsState extends State<GeoDetails> {
  final _db = SqliteService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _coordController = TextEditingController();

  @override
  initState() {
    super.initState();
    _titleController.text = widget.item.title;
    _coordController.text = widget.item.info['coordinate'] ?? '';
  }

  @override
  dispose() {
    _titleController.dispose();
    _coordController.dispose();
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
                  hintText: 'My Place',
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
                controller: _coordController,
                decoration: const InputDecoration(
                    label: Text('coordinate'), hintText: '48.2010,16.3695'),
                validator: (value) {
                  if (value != null) {
                    debugPrint(value);
                    final regex = RegExp(
                        r'^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),\s*[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$');
                    if (value.isEmpty || !regex.hasMatch(value)) {
                      return 'Please enter valid coordinate';
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
                        'coordinate': _coordController.text,
                        'data': 'geo:${_coordController.text}',
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
