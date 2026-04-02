import 'package:flutter/material.dart';

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
  List<Map<String, String>> _getPatientHistory(String patientName) {
    // In a real app, this would fetch from a database
    return [
      {
        'date': '2024-03-15',
        'time': '09:00',
        'type': 'General Checkup',
        'notes': 'Routine examination. Blood pressure normal. Prescribed vitamins.',
        'doctor': 'Dr. Smith'
      },
      {
        'date': '2024-02-28',
        'time': '14:30',
        'type': 'Follow-up Visit',
        'notes': 'Follow-up on previous treatment. Patient showing improvement.',
        'doctor': 'Dr. Johnson'
      },
      {
        'date': '2024-01-20',
        'time': '11:00',
        'type': 'Consultation',
        'notes': 'Initial consultation for ongoing symptoms. Recommended tests.',
        'doctor': 'Dr. Williams'
      },
      {
        'date': '2023-12-10',
        'time': '10:15',
        'type': 'Emergency Visit',
        'notes': 'Acute symptoms. Treated and monitored. Discharged with medication.',
        'doctor': 'Dr. Brown'
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final history = _getPatientHistory(widget.patientName);

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
                          color: Colors.grey.withValues(alpha: 0.5),
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${record['date']} at ${record['time']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      record['type'] ?? '',
                                      style: TextStyle(
                                        color: theme.primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                record['notes'] ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark ? Colors.white70 : Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.medical_services,
                                    size: 16,
                                    color: isDark ? Colors.white54 : Colors.grey[500],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Dr. ${record['doctor']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark ? Colors.white54 : Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
