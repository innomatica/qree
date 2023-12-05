import 'package:flutter/material.dart';

import '../../models/qritem.dart';
import '../../services/sqlite.dart';

class IcalDetails extends StatefulWidget {
  final QrItem item;
  const IcalDetails(this.item, {super.key});

  @override
  State<IcalDetails> createState() => _IcalDetailsState();
}

class _IcalDetailsState extends State<IcalDetails> {
  final _db = SqliteService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _startTimeController = TextEditingController();
  late DateTime _startDate;
  late TimeOfDay _startTime;
  final _endDateController = TextEditingController();
  final _endTimeController = TextEditingController();
  late DateTime _endDate;
  late TimeOfDay _endTime;

  @override
  initState() {
    super.initState();
    _descriptionController.text = widget.item.info['description'] ?? '';
    _locationController.text = widget.item.info['location'] ?? '';
    _titleController.text = widget.item.title;
    // start date and time
    _startDate = widget.item.info['startTime'] != null
        ? DateTime.parse(widget.item.info['startTime'])
        : DateTime.now();
    // _startDate = DateTime.now();
    _startDateController.text = _startDate.toIso8601String().split('T')[0];
    _startTime = widget.item.info['startTime'] != null
        ? TimeOfDay.fromDateTime(_startDate)
        : TimeOfDay.now();
    _startTimeController.text = _startTime.toString().substring(10, 15);
    // end date and time
    _endDate = widget.item.info['endTime'] != null
        ? DateTime.parse(widget.item.info['endTime'])
        : DateTime.now().add(const Duration(hours: 1));
    // _endDate = DateTime.now();
    _endDateController.text = widget.item.info['endTime'] != null
        ? _endDate.toIso8601String().split('T')[0]
        : '';
    _endTime = widget.item.info['endTime'] != null
        ? TimeOfDay.fromDateTime(_endDate)
        : TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 1)));
    _endTimeController.text = widget.item.info['endTime'] != null
        ? _endTime.toString().substring(10, 15)
        : '';
  }

  @override
  dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _startTimeController.dispose();
    _endDateController.dispose();
    _endTimeController.dispose();
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
                  hintText: 'Weekend Meetup',
                ),
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter item title';
                  }
                  return null;
                },
              ),
              // description (optional)
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                    label: Text('description'), hintText: 'Short description'),
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                    label: Text('location'), hintText: 'Event venue'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _startDateController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          // firstDate: DateTime.now(),
                          firstDate: _startDate,
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          _startDate = picked;
                          if (_startDate.isAfter(_endDate)) {
                            _endDate = _startDate;
                          }
                          _startDateController.text =
                              _startDate.toIso8601String().split('T')[0];
                          setState(() {});
                        }
                      },
                      decoration:
                          const InputDecoration(label: Text('start date')),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _startTimeController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _startTime,
                        );
                        if (picked != null) {
                          _startTime = picked;
                          _startTimeController.text =
                              _startTime.toString().substring(10, 15);
                          setState(() {});
                        }
                      },
                      decoration:
                          const InputDecoration(label: Text('start time')),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _endDateController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          _endDate = picked;
                          _endDateController.text =
                              _endDate.toIso8601String().split('T')[0];
                          setState(() {});
                        }
                      },
                      decoration:
                          const InputDecoration(label: Text('end date')),
                    ),
                  ),
                  const SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _endTimeController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      onTap: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _endTime,
                        );
                        if (picked != null) {
                          _endTime = picked;
                          _endTimeController.text =
                              _endTime.toString().substring(10, 15);
                          setState(() {});
                        }
                      },
                      decoration:
                          const InputDecoration(label: Text('end time')),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      DateTime startTime = DateTime(
                        _startDate.year,
                        _startDate.month,
                        _startDate.day,
                        _startTime.hour,
                        _startTime.minute,
                      );
                      DateTime endTime = DateTime(
                        _endDate.year,
                        _endDate.month,
                        _endDate.day,
                        _endTime.hour,
                        _endTime.minute,
                      );
                      String data = 'BEGIN:VCALENDAR\n';
                      data =
                          '$data VERSION:2.0\n PRODID:com.innomatic.qreeapp\n'
                          'BEGIN:VEVENT\nDTSTART:'
                          '${startTime.toUtc().toIso8601String().split('.')[0].replaceAll(RegExp(r'[:-]'), '')}'
                          'Z\nDTEND:'
                          '${endTime.toUtc().toIso8601String().split('.')[0].replaceAll(RegExp(r'[:-]'), '')}'
                          'Z\nSUMMARY:${_titleController.text}\n'
                          'DESCRIPTION:${_descriptionController.text}\n'
                          'LOCATION:${_locationController.text}\n'
                          'END:VEVENT\nEND:VCALENDAR\n';
                      final item = widget.item;
                      item.title = _titleController.text;
                      item.info = {
                        'description': _descriptionController.text,
                        'location': _locationController.text,
                        'startTime': startTime.toIso8601String(),
                        'endTime': _endDateController.text == ''
                            ? null
                            : endTime.toIso8601String(),
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
