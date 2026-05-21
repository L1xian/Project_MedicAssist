import 'package:flutter/material.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:blog_app/core/utils/settings_menu.dart'; // Import the new settings menu utility
import 'package:blog_app/core/widgets/custom_app_bar.dart'; // Import CustomAppBar

class SchedulerPage extends StatefulWidget {
  const SchedulerPage({super.key});

  @override
  State<SchedulerPage> createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _selectedEvents = [];
  bool _isLoading = false;
  bool _showNoAppointmentsMessage = false; // New state variable

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _getEventsForDay(_selectedDay!);
  }

  Future<void> _getEventsForDay(DateTime day) async {
    setState(() {
      _isLoading = true;
      _showNoAppointmentsMessage = false; // Reset message visibility on new load
      _selectedEvents = []; // Clear previous events
    });

    final DateTime startOfDay = DateTime(day.year, day.month, day.day, 0, 0, 0);
    final DateTime endOfDay = DateTime(day.year, day.month, day.day, 23, 59, 59);

    try {
      final supabase = serviceLocator<SupabaseClient>();
      final response = await supabase
          .from('appointments')
          .select()
          .gte('start_time', startOfDay.toIso8601String())
          .lte('start_time', endOfDay.toIso8601String())
          .order('start_time', ascending: true);

      _selectedEvents = List<Map<String, dynamic>>.from(response);

      if (_selectedEvents.isEmpty) {
        // If no events, wait for 10 seconds before showing the message
        await Future.delayed(const Duration(seconds: 10));
        if (mounted && _selectedEvents.isEmpty) { // Check _selectedEvents again in case it changed during delay
          setState(() {
            _showNoAppointmentsMessage = true;
            _isLoading = false; // Set isLoading to false only after the delay
          });
        } else {
          // If events were added during the delay (e.g., by another refresh),
          // or if not mounted, just set isLoading to false.
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        // If events are found, immediately stop loading and don't show "no appointments" message
        setState(() {
          _isLoading = false;
          _showNoAppointmentsMessage = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching events: $e");
      setState(() {
        _selectedEvents = [
          {
            'summary': 'Error loading appointments',
            'description': e.toString(),
            'start_time': DateTime.now().toIso8601String(),
            'end_time': DateTime.now().add(const Duration(hours: 1)).toIso8601String(),
          }
        ];
        _isLoading = false; // Stop loading on error
        _showNoAppointmentsMessage = false; // Don't show "no appointments" on error, show error event
      });
    }
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;
    final accentColor = AppPallete.primaryColor;
    final borderColor = AppPallete.borderColor;
    final greyColor = AppPallete.greyColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const CustomAppBar(
        title: 'Schedule',
        // Removed leading IconButton as CustomAppBar now provides the settings menu
        hideAssistantIcon: true, // Hide AI assistant icon on this page
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Shadow bar below the AppBar
            Container(
              height: 1, // Height of the shadow line
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    blurRadius: 4,
                    offset: const Offset(0, 2), // Shadow offset
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  // Calendar Container
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: isDark ? borderColor.withOpacity(0.2) : Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      border: Border.all(color: borderColor.withOpacity(0.5)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.05 : 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: _onDaySelected,
                      onFormatChanged: (format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                      headerStyle: HeaderStyle(
                        formatButtonVisible: true,
                        titleCentered: true,
                        titleTextStyle: TextStyle(color: textColor),
                        leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
                        rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
                        formatButtonTextStyle: TextStyle(color: textColor),
                        formatButtonDecoration: BoxDecoration(
                          border: Border.all(color: accentColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: TextStyle(color: textColor),
                        weekendTextStyle: TextStyle(color: textColor.withOpacity(0.7)),
                        selectedDecoration: BoxDecoration(
                          color: accentColor,
                          shape: BoxShape.circle,
                        ),
                        todayDecoration: BoxDecoration(
                          color: accentColor.withOpacity(0.6),
                          shape: BoxShape.circle,
                        ),
                        outsideTextStyle: TextStyle(color: textColor.withOpacity(0.4)),
                      ),
                      daysOfWeekStyle: DaysOfWeekStyle(
                        weekdayStyle: TextStyle(color: greyColor),
                        weekendStyle: TextStyle(color: greyColor.withOpacity(0.7)),
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Appointments",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),
                  ),

                  // Appointments Container
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: isDark ? borderColor.withOpacity(0.1) : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                        ),
                      ),
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : _selectedEvents.isEmpty && _showNoAppointmentsMessage
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "No appointments scheduled",
                                        style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton.icon(
                                        onPressed: () => _getEventsForDay(_selectedDay!),
                                        icon: const Icon(Icons.refresh, color: Colors.white),
                                        label: const Text("Refresh", style: TextStyle(color: Colors.white)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppPallete.primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                      padding: const EdgeInsets.all(8.0),
                                      itemCount: _selectedEvents.length,
                                      itemBuilder: (context, index) {
                                        final event = _selectedEvents[index];
                                        final startTime = event['start_time'] != null ? DateTime.parse(event['start_time']) : null;
                                        final endTime = event['end_time'] != null ? DateTime.parse(event['end_time']) : null;

                                        return Card(
                                          color: isDark ? borderColor.withOpacity(0.2) : Colors.white,
                                          margin: const EdgeInsets.only(bottom: 12.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 60,
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    color: accentColor,
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      startTime != null ? _formatTime(startTime) : 'N/A',
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 16,
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
                                                        event['summary'] ?? 'No Title',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 18,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        event['description'] ?? 'No description',
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: greyColor,
                                                        ),
                                                      ),
                                                      if (endTime != null && startTime != null)
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 4.0),
                                                          child: Text(
                                                            'Duration: ${_formatDuration(startTime, endTime)}',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              color: greyColor.withOpacity(0.7),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                IconButton(
                                                  icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                                                  onPressed: () {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text('Attempted to cancel: ${event['summary'] ?? 'Appointment'}'),
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  String _formatDuration(DateTime start, DateTime end) {
    final duration = end.difference(start);
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    } else {
      return '${duration.inMinutes}m';
    }
  }
}