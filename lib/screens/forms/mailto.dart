import 'package:flutter/material.dart';
import 'package:qreeapp/models/qritem.dart';
import 'package:qreeapp/services/sqlite.dart';

class MailtoDetails extends StatefulWidget {
  final QrItem item;
  const MailtoDetails(this.item, {super.key});

  @override
  State<MailtoDetails> createState() => _MailtoDetailsState();
}

class _MailtoDetailsState extends State<MailtoDetails> {
  final _db = SqliteService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  initState() {
    super.initState();
    _titleController.text = widget.item.title;
    _emailController.text = widget.item.info['email'] ?? '';
    _subjectController.text = widget.item.info['subject'] ?? '';
    _bodyController.text = widget.item.info['body'] ?? '';
  }

  @override
  dispose() {
    _titleController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _bodyController.dispose();
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
                  hintText: 'Send Me an Email',
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
                    label: Text('text'), hintText: 'jane.doe@example.com'),
              ),
              // email address
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                    label: Text('email address'),
                    hintText: 'john.doe@email.com'),
                validator: (value) {
                  if (value != null) {
                    debugPrint(value);
                    final regex = RegExp(r'^\S+@\S+\.\S+$');
                    if (value.isEmpty || !regex.hasMatch(value)) {
                      return 'Please enter valid email address';
                    }
                  }
                  return null;
                },
              ),
              // subject
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(
                  label: Text('subject'),
                  hintText: 'Inquiry: 2022 catalog',
                ),
              ),
              // body
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  label: Text('body'),
                  hintText: 'Hello,',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final item = widget.item;
                      String data = 'mailto:${_emailController.text}';
                      if (_subjectController.text.isNotEmpty) {
                        data = '$data'
                            '?subject=${Uri.encodeComponent(_subjectController.text)}';
                        if (_bodyController.text.isNotEmpty) {
                          data = '$data'
                              '&body=${Uri.encodeComponent(_bodyController.text)}';
                        }
                      }
                      item.title = _titleController.text;
                      item.info = {
                        'email': _emailController.text,
                        'subject': _subjectController.text,
                        'body': _bodyController.text,
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
