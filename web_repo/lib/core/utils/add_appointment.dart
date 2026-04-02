import 'package:flutter/material.dart';

class AddAppointmentWidget extends StatefulWidget {
  final VoidCallback? onCancel;
  final List<String> patients;

  const AddAppointmentWidget({
    super.key, 
    this.onCancel,
    required this.patients,
  });

  @override
  State<AddAppointmentWidget> createState() => _AddAppointmentWidgetState();
}

class _AddAppointmentWidgetState extends State<AddAppointmentWidget> {
  final _formKey = GlobalKey<FormState>();
  final _userIdController = TextEditingController();
  final _timeController = TextEditingController();
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _timeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process adding appointment logic
      final userId = _userIdController.text;
      final time = _timeController.text;
      final note = _noteController.text;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adding Appointment for User: $userId at $time')),
      );
      
      // Clear fields instead of popping if embedded
      _userIdController.clear();
      _timeController.clear();
      _noteController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add New Appointment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return widget.patients.where((String patient) {
                  return patient.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                _userIdController.text = selection;
              },
              fieldViewBuilder: (BuildContext context, TextEditingController fieldTextEditingController, FocusNode fieldFocusNode, VoidCallback onFieldSubmitted) {
                // Sync the field controller with our main controller
                fieldTextEditingController.addListener(() {
                  _userIdController.text = fieldTextEditingController.text;
                });
                
                return TextFormField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  decoration: const InputDecoration(
                    labelText: 'Patient Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select or enter a patient name';
                    }
                    return null;
                  },
                );
              },
              optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String option = options.elementAt(index);
                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _timeController,
              decoration: const InputDecoration(
                labelText: 'Time (HH:MM)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.access_time),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the time';
                }
                // Basic time format validation (HH:MM)
                final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
                if (!timeRegex.hasMatch(value)) {
                  return 'Please enter time in HH:MM format (24-hour)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.note),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a note';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submitForm,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Add Appointment'),
            ),
            const SizedBox(height: 16),
            if (widget.onCancel != null)
              OutlinedButton(
                onPressed: widget.onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Cancel'),
              ),
          ],
        ),
      ),
    );
  }
}

// Helper function to show this as a dialog
void showAddAppointmentDialog(BuildContext context, List<String> patients) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: AddAppointmentWidget(patients: patients),
      ),
    ),
  );
}
