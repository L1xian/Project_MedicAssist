import 'package:flutter/material.dart';

class Appointment {
  final String id;
  final String patientName;
  final String time;
  final String description;

  Appointment({
    required this.id,
    required this.patientName,
    required this.time,
    required this.description,
  });
}

class DayAppointmentsWidget extends StatefulWidget {
  final DateTime? selectedDate;
  final VoidCallback? onAddAppointment;
  
  const DayAppointmentsWidget({
    super.key, 
    this.selectedDate,
    this.onAddAppointment,
  });

  @override
  State<DayAppointmentsWidget> createState() => _DayAppointmentsWidgetState();
}

class _DayAppointmentsWidgetState extends State<DayAppointmentsWidget> {
  late DateTime _selectedDate;
  late List<Appointment> _appointments;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate ?? DateTime.now();
    _appointments = _getAppointmentsForDate(_selectedDate);
  }

  @override
  void didUpdateWidget(DayAppointmentsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      setState(() {
        _selectedDate = widget.selectedDate ?? DateTime.now();
        _appointments = _getAppointmentsForDate(_selectedDate);
      });
    }
  }

  String _formatDate(DateTime date) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    final dayName = days[date.weekday - 1];
    final monthName = months[date.month - 1];
    
    return '$dayName, $monthName ${date.day}, ${date.year}';
  }

  List<Appointment> _getAppointmentsForDate(DateTime date) {
    // Mock appointments data - replace with actual data source
    final mockAppointments = [
      Appointment(
        id: '1',
        patientName: 'John Doe',
        time: '09:00',
        description: 'General Checkup',
      ),
      Appointment(
        id: '2',
        patientName: 'Jane Smith',
        time: '10:30',
        description: 'Follow-up Visit',
      ),
      Appointment(
        id: '3',
        patientName: 'Robert Johnson',
        time: '14:00',
        description: 'Consultation',
      ),
    ];

    // Filter appointments based on date (in a real app, this would query a database)
    return mockAppointments;
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // Date Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointments for',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(_selectedDate),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add appointment logic here
                    widget.onAddAppointment?.call();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Appointment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Appointments List
          if (_appointments.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 48,
                      color: Colors.grey.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No appointments scheduled',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _appointments.length,
                itemBuilder: (context, index) {
                  final appointment = _appointments[index];
                  return Card(
                    color: isDark ? const Color(0xFF22222D) : Colors.white,
                    margin: const EdgeInsets.only(bottom: 12.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: theme.primaryColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                appointment.time,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.patientName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  appointment.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark ? Colors.white70 : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () {
                              // Cancel appointment logic here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Cancelled appointment with ${appointment.patientName}'),
                                ),
                              );
                            },
                            tooltip: 'Cancel Appointment',
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
