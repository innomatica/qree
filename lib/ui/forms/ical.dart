import 'package:flutter/material.dart';

import '../../model/qritem.dart' show QrItem, QrContent;
import '../qritem/model.dart';

class IcalDetails extends StatefulWidget {
  final QrItem item;
  final QrItemViewModel model;

  const IcalDetails({super.key, required this.item, required this.model});

  @override
  State<IcalDetails> createState() => _IcalDetailsState();
}

class _IcalDetailsState extends State<IcalDetails> {
  final _formKey = GlobalKey<FormState>();
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
    _descriptionController.text = widget.item.content.description ?? '';
    _locationController.text = widget.item.content.location ?? '';
    // start date and time in local
    _startDate = widget.item.content.start != null
        ? DateTime.parse(widget.item.content.start!)
        : DateTime.now().add(const Duration(days: 1));
    _startDateController.text = _startDate.toIso8601String().split('T')[0];
    _startTime = TimeOfDay.fromDateTime(_startDate);
    _startTimeController.text = _startTime.toString().substring(10, 15);
    // end date and time in local
    _endDate = widget.item.content.end != null
        ? DateTime.parse(widget.item.content.end!)
        : DateTime.now().add(const Duration(days: 1, hours: 1));
    _endDateController.text = _endDate.toIso8601String().split('T')[0];
    _endTime = TimeOfDay.fromDateTime(_endDate);
    _endTimeController.text = _endTime.toString().substring(10, 15);
  }

  @override
  dispose() {
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
                  hintText: 'Weekend Meetup',
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
                  hintText: 'Spice & Slice at 8pm',
                ),
              ),
              // description
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  label: Text('description'),
                  hintText: 'Short description',
                ),
                maxLines: 3,
              ),
              // location
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  label: Text('location'),
                  hintText: 'Event venue',
                ),
              ),
              // start
              Row(
                spacing: 16.0,
                children: [
                  Expanded(
                    // start date
                    child: TextField(
                      controller: _startDateController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate,
                          firstDate: _startDate,
                          lastDate: _startDate.add(Duration(days: 180)),
                        );
                        if (picked != null) {
                          _startDate = picked;
                          if (_startDate.isAfter(_endDate)) {
                            _endDate = _startDate;
                          }
                          _startDateController.text = _startDate
                              .toIso8601String()
                              .split('T')[0];
                          setState(() {});
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text('start date'),
                      ),
                    ),
                  ),
                  Expanded(
                    // start time
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
                          _startTimeController.text = _startTime
                              .toString()
                              .substring(10, 15);
                          setState(() {});
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text('start time'),
                      ),
                    ),
                  ),
                ],
              ),
              // end
              Row(
                spacing: 8.0,
                children: [
                  Expanded(
                    // end date
                    child: TextField(
                      controller: _endDateController,
                      readOnly: true,
                      textAlign: TextAlign.center,
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _endDate,
                          firstDate: _startDate,
                          lastDate: _endDate.add(Duration(days: 180)),
                        );
                        if (picked != null) {
                          _endDate = picked;
                          _endDateController.text = _endDate
                              .toIso8601String()
                              .split('T')[0];
                          setState(() {});
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text('end date'),
                      ),
                    ),
                  ),
                  Expanded(
                    // end time
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
                          _endTimeController.text = _endTime
                              .toString()
                              .substring(10, 15);
                          setState(() {});
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text('end time'),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // combine Date and Time in local
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
                      final item = widget.item;
                      item.content = QrContent(
                        description: _descriptionController.text,
                        location: _locationController.text,
                        start: startTime.toIso8601String(),
                        end: _endDateController.text == ''
                            ? null
                            : endTime.toIso8601String(),
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
