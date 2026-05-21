import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Commented out due to persistent issues

class DayAppointmentsWidget extends StatelessWidget {
  final DateTime selectedDate;
  // Removed final VoidCallback? onAddAppointment; // This parameter is no longer needed

  const DayAppointmentsWidget({
    super.key,
    required this.selectedDate,
    // Removed this.onAddAppointment,
  });

  // Mock data for appointments
  List<Map<String, String>> _getAppointmentsForDate(DateTime date) {
    // This would typically fetch data from a backend
    // Using basic string formatting instead of DateFormat
    final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final todayFormatted = "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowFormatted = "${tomorrow.year}-${tomorrow.month.toString().padLeft(2, '0')}-${tomorrow.day.toString().padLeft(2, '0')}";


    if (formattedDate == todayFormatted) {
      return [
        {'time': '09:00 AM', 'patient': 'John Doe', 'type': 'Check-up'},
        {'time': '10:30 AM', 'patient': 'Jane Smith', 'type': 'Consultation'},
        {'time': '02:00 PM', 'patient': 'Robert Johnson', 'type': 'Follow-up'},
      ];
    } else if (formattedDate == tomorrowFormatted) {
      return [
        {'time': '11:00 AM', 'patient': 'Sarah Williams', 'type': 'Vaccination'},
      ];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final subtitleColor = isDark ? Colors.white70 : Colors.grey[600];

    final appointments = _getAppointmentsForDate(selectedDate);

    // Using basic string formatting for displaying the date
    final displayDate = "${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}";


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header for the selected date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Appointments for $displayDate', // Using basic string formatting
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              // Removed the "Add Appointment" button
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: appointments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.event_note,
                          size: 48,
                          color: subtitleColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No appointments for this date.',
                          style: TextStyle(
                            fontSize: 16,
                            color: subtitleColor,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: appointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointments[index];
                      return Card(
                        color: isDark ? const Color(0xFF22222D) : Colors.white,
                        margin: const EdgeInsets.only(bottom: 12.0),
                        child: ListTile(
                          leading: Icon(Icons.event, color: theme.primaryColor),
                          title: Text(
                            '${appointment['time']} - ${appointment['patient']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          subtitle: Text(
                            appointment['type'] ?? '',
                            style: TextStyle(
                              color: subtitleColor,
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios, color: subtitleColor, size: 16),
                          onTap: () {
                            // Handle tapping on an appointment
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Tapped on appointment with ${appointment['patient']}')),
                            );
                          },
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