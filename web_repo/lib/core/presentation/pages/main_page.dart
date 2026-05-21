import 'package:flutter/material.dart';
import '../../utils/add_patient.dart';
import '../../utils/add_appointment.dart';
import '../../utils/manage_date.dart';
import '../../utils/patient_history.dart';
import 'left_sidebar_modules/calendar_module.dart';
import 'left_sidebar_modules/inbox_module.dart';
import 'left_sidebar_modules/appointment_request.dart';
import 'main_content_modules/write_report_form.dart';
import 'top_bar_modules/top_bar_category.dart';
import 'login_page.dart'; // Import LoginPage for navigation

enum MainContentCategory {
  home,
  addAppointmentCategory,
  writeReport,
  addPatient,
  patientHistory,
}

class MainPage extends StatefulWidget {
  final ValueChanged<ThemeMode> onThemeChanged;

  const MainPage({super.key, required this.onThemeChanged});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isCalendarExpanded = false;
  bool _isSidebarCollapsed = true;
  bool _isPatientsCollapsed = true;
  String? _selectedPatientForHistory;
  late DateTime _selectedDate;
  
  MainContentCategory _currentMainContentCategory = MainContentCategory.home;

  late List<String> _patients;
  List<AppointmentRequest> _appointmentNotifications = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _patients = [
      'John Doe',
      'Jane Smith',
      'Robert Johnson',
      'Sarah Williams',
      'Michael Brown',
    ];

