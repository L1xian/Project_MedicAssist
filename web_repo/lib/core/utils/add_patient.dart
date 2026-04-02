import 'package:flutter/material.dart';

class AddPatientWidget extends StatefulWidget {
  final VoidCallback? onCancel;

  const AddPatientWidget({super.key, this.onCancel});

  @override
  State<AddPatientWidget> createState() => _AddPatientWidgetState();
}

class _AddPatientWidgetState extends State<AddPatientWidget> {
  final _formKey = GlobalKey<FormState>();
  final _patientIdController = TextEditingController();
  final _confirmationCodeController = TextEditingController();

  @override
  void dispose() {
    _patientIdController.dispose();
    _confirmationCodeController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Process adding patient logic
      final patientId = _patientIdController.text;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adding Patient: $patientId')),
      );
      
      // Clear fields instead of popping if embedded
      _patientIdController.clear();
      _confirmationCodeController.clear();
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
              'Add New Patient',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _patientIdController,
              decoration: const InputDecoration(
                labelText: 'Patient ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.badge),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the Patient ID';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmationCodeController,
              decoration: const InputDecoration(
                labelText: 'Confirmation Code',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.vpn_key),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the confirmation code';
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
              child: const Text('Add Patient'),
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
void showAddPatientDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: const AddPatientWidget(),
      ),
    ),
  );
}
