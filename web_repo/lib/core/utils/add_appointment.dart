import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Removed: For date formatting

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
  final TextEditingController _patientNameController = TextEditingController(); // Renamed from _userIdController
  DateTime _selectedDate = DateTime.now(); // New: For date selection
  TimeOfDay _selectedTime = TimeOfDay.now(); // New: For time selection
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _patientNameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)), // Allow past year
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)), // Allow next 5 years
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process adding appointment logic
      final patientName = _patientNameController.text;
      // final appointmentDateTime = DateTime( // Removed DateFormat usage
      //   _selectedDate.year,
      //   _selectedDate.month,
      //   _selectedDate.day,
      //   _selectedTime.hour,
      //   _selectedTime.minute,
      // );
      final note = _noteController.text;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Appointment for $patientName on ${_selectedDate.toLocal().toString().split(' ')[0]} at ${_selectedTime.format(context)} added!')), // Reverted to basic string formatting
      );
      
      // Clear fields or navigate back
      _patientNameController.clear();
      _noteController.clear();
      if (widget.onCancel != null) {
        widget.onCancel!();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.white70 : Colors.black54;
    final hintColor = isDark ? Colors.white54 : Colors.grey[600];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Add New Appointment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Schedule a new appointment for a patient.',
                style: TextStyle(
                  fontSize: 16,
                  color: hintColor,
                ),
              ),
              const SizedBox(height: 32),

              // Patient Name Autocomplete
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
                  _patientNameController.text = selection;
                  FocusScope.of(context).unfocus();
                },
                fieldViewBuilder: (
                  BuildContext context,
                  TextEditingController fieldTextEditingController,
                  FocusNode fieldFocusNode,
                  VoidCallback onFieldSubmitted,
                ) {
                  _patientNameController.text = fieldTextEditingController.text;
                  return TextFormField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      labelText: 'Patient Name',
                      labelStyle: TextStyle(color: labelColor),
                      hintText: 'Enter patient\'s full name...',
                      hintStyle: TextStyle(color: hintColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: labelColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: labelColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: theme.primaryColor),
                      ),
                      prefixIcon: Icon(Icons.person, color: labelColor),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select or enter a patient name';
                      }
                      return null;
                    },
                    onChanged: (String value) {
                      _patientNameController.text = value;
                    },
                    onFieldSubmitted: (String value) {
                      onFieldSubmitted();
                    },
                  );
                },
                optionsViewBuilder: (
                  BuildContext context,
                  AutocompleteOnSelected<String> onSelected,
                  Iterable<String> options,
                ) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: Container(
                        width: 300, // Adjust width as needed
                        constraints: const BoxConstraints(maxHeight: 200),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option, style: const TextStyle(color: Colors.black)),
                                tileColor: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              // Date and Time Selection
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Date', style: TextStyle(color: textColor)),
                      subtitle: Text(
                        '${_selectedDate.toLocal().day}/${_selectedDate.toLocal().month}/${_selectedDate.toLocal().year}',
                        style: TextStyle(color: hintColor),
                      ),
                      trailing: Icon(Icons.calendar_today, color: labelColor),
                      onTap: () => _selectDate(context),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Time', style: TextStyle(color: textColor)),
                      subtitle: Text(
                        _selectedTime.format(context),
                        style: TextStyle(color: hintColor),
                      ),
                      trailing: Icon(Icons.access_time, color: labelColor),
                      onTap: () => _selectTime(context),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Note Area
              TextFormField(
                controller: _noteController,
                maxLines: 5,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: 'Appointment Note',
                  labelStyle: TextStyle(color: labelColor),
                  hintText: 'Enter details about the appointment...',
                  hintStyle: TextStyle(color: hintColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: labelColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: labelColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: theme.primaryColor),
                  ),
                  prefixIcon: Icon(Icons.note, color: labelColor),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a note for the appointment';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: widget.onCancel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Add Appointment'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper function to show this as a dialog (kept for compatibility if needed elsewhere)
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