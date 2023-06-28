import 'package:flutter/material.dart';
import 'package:qreeapp/models/qritem.dart';
import 'package:qreeapp/services/sqlite.dart';

class VcardDetails extends StatefulWidget {
  final QrItem item;
  const VcardDetails(this.item, {Key? key}) : super(key: key);

  @override
  State<VcardDetails> createState() => _VcardDetailsState();
}

class _VcardDetailsState extends State<VcardDetails> {
  final _db = SqliteService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _companyController = TextEditingController();
  final _jobTitleController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  initState() {
    super.initState();
    _titleController.text = widget.item.title;
    _firstNameController.text = widget.item.info['firstName'] ?? '';
    _lastNameController.text = widget.item.info['lastName'] ?? '';
    _companyController.text = widget.item.info['company'] ?? '';
    _jobTitleController.text = widget.item.info['jobTitle'] ?? '';
    _emailController.text = widget.item.info['email'] ?? '';
    _phoneController.text = widget.item.info['phone'] ?? '';
    _addressController.text = widget.item.info['address'] ?? '';
    _websiteController.text = widget.item.info['website'] ?? '';
  }

  @override
  dispose() {
    _titleController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
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
              Row(
                children: [
                  // first name
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                          label: Text('first name'), hintText: 'John'),
                      validator: (value) {
                        if (value != null) {
                          if (value.isEmpty) {
                            return 'Please enter your first name';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  // last name
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                          label: Text('last name'), hintText: 'Doe'),
                    ),
                  ),
                ],
              ),
              // company
              TextFormField(
                controller: _companyController,
                decoration: const InputDecoration(
                    label: Text('company'), hintText: 'Acme Inc.'),
              ),
              // job title
              TextFormField(
                controller: _jobTitleController,
                decoration: const InputDecoration(
                    label: Text('job title'), hintText: 'Sales Manager'),
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
              // email address
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
                      String data = 'BEGIN:VCARD\nVERSION:4.0\n'
                          'FN:${_firstNameController.text} '
                          '${_lastNameController.text}\n'
                          'TITLE:${_jobTitleController.text}\n'
                          'ORG;TYPE=work:${_companyController.text}\n'
                          'EMAIL;TYPE=work:${_emailController.text}\n'
                          'TEL;TYPE=work:${_phoneController.text}\n'
                          'ADR;TYPE=work:${_addressController.text}\n'
                          'URL;TYPE=work:${_websiteController.text}\nEND:VCARD';

                      item.title = _titleController.text;
                      item.info = {
                        'firstName': _firstNameController.text,
                        'lastName': _lastNameController.text,
                        'company': _companyController.text,
                        'jobTitle': _jobTitleController.text,
                        'email': _emailController.text,
                        'phone': _phoneController.text,
                        'address': _addressController.text,
                        'website': _websiteController.text,
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
