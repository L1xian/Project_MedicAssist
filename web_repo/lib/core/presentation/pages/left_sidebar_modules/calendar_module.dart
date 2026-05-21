import 'package:flutter/material.dart';

class CalendarModule extends StatefulWidget {
  final bool isSidebarCollapsed;
  final bool isCalendarExpanded;
  final DateTime selectedDate;
  final ValueChanged<bool> onExpansionChanged;
  final ValueChanged<DateTime> onDateChanged;

  const CalendarModule({
    super.key,
    required this.isSidebarCollapsed,
    required this.isCalendarExpanded,
    required this.selectedDate,
    required this.onExpansionChanged,
    required this.onDateChanged,
  });

  @override
  State<CalendarModule> createState() => _CalendarModuleState();
}

class _CalendarModuleState extends State<CalendarModule> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color; // Get dynamic text color

    return widget.isSidebarCollapsed
        ? IconButton(
            icon: Icon(Icons.calendar_today, color: textColor), // Use dynamic color
            onPressed: () {
              widget.onExpansionChanged(true); // Expand calendar when icon is pressed
            },
            tooltip: 'Calendar',
          )
        : ExpansionTile(
            leading: Icon(Icons.calendar_today, color: textColor), // Use dynamic color
            title: Text('Calendar', style: TextStyle(color: textColor)), // Use dynamic color
            initiallyExpanded: widget.isCalendarExpanded,
            onExpansionChanged: widget.onExpansionChanged,
            iconColor: textColor, // Use dynamic color
            collapsedIconColor: textColor, // Use dynamic color
            children: [
              Container(
                height: 300,
                padding: const EdgeInsets.all(8.0),
                child: Theme(
                  data: theme.copyWith(
                    colorScheme: theme.colorScheme.copyWith(
                      onSurface: textColor, // Use dynamic color
                      surface: Colors.transparent,
                    ),
                    textTheme: theme.textTheme.apply(
                      bodyColor: textColor, // Use dynamic color
                      displayColor: textColor, // Use dynamic color
                    ),
                  ),
                  child: CalendarDatePicker(
                    initialDate: widget.selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateChanged: widget.onDateChanged,
                  ),
                ),
              ),
            ],
          );
  }
}
