import 'package:flutter/material.dart';
import '../../utils/add_patient.dart';
import '../../utils/add_appointment.dart';
import '../../utils/manage_date.dart';
import '../../utils/patient_history.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isCalendarExpanded = false;
  bool _isSidebarCollapsed = true;
  bool _isPatientsCollapsed = true;
  bool _showAddPatientForm = false;
  bool _showAddAppointmentForm = false;
  String? _selectedPatientForHistory;
  late DateTime _selectedDate;
  
  // Test patients list
  late List<String> _patients;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Icon(Icons.layers, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Template Design',
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
                              icon: const Icon(Icons.menu, color: Colors.white),
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
                              const Text(
                                'MENU',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ),
                      
                      // Expandable Calendar Menu
                      _isSidebarCollapsed
                          ? IconButton(
                              icon: const Icon(Icons.calendar_today, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _isSidebarCollapsed = false;
                                  _isCalendarExpanded = true;
                                });
                              },
                              tooltip: 'Calendar',
                            )
                          : ExpansionTile(
                              leading: const Icon(Icons.calendar_today, color: Colors.white),
                              title: const Text('Calendar', style: TextStyle(color: Colors.white)),
                              initiallyExpanded: _isCalendarExpanded,
                              onExpansionChanged: (expanded) {
                                setState(() {
                                  _isCalendarExpanded = expanded;
                                });
                              },
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              children: [
                                Container(
                                  height: 300,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Theme(
                                    data: theme.copyWith(
                                      colorScheme: theme.colorScheme.copyWith(
                                        onSurface: Colors.white,
                                        surface: Colors.transparent,
                                      ),
                                      textTheme: theme.textTheme.apply(
                                        bodyColor: Colors.white,
                                        displayColor: Colors.white,
                                      ),
                                    ),
                                    child: CalendarDatePicker(
                                      initialDate: _selectedDate,
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2100),
                                      onDateChanged: (date) {
                                        setState(() {
                                          _selectedDate = date;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),

                      // Spacer to push remaining items to the bottom
                      const Spacer(),

                      // Settings item at the bottom
                      const Divider(color: Colors.white24),
                      _isSidebarCollapsed
                          ? IconButton(
                              icon: const Icon(Icons.settings, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _isSidebarCollapsed = false;
                                });
                              },
                              tooltip: 'Settings',
                            )
                          : ListTile(
                              leading: const Icon(Icons.settings, color: Colors.white),
                              title: const Text('Settings', style: TextStyle(color: Colors.white)),
                              onTap: () {},
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
                          alignment: Alignment.center,
                          child: Text(
                            _showAddPatientForm 
                              ? 'Add New Patient' 
                              : _showAddAppointmentForm 
                                ? 'Add New Appointment' 
                                : _selectedPatientForHistory != null
                                  ? 'Patient History - $_selectedPatientForHistory'
                                  : 'Home',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        Expanded(
                          child: _showAddPatientForm 
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32.0),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 500),
                                    child: AddPatientWidget(onCancel: () => setState(() => _showAddPatientForm = false)),
                                  ),
                                ),
                              )
                            : _showAddAppointmentForm
                              ? Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(32.0),
                                    child: ConstrainedBox(
                                      constraints: const BoxConstraints(maxWidth: 500),
                                      child: AddAppointmentWidget(
                                        onCancel: () => setState(() => _showAddAppointmentForm = false),
                                        patients: _patients,
                                      ),
                                    ),
                                  ),
                                )
                              : _selectedPatientForHistory != null
                                ? PatientHistoryWidget(
                                    patientName: _selectedPatientForHistory!,
                                    onBack: () => setState(() => _selectedPatientForHistory = null),
                                    onDelete: () => setState(() {
                                      _patients.remove(_selectedPatientForHistory);
                                      _selectedPatientForHistory = null;
                                    }),
                                  )
                                : DayAppointmentsWidget(
                                    selectedDate: _selectedDate,
                                    onAddAppointment: () => setState(() => _showAddAppointmentForm = true),
                                  ),
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
                              const Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Patients',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            IconButton(
                              icon: Icon(
                                _isPatientsCollapsed ? Icons.people : Icons.arrow_forward_ios,
                                color: Colors.white,
                                size: _isPatientsCollapsed ? 24 : 18,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPatientsCollapsed = !_isPatientsCollapsed;
                                });
                              },
                              tooltip: _isPatientsCollapsed ? 'Expand Patients' : 'Collapse Patients',
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
                                    separatorBuilder: (context, index) => const Divider(
                                      color: Colors.white24,
                                      height: 1,
                                    ),
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
                                ? const Center(
                                    child: Text(
                                      'No Patients added',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  )
                                : ListView.separated(
                                    itemCount: _patients.length,
                                    separatorBuilder: (context, index) => const Divider(
                                      color: Colors.white24,
                                      height: 1,
                                    ),
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
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        onTap: () async {
                                          final enteredPin = await _showPinDialog(context);
                                          if (enteredPin == '1234') {
                                            setState(() {
                                              _selectedPatientForHistory = _patients[index];
                                            });
                                          }
                                        },
                                      );
                                    },
                                  ),
                      ),

                      // Add Patient option at the bottom
                      const Divider(color: Colors.white24),
                      _isPatientsCollapsed
                          ? IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _showAddPatientForm = true;
                                });
                              },
                              tooltip: 'Add Patient',
                            )
                          : ListTile(
                              leading: const Icon(Icons.add, color: Colors.white),
                              title: const Text('Add Patient', style: TextStyle(color: Colors.white)),
                              onTap: () {
                                setState(() {
                                  _showAddPatientForm = true;
                                });
                              },
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
