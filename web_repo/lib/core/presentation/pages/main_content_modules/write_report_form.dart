import 'package:flutter/material.dart';

class WriteReportForm extends StatefulWidget {
  final VoidCallback onCancel;
  final List<String> patients; // New: List of patients for autocomplete

  const WriteReportForm({
    super.key,
    required this.onCancel,
    required this.patients, // New: Required patients list
  });

  @override
  State<WriteReportForm> createState() => _WriteReportFormState();
}

class _WriteReportFormState extends State<WriteReportForm> {
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _prescriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    // Optionally pre-fill if a patient was selected from history, etc.
    // For now, it starts empty.
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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

  void _saveReport() {
    // Capture values before calling onCancel, which might dispose the widget
    final String patientName = _patientNameController.text;
    final String note = _noteController.text;
    final String prescription = _prescriptionController.text;

    print('Report Saved:');
    print('Patient Name: $patientName');
    print('Date: $_selectedDate');
    print('Time: $_selectedTime');
    print('Note: $note');
    print('Prescriptions/Other: $prescription');
    widget.onCancel(); // Hide the form after saving
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _noteController.dispose();
    _prescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final labelColor = isDark ? Colors.white70 : Colors.black54;
    final hintColor = isDark ? Colors.white54 : Colors.grey[600];
    final inputBorderColor = isDark ? Colors.white54 : Colors.grey;
    final focusedInputBorderColor = theme.primaryColor;


    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Write Patient Report',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textColor, // Dynamic color
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Fill in the details for the patient\'s visit.',
              style: TextStyle(
                fontSize: 16,
                color: hintColor, // Dynamic color
              ),
            ),
            const SizedBox(height: 32),

            // Patient Name Autocomplete
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return widget.patients.where((String option) {
                  return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                _patientNameController.text = selection;
                FocusScope.of(context).unfocus(); // Dismiss keyboard
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextFormField(
                  controller: fieldTextEditingController,
                  focusNode: fieldFocusNode,
                  style: TextStyle(color: textColor), // Dynamic color
                  decoration: InputDecoration(
                    labelText: 'Patient Name',
                    labelStyle: TextStyle(color: labelColor), // Dynamic color
                    hintText: 'Enter patient\'s full name...',
                    hintStyle: TextStyle(color: hintColor), // Dynamic color
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: inputBorderColor), // Dynamic color
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: inputBorderColor), // Dynamic color
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: focusedInputBorderColor), // Dynamic color
                    ),
                  ),
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
                              title: Text(option, style: TextStyle(color: textColor)), // Dynamic color
                              tileColor: theme.cardColor, // Dynamic color
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
                    title: Text('Date', style: TextStyle(color: textColor)), // Dynamic color
                    subtitle: Text(
                      '${_selectedDate.toLocal().day}/${_selectedDate.toLocal().month}/${_selectedDate.toLocal().year}',
                      style: TextStyle(color: hintColor), // Dynamic color
                    ),
                    trailing: Icon(Icons.calendar_today, color: labelColor), // Dynamic color
                    onTap: () => _selectDate(context),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('Time', style: TextStyle(color: textColor)), // Dynamic color
                    subtitle: Text(
                      _selectedTime.format(context),
                      style: TextStyle(color: hintColor), // Dynamic color
                    ),
                    trailing: Icon(Icons.access_time, color: labelColor), // Dynamic color
                    onTap: () => _selectTime(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Notes Area
            TextFormField(
              controller: _noteController,
              maxLines: 5,
              style: TextStyle(color: textColor), // Dynamic color
              decoration: InputDecoration(
                labelText: 'Notes',
                labelStyle: TextStyle(color: labelColor), // Dynamic color
                hintText: 'Enter general notes about the patient\'s visit...',
                hintStyle: TextStyle(color: hintColor), // Dynamic color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: inputBorderColor), // Dynamic color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: inputBorderColor), // Dynamic color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: focusedInputBorderColor), // Dynamic color
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Prescriptions and Other Area
            TextFormField(
              controller: _prescriptionController,
              maxLines: 5,
              style: TextStyle(color: textColor), // Dynamic color
              decoration: InputDecoration(
                labelText: 'Prescriptions / Other',
                labelStyle: TextStyle(color: labelColor), // Dynamic color
                hintText: 'Enter prescriptions, follow-up instructions, etc...',
                hintStyle: TextStyle(color: hintColor), // Dynamic color
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: inputBorderColor), // Dynamic color
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: inputBorderColor), // Dynamic color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(color: focusedInputBorderColor), // Dynamic color
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: widget.onCancel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey, // Background color
                    foregroundColor: isDark ? Colors.white : Colors.black, // Dynamic text color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _saveReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor, // Background color
                    foregroundColor: isDark ? Colors.white : Colors.black, // Dynamic text color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Save Report'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
