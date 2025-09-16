import 'package:flutter/material.dart';
import 'package:qree/shared/constants.dart';

import '../../model/qritem.dart' show QrItem, QrContent;
import '../qritem/model.dart';

class VcardDetails extends StatefulWidget {
  final QrItem item;
  final QrItemViewModel model;

  const VcardDetails({super.key, required this.item, required this.model});

  @override
  State<VcardDetails> createState() => _VcardDetailsState();
}

class _VcardDetailsState extends State<VcardDetails> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  initState() {
    super.initState();
    _nameController.text = widget.item.content.name ?? '';
    _companyController.text = widget.item.content.company ?? '';
    _jobTitleController.text = widget.item.content.title ?? '';
    _emailController.text = widget.item.content.email ?? '';
    _phoneController.text = widget.item.content.phone ?? '';
    _addressController.text = widget.item.content.address ?? '';
    _websiteController.text = widget.item.content.url ?? '';
  }

  @override
  dispose() {
    _nameController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _websiteController.dispose();
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
                  hintText: 'Social Impact Advisor',
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
                  hintText: 'John Doe',
                ),
              ),
              // name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  label: Text('name'),
                  hintText: 'John Doe',
                ),
                validator: (value) {
                  if (value != null) {
                    if (value.isEmpty) {
                      return 'Please enter your full name';
                    }
                  }
                  return null;
                },
              ),
              // company
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                  label: Text('company'),
                  hintText: 'Acme Inc.',
                ),
              ),
              // job title
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                  label: Text('job title'),
                  hintText: 'Sales Manager',
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
                    final regex = emailRegEx;
                    if (value.isEmpty || !regex.hasMatch(value)) {
                      return 'Please enter valid email address';
                    }
                  }
                  return null;
                },
              ),
              // email address
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  label: Text('phone number'),
                  hintText: '+1-888-222-1111',
                ),
                validator: (value) {
                  if (value != null) {
                    debugPrint(value);
                    final regex = phoneRegEx;
                    if (value.isEmpty || !regex.hasMatch(value)) {
                      return 'Please enter valid phone number';
                    }
                  }
                  return null;
                },
              ),
              // address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  label: Text('address'),
                  hintText: '100 Wellington St;Ottawa ON;K1A 0A9 Canada',
                ),
              ),
              TextFormField(
                controller: _websiteController,
                decoration: const InputDecoration(
                  label: Text('website'),
                  hintText: 'https://example.com',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final item = widget.item;
                      item.content = QrContent(
                        name: _nameController.text,
                        company: _companyController.text,
                        title: _jobTitleController.text,
                        email: _emailController.text,
                        phone: _phoneController.text,
                        address: _addressController.text,
                        url: _websiteController.text,
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
