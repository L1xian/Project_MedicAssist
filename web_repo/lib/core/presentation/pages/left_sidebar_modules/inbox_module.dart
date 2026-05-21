import 'package:flutter/material.dart';
import 'appointment_request.dart'; // Import the new AppointmentRequest class

class InboxModule extends StatelessWidget {
  final bool isSidebarCollapsed;
  final List<AppointmentRequest> appointmentNotifications;
  final Function(AppointmentRequest) onAccept;
  final Function(AppointmentRequest) onCancel;

  const InboxModule({
    super.key,
    required this.isSidebarCollapsed,
    required this.appointmentNotifications,
    required this.onAccept,
    required this.onCancel,
  });

  // Helper to extract date and time from the message
  Map<String, String> _extractDateTime(String message) {
    String date = '';
    String time = '';
    RegExp regExp = RegExp(r'for (\d{4}-\d{2}-\d{2}) at (\d{2}:\d{2} (?:AM|PM))');
    Match? match = regExp.firstMatch(message);

    if (match != null) {
      date = match.group(1)!;
      time = match.group(2)!;
    }
    return {'date': date, 'time': time};
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color; // Get dynamic text color
    final subtitleColor = theme.textTheme.bodySmall?.color; // Get dynamic subtitle color

    return isSidebarCollapsed
        ? IconButton(
            icon: Stack(
              children: [
                Icon(Icons.inbox, color: textColor), // Use dynamic color
                if (appointmentNotifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${appointmentNotifications.length}',
                        style: const TextStyle(
                          color: Colors.white, // Keep white for badge for contrast
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
            onPressed: () {
              // In collapsed mode, clicking inbox icon should expand the sidebar
              // and potentially expand the inbox tile if it were an ExpansionTile.
              // For now, we'll just let the parent handle sidebar expansion.
            },
            tooltip: 'Inbox',
          )
        : ExpansionTile(
            leading: Stack(
              children: [
                Icon(Icons.inbox, color: textColor), // Use dynamic color
                if (appointmentNotifications.isNotEmpty)
                  Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${appointmentNotifications.length}',
                        style: const TextStyle(
                          color: Colors.white, // Keep white for badge for contrast
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
              ],
            ),
            title: Text('Inbox', style: TextStyle(color: textColor)), // Use dynamic color
            iconColor: textColor, // Use dynamic color
            collapsedIconColor: textColor, // Use dynamic color
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: 200), // Limit height
                child: appointmentNotifications.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'No new notifications.',
                          style: TextStyle(color: subtitleColor), // Use dynamic color
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: appointmentNotifications.length,
                        itemBuilder: (context, index) {
                          final request = appointmentNotifications[index];
                          final dateTime = _extractDateTime(request.message);
                          return ListTile(
                            title: Text(
                              request.patientName, // Display only patient name
                              style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold), // Use dynamic color
                            ),
                            subtitle: Text(
                              '${dateTime['date']} | ${dateTime['time']}', // Display date | time
                              style: TextStyle(color: subtitleColor, fontSize: 12), // Use dynamic color
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: () => onAccept(request),
                                  tooltip: 'Accept Appointment',
                                ),
                                VerticalDivider(
                                  color: theme.dividerColor, // Use dynamic color
                                  thickness: 1,
                                  indent: 10,
                                  endIndent: 10,
                                  width: 20,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => onCancel(request),
                                  tooltip: 'Decline Appointment',
                                ),
                              ],
                            ),
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(request.message)),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
  }
}
