import 'package:flutter/material.dart';

import '../../model/qritem.dart' show QrItem, QrContent;
import '../qritem/model.dart';

class MailtoDetails extends StatefulWidget {
  final QrItem item;
  final QrItemViewModel model;

  const MailtoDetails({super.key, required this.item, required this.model});

  @override
  State<MailtoDetails> createState() => _MailtoDetailsState();
}

class _MailtoDetailsState extends State<MailtoDetails> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  initState() {
    super.initState();
    _emailController.text = widget.item.content.email ?? '';
    _subjectController.text = widget.item.content.subject ?? '';
    _bodyController.text = widget.item.content.message ?? '';
  }

  @override
  dispose() {
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
                initialValue: widget.item.title,
                onChanged: (value) => widget.item.title = value,
                decoration: const InputDecoration(
                  label: Text('title'),
                  hintText: 'Send me email',
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
                  hintText: 'jane.doe@example.com',
                ),
              ),
              // email address
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  label: Text('email address'),
                  hintText: 'john.doe@email.com',
                ),
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
                maxLines: 3,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final item = widget.item;
                      item.content = QrContent(
                        email: _emailController.text,
                        subject: _subjectController.text,
                        message: _bodyController.text,
                      );
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