    _appointmentNotifications = [
      AppointmentRequest(
        patientName: 'Alice Wonderland',
        message: 'New appointment request from Alice Wonderland for 2023-11-15 at 11:00 AM',
      ),
      AppointmentRequest(
        patientName: 'Bob The Builder',
        message: 'New appointment request from Bob The Builder for 2023-11-16 at 09:30 AM',
      ),
    ];
  }

  Future<String?> _showPinDialog(BuildContext context) async {
    String pin = '';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Security PIN'),
          content: TextField(
            obscureText: true,
            onChanged: (value) => pin = value,
            decoration: const InputDecoration(
              labelText: 'PIN',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(pin),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _onCalendarExpansionChanged(bool expanded) {
    setState(() {
      _isCalendarExpanded = expanded;
    });
  }

  void _onDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
  }

  void _onAcceptAppointment(AppointmentRequest request) {
    setState(() {
      if (!_patients.contains(request.patientName)) {
        _patients.add(request.patientName);
      }
      _appointmentNotifications.remove(request);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${request.patientName} added to patients and appointment accepted!')),
    );
  }

  void _onCancelAppointment(AppointmentRequest request) {
    setState(() {
      _appointmentNotifications.remove(request);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Appointment from ${request.patientName} cancelled.')),
    );
  }

  void _changeMainContentCategory(MainContentCategory category) async {
    if (category == MainContentCategory.writeReport) {
      final enteredPin = await _showPinDialog(context);
      if (enteredPin == '1234') {
        setState(() {
          _currentMainContentCategory = category;
          _selectedPatientForHistory = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect PIN. Access denied.')),
        );
      }
    } else {
      setState(() {
        _currentMainContentCategory = category;
        _selectedPatientForHistory = null;
      });
    }
  }

  void _showAddPatientForm() {
    setState(() {
      _currentMainContentCategory = MainContentCategory.addPatient;
    });
  }

  void _hideAddPatientForm() {
    setState(() {
      _currentMainContentCategory = MainContentCategory.home;
    });
  }

  void _showAddAppointmentForm() {
    setState(() {
      _currentMainContentCategory = MainContentCategory.addAppointmentCategory;
    });
  }

  void _hideAddAppointmentForm() {
    setState(() {
      _currentMainContentCategory = MainContentCategory.home;
    });
  }

  void _showPatientHistory(String patientName) {
    setState(() {
      _selectedPatientForHistory = patientName;
      _currentMainContentCategory = MainContentCategory.patientHistory;
    });
  }

  void _hidePatientHistory() {
    setState(() {
      _selectedPatientForHistory = null;
      _currentMainContentCategory = MainContentCategory.home;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final sidebarTextColor = isDark ? Colors.white : Colors.black;
    final sidebarIconColor = isDark ? Colors.white : Colors.black;
    final patientListTextColor = isDark ? Colors.white : Colors.black;
    final patientListSubtitleColor = isDark ? Colors.white70 : Colors.grey[600];

    Widget _buildMainContent() {
      switch (_currentMainContentCategory) {
        case MainContentCategory.home:
          if (_selectedPatientForHistory != null) {
            return PatientHistoryWidget(
              patientName: _selectedPatientForHistory!,
              onBack: _hidePatientHistory,
              onDelete: () {
                setState(() {
                  _patients.remove(_selectedPatientForHistory);
                  _selectedPatientForHistory = null;
                  _currentMainContentCategory = MainContentCategory.home;
                });
              },
            );
          }
          return DayAppointmentsWidget(
            selectedDate: _selectedDate,
          );
        case MainContentCategory.addAppointmentCategory:
          return AddAppointmentWidget(
            onCancel: _hideAddAppointmentForm,
            patients: _patients,
          );
        case MainContentCategory.writeReport:
          return WriteReportForm(
            onCancel: () => _changeMainContentCategory(MainContentCategory.home),
            patients: _patients,
          );
        case MainContentCategory.addPatient:
          return AddPatientWidget(onCancel: _hideAddPatientForm);
        case MainContentCategory.patientHistory:
          return PatientHistoryWidget(
            patientName: _selectedPatientForHistory!,
            onBack: _hidePatientHistory,
            onDelete: () {
              setState(() {
                _patients.remove(_selectedPatientForHistory);
                _selectedPatientForHistory = null;
                _currentMainContentCategory = MainContentCategory.home;
              });
            },
          );
      }
    }

    String _getMainContentTitle() {
      switch (_currentMainContentCategory) {
        case MainContentCategory.addPatient:
          return 'Add New Patient';
        case MainContentCategory.patientHistory:
          return 'Patient History - $_selectedPatientForHistory';
        default:
          return '';
      }
    }

    return Scaffold(
      body: Column(
        children: [
          // Header (Logo/Name on Left, User on Right)
          Container(
            width: double.infinity,
            height: 60,
            color: theme.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Branding
                Row(
                  children: [
                    Container(
                      width: 48, 
                      height: 48, 
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'lib/core/theme/img/logo.png',
                        fit: BoxFit.contain, 
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error, color: Colors.red, size: 24); 
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Medic Assist',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                // Right side: User Info
                Row(
                  children: const [
                    Text(
                      'ADMIN',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 12),
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white24,
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: Row(
              children: [
                // Left Sidebar (Collapsible)
                Container(
                  width: _isSidebarCollapsed ? 60 : 250,
                  color: isDark ? const Color(0xFF1C1C26) : const Color(0xFFF8F9FE),
                  child: Column(
                    children: [
                      // Sidebar Header with Collapse Icon and "MENU"
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: theme.dividerColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: _isSidebarCollapsed
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.menu, color: sidebarIconColor),
                              onPressed: () {
                                setState(() {
                                  _isSidebarCollapsed = !_isSidebarCollapsed;
                                  if (_isSidebarCollapsed) {
                                    _isCalendarExpanded = false;
                                  }
                                });
                              },
                            ),
                            if (!_isSidebarCollapsed)
                              Text(
                                'MENU',
                                style: TextStyle(
                                  color: sidebarTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Calendar Module (already dynamic)
                      CalendarModule(
                        isSidebarCollapsed: _isSidebarCollapsed,
                        isCalendarExpanded: _isCalendarExpanded,
                        selectedDate: _selectedDate,
                        onExpansionChanged: _onCalendarExpansionChanged,
                        onDateChanged: _onDateChanged,
                      ),

                      // Inbox Module (already dynamic)
                      InboxModule(
                        isSidebarCollapsed: _isSidebarCollapsed,
                        appointmentNotifications: _appointmentNotifications,
                        onAccept: _onAcceptAppointment,
                        onCancel: _onCancelAppointment,
                      ),

                      // Spacer to push remaining items to the bottom
                      const Spacer(),

                      // Settings section
                      Divider(color: theme.dividerColor),
                      _isSidebarCollapsed
                          ? IconButton(
                              icon: Icon(Icons.settings, color: sidebarIconColor),
                              onPressed: () {
                                setState(() {
                                  _isSidebarCollapsed = false; // Expand sidebar to show settings menu
                                });
                              },
                              tooltip: 'Settings',
                            )
                          : ExpansionTile(
                              leading: Icon(Icons.settings, color: sidebarIconColor),
                              title: Text('Settings', style: TextStyle(color: sidebarTextColor)),
                              iconColor: sidebarIconColor,
                              collapsedIconColor: sidebarIconColor,
                              children: [
                                // Theme Switch
                                SwitchListTile(
                                  title: Text('Dark Mode', style: TextStyle(color: sidebarTextColor)),
                                  value: isDark,
                                  onChanged: (bool value) {
                                    widget.onThemeChanged(value ? ThemeMode.dark : ThemeMode.light);
                                  },
                                  activeColor: theme.primaryColor,
                                ),
                                // Switch Account
                                ListTile(
                                  title: Text('Switch Account', style: TextStyle(color: sidebarTextColor)),
                                  leading: Icon(Icons.switch_account, color: sidebarIconColor),
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage(onThemeChanged: widget.onThemeChanged)),
                                      (Route<dynamic> route) => false, // Remove all previous routes
                                    );
                                  },
                                ),
                                // Logout
                                ListTile(
                                  title: Text('Logout', style: TextStyle(color: sidebarTextColor)),
                                  leading: Icon(Icons.logout, color: sidebarIconColor),
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => LoginPage(onThemeChanged: widget.onThemeChanged)),
                                      (Route<dynamic> route) => false, // Remove all previous routes
                                    );
                                  },
                                ),
                              ],
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                // Main Content
                Expanded(
                  child: Container(
                    color: theme.scaffoldBackgroundColor,
                    child: Column(
                      children: [
                        // Top bar for main content area
                        Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF22222D) : Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: theme.dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Display title for non-category views
                              if (_getMainContentTitle().isNotEmpty)
                                Text(
                                  _getMainContentTitle(),
                                  style: TextStyle(color: patientListTextColor),
                                ),
                              TopBarCategory(
                                title: 'Add Appointment',
                                icon: Icons.add_box,
                                isSelected: _currentMainContentCategory == MainContentCategory.addAppointmentCategory,
                                onTap: () => _changeMainContentCategory(MainContentCategory.addAppointmentCategory),
                              ),
                              const SizedBox(width: 16),
                              TopBarCategory(
                                title: 'Home',
                                icon: Icons.home,
                                isSelected: _currentMainContentCategory == MainContentCategory.home,
                                onTap: () => _changeMainContentCategory(MainContentCategory.home),
                              ),
                              const SizedBox(width: 16),
                              TopBarCategory(
                                title: 'Write Report',
                                icon: Icons.edit_document,
                                isSelected: _currentMainContentCategory == MainContentCategory.writeReport,
                                onTap: () => _changeMainContentCategory(MainContentCategory.writeReport),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _buildMainContent(),
                        ),
                      ],
                    ),
                  ),
                ),

                // Right Content (Patients)
                Container(
                  width: _isPatientsCollapsed ? 60 : 300,
                  color: isDark ? const Color(0xFF1C1C26) : const Color(0xFFF8F9FE),
                  child: Column(
                    children: [
                      // Header for Patients matching the Menu header style
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: theme.dividerColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: _isPatientsCollapsed
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceBetween,
                          children: [
                            if (!_isPatientsCollapsed)
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Patients',
                                  style: TextStyle(
                                    color: patientListTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            IconButton(
                              icon: Icon(
                                _isPatientsCollapsed ? Icons.people : Icons.arrow_forward_ios,
                                color: sidebarIconColor,
                                size: _isPatientsCollapsed ? 24 : 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPatientsCollapsed = !_isPatientsCollapsed;
                                });
                              },
                              tooltip: (_isPatientsCollapsed ? 'Expand Patients' : 'Collapse Patients'),
                            ),
                          ],
                        ),
                      ),
                      
                      // Content of Patients list
                      Expanded(
                        child: _isPatientsCollapsed
                            ? _patients.isEmpty
                                ? const SizedBox.shrink()
                                : ListView.separated(
                                    itemCount: _patients.length,
                                    separatorBuilder: (context, index) => Divider(color: theme.dividerColor),
                                    itemBuilder: (context, index) {
                                      return Tooltip(
                                        message: _patients[index],
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: CircleAvatar(
                                              backgroundColor: theme.primaryColor,
                                              child: const Icon(
                                                Icons.person,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                            : _patients.isEmpty
                                ? Center(
                                    child: Text(
                                      'No Patients added',
                                      style: TextStyle(color: patientListSubtitleColor),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: _patients.length,
                                    separatorBuilder: (context, index) => Divider(color: theme.dividerColor),
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        leading: CircleAvatar(
                                          backgroundColor: theme.primaryColor,
                                          child: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                        ),
                                        title: Text(
                                          _patients[index],
                                          style: TextStyle(
                                            color: patientListTextColor,
                                            fontSize: 14,
                                          ),
                                        ),
                                        onTap: () async {
                                          final enteredPin = await _showPinDialog(context);
                                          if (enteredPin == '1234') {
                                            _showPatientHistory(_patients[index]);
                                          }
                                        },
                                      );
                                    },
                                  ),
                      ),

                      // Add Patient option at the bottom
                      Divider(color: theme.dividerColor),
                      _isPatientsCollapsed
                          ? IconButton(
                              icon: Icon(Icons.add, color: sidebarIconColor),
                              onPressed: _showAddPatientForm,
                              tooltip: 'Add Patient',
                            )
                          : ListTile(
                              leading: Icon(Icons.add, color: sidebarIconColor),
                              title: Text('Add Patient', style: TextStyle(color: sidebarTextColor)),
                              onTap: _showAddPatientForm,
                            ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
