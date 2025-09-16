import 'package:flutter/material.dart';
import 'package:qree/shared/constants.dart';

import '../../model/qritem.dart' show QrItem, QrContent;
import '../qritem/model.dart';

class GeoDetails extends StatefulWidget {
  final QrItem item;
  final QrItemViewModel model;

  const GeoDetails({super.key, required this.item, required this.model});

  @override
  State<GeoDetails> createState() => _GeoDetailsState();
}

class _GeoDetailsState extends State<GeoDetails> {
  final _formKey = GlobalKey<FormState>();
  final _coordController = TextEditingController();

  @override
  initState() {
    super.initState();
    _coordController.text = widget.item.content.location ?? '';
  }

  @override
  dispose() {
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
                initialValue: widget.item.title,
                onChanged: (value) => widget.item.title = value,
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
              // label
              TextFormField(
                initialValue: widget.item.label,
                onChanged: (value) => widget.item.label = value,
                decoration: const InputDecoration(
                  label: Text('label'),
                  hintText: '123 Center Street',
                ),
              ),
              // coordinate
              TextFormField(
                controller: _coordController,
                decoration: const InputDecoration(
                  label: Text('coordinate(lat,lon)'),
                  hintText: '48.2010,16.3695',
                ),
                validator: (value) {
                  if (value != null) {
                    debugPrint(value);
                    final regex = geocodeRegEx;
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
                      item.content = QrContent(location: _coordController.text);
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
