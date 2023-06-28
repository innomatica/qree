import 'package:flutter/material.dart';
import 'package:qreeapp/models/qritem.dart';
import 'package:qreeapp/services/sqlite.dart';

class TextDetails extends StatefulWidget {
  final QrItem item;
  const TextDetails(this.item, {Key? key}) : super(key: key);

  @override
  State<TextDetails> createState() => _TextDetailsState();
}

class _TextDetailsState extends State<TextDetails> {
  final _db = SqliteService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  initState() {
    super.initState();
    _titleController.text = widget.item.title;
    _contentController.text = widget.item.info['content'] ?? '';
  }

  @override
  dispose() {
    _titleController.dispose();
    _contentController.dispose();
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
                      item.title = _titleController.text;
                      item.info = {
                        'content': _contentController.text,
                        'data': _contentController.text,
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
