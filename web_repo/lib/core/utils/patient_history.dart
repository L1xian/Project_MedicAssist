import 'package:flutter/material.dart';

// Define a class for Checkup details for better structure
class CheckupDetail {
  final String date;
  final String time;
  final String type;
  final String notes;
  final String prescriptions; // New field for prescriptions
  final String doctor;

  CheckupDetail({
    required this.date,
    required this.time,
    required this.type,
    required this.notes,
    this.prescriptions = 'No prescriptions given.', // Default value
    required this.doctor,
  });
}

class PatientHistoryWidget extends StatefulWidget {
  final String patientName;
  final VoidCallback? onBack;
  final VoidCallback? onDelete;

  const PatientHistoryWidget({
    super.key,
    required this.patientName,
    this.onBack,
    this.onDelete,
  });

  @override
  State<PatientHistoryWidget> createState() => _PatientHistoryWidgetState();
}

class _PatientHistoryWidgetState extends State<PatientHistoryWidget> {
  // Mock patient history data
  List<CheckupDetail> _getPatientHistory(String patientName) {
    // In a real app, this would fetch from a database
    return [
      CheckupDetail(
        date: '2024-03-15',
        time: '09:00 AM',
        type: 'General Checkup',
        notes: 'Routine examination. Patient reported feeling well. Blood pressure normal.',
        prescriptions: 'Multivitamin (once daily), Paracetamol (as needed for pain).',
        doctor: 'Dr. Smith',
      ),
      CheckupDetail(
        date: '2024-02-28',
        time: '02:30 PM',
        type: 'Follow-up Visit',
        notes: 'Follow-up on previous treatment for flu. Patient showing significant improvement. No fever.',
        prescriptions: 'No new prescriptions. Continue previous course if symptoms return.',
        doctor: 'Dr. Johnson',
      ),
      CheckupDetail(
        date: '2024-01-20',
        time: '11:00 AM',
        type: 'Consultation',
        notes: 'Initial consultation for persistent headaches. Recommended MRI scan and neurological evaluation.',
        prescriptions: 'Ibuprofen (as needed for headache relief).',
        doctor: 'Dr. Williams',
      ),
      CheckupDetail(
        date: '2023-12-10',
        time: '10:15 AM',
        type: 'Emergency Visit',
        notes: 'Acute abdominal pain. Diagnosed with mild gastritis. Patient stable after treatment.',
        prescriptions: 'Omeprazole (once daily for 7 days), Antacid (as needed).',
        doctor: 'Dr. Brown',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final history = _getPatientHistory(widget.patientName);
    final textColor = theme.textTheme.bodyLarge?.color;
    final subtitleColor = theme.textTheme.bodySmall?.color;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Patient Info Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: theme.primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.patientName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Patient History',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    if (widget.onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete Patient'),
                                content: Text('Are you sure you want to delete ${widget.patientName}? This action cannot be undone.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      widget.onDelete?.call();
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.red,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        tooltip: 'Delete Patient',
                      ),
                    if (widget.onBack != null)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: widget.onBack,
                        tooltip: 'Back to Home',
                      ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // History List
          Expanded(
            child: history.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 48,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No history available',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final record = history[index];
                      return Card(
                        color: isDark ? const Color(0xFF22222D) : Colors.white,
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: ExpansionTile(
                          title: Text(
                            '${record.date} - ${record.type}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          subtitle: Text(
                            '${record.time} | Dr. ${record.doctor}',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Notes:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    record.notes,
                                    style: TextStyle(
                                      color: subtitleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Prescriptions:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    record.prescriptions,
                                    style: TextStyle(
                                      color: subtitleColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
