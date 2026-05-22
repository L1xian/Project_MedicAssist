import 'package:flutter/material.dart';
import 'package:blog_app/theme/app_pallete.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:blog_app/init_dependencies.dart';
import 'package:blog_app/core/widgets/custom_app_bar.dart'; // Import CustomAppBar
import 'package:blog_app/core/utils/settings_menu.dart'; // Import the new settings menu utility
import 'package:intl/intl.dart';

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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _getEventsForDay(_selectedDay!);
  }

  Future<void> _getEventsForDay(DateTime day) async {
    setState(() {
      _isLoading = true;
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
    } catch (e) {
      debugPrint("Error fetching events: $e");
      _selectedEvents = [];
    } finally {
      setState(() {
        // Add test appointments if no real events are found or an error occurred
        if (_selectedEvents.isEmpty) {
          _selectedEvents = [
            {
              'summary': 'Morning Check-up',
              'description': 'Routine physical examination with Dr. Smith.',
              'start_time': DateTime(day.year, day.month, day.day, 9, 30).toIso8601String(),
              'end_time': DateTime(day.year, day.month, day.day, 10, 0).toIso8601String(),
            },
            {
              'summary': 'Dental Cleaning',
              'description': 'Bi-annual dental check-up with Dr. Lee.',
              'start_time': DateTime(day.year, day.month, day.day, 11, 0).toIso8601String(),
              'end_time': DateTime(day.year, day.month, day.day, 12, 0).toIso8601String(),
            },
            {
              'summary': 'Therapy Session',
              'description': 'Weekly therapy session with Dr. Green.',
              'start_time': DateTime(day.year, day.month, day.day, 14, 0).toIso8601String(),
              'end_time': DateTime(day.year, day.month, day.day, 15, 0).toIso8601String(),
            },
            {
              'summary': 'Eye Exam',
              'description': 'Annual eye examination with Dr. Brown.',
              'start_time': DateTime(day.year, day.month, day.day, 16, 30).toIso8601String(),
              'end_time': DateTime(day.year, day.month, day.day, 17, 0).toIso8601String(),
            },
          ];
        }
        _isLoading = false;
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
      appBar: CustomAppBar(
        title: 'Schedule',
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded, color: textColor),
            onPressed: () {
              if (_selectedDay != null) {
                _getEventsForDay(_selectedDay!);
              }
            },
          ),
        ],
        hideAssistantIcon: true, // Hide AI assistant icon on this page
      ),
      body: SafeArea(
        child: Column(
          children: [

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
                          : _selectedEvents.isEmpty
                              ? Center(
                                  child: Text(
                                    'No appointments found.',
                                    style: TextStyle(color: textColor.withOpacity(0.7)),
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.all(8.0),
                                  itemCount: _selectedEvents.length,
                                  itemBuilder: (context, index) {
                                    final event = _selectedEvents[index];
                                    final startTime = event['start_time'] != null
                                        ? DateTime.parse(event['start_time'])
                                        : null;
                                    final patientName = event['summary'] ?? 'Unknown Patient';
                                    final secondaryInfo = event['description'] ?? 'No secondary info';

                                    String formattedDateTime = '';
                                    if (startTime != null) {
                                      formattedDateTime = DateFormat('yyyy-MM-dd | hh:mm a').format(startTime);
                                    } else {
                                      formattedDateTime = 'No Date & Time';
                                    }

                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 12.0),
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color: isDark ? borderColor.withOpacity(0.15) : Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  patientName,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: textColor,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.close, color: Colors.red),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: const Text('Cancel Appointment'),
                                                          content: Text('Are you sure you want to cancel the appointment for $patientName?'),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () => Navigator.pop(context),
                                                              child: const Text('No'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(context);
                                                                // Add actual cancellation logic here
                                                                ScaffoldMessenger.of(context).showSnackBar(
                                                                  SnackBar(content: Text('Cancelled appointment for $patientName')),
                                                                );
                                                              },
                                                              child: const Text(
                                                                'Yes',
                                                                style: TextStyle(color: Colors.red),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                    constraints: const BoxConstraints(),
                                                    padding: const EdgeInsets.all(4),
                                                    tooltip: 'Cancel Appointment',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(secondaryInfo, style: TextStyle(fontSize: 14, color: greyColor)),
                                          const SizedBox(height: 4),
                                          Text(
                                            formattedDateTime,
                                            style: TextStyle(fontSize: 12, color: greyColor.withOpacity(0.8)),
                                          ),
                                        ],
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
}