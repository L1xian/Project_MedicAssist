import 'package:flutter/material.dart';
import 'package:blog_app/core/widgets/custom_app_bar.dart';
import 'package:blog_app/theme/app_pallete.dart';

class Doctor {
  final String name;
  final String specialty;
  final String region;
  final double rating;
  final String imageUrl;
  final String bio;
  final String email;
  final String address;
  final String phoneNumber;

  Doctor({
    required this.name,
    required this.specialty,
    required this.region,
    required this.rating,
    required this.imageUrl,
    required this.bio,
    required this.email,
    required this.address,
    required this.phoneNumber,
  });
}

class DoctorsPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const DoctorsPage(),
      );

  const DoctorsPage({super.key});

  @override
  State<DoctorsPage> createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  final List<Doctor> _allDoctors = [
    Doctor(
      name: 'Dr. Alice Smith',
      specialty: 'Cardiology',
      region: 'New York',
      rating: 4.8,
      imageUrl: 'https://randomuser.me/api/portraits/women/1.jpg',
      bio: 'Experienced cardiologist with a focus on preventive care and heart health.',
      email: 'alice.smith@example.com',
      address: '123 Heartbeat Ave, New York, NY',
      phoneNumber: '+1-212-555-0100',
    ),
    Doctor(
      name: 'Dr. Bob Johnson',
      specialty: 'Pediatrics',
      region: 'Los Angeles',
      rating: 4.5,
      imageUrl: 'https://randomuser.me/api/portraits/men/2.jpg',
      bio: 'Dedicated pediatrician providing comprehensive care for children of all ages.',
      email: 'bob.johnson@example.com',
      address: '456 Little St, Los Angeles, CA',
      phoneNumber: '+1-310-555-0101',
    ),
    Doctor(
      name: 'Dr. Carol White',
      specialty: 'Dermatology',
      region: 'New York',
      rating: 4.9,
      imageUrl: 'https://randomuser.me/api/portraits/women/3.jpg',
      bio: 'Specializes in skin conditions, cosmetic dermatology, and laser treatments.',
      email: 'carol.white@example.com',
      address: '789 Skin Blvd, New York, NY',
      phoneNumber: '+1-212-555-0102',
    ),
    Doctor(
      name: 'Dr. David Brown',
      specialty: 'Neurology',
      region: 'Chicago',
      rating: 4.7,
      imageUrl: 'https://randomuser.me/api/portraits/men/4.jpg',
      bio: 'Expert in neurological disorders, including migraines, epilepsy, and stroke.',
      email: 'david.brown@example.com',
      address: '101 Brain Rd, Chicago, IL',
      phoneNumber: '+1-312-555-0103',
    ),
    Doctor(
      name: 'Dr. Eve Davis',
      specialty: 'Orthopedics',
      region: 'Los Angeles',
      rating: 4.6,
      imageUrl: 'https://randomuser.me/api/portraits/women/5.jpg',
      bio: 'Orthopedic surgeon specializing in sports injuries and joint replacement.',
      email: 'eve.davis@example.com',
      address: '202 Bone Ln, Los Angeles, CA',
      phoneNumber: '+1-310-555-0104',
    ),
    Doctor(
      name: 'Dr. Frank Green',
      specialty: 'Cardiology',
      region: 'Chicago',
      rating: 4.7,
      imageUrl: 'https://randomuser.me/api/portraits/men/6.jpg',
      bio: 'Focuses on interventional cardiology and complex heart procedures.',
      email: 'frank.green@example.com',
      address: '303 Artery Way, Chicago, IL',
      phoneNumber: '+1-312-555-0105',
    ),
  ];

  List<Doctor> _filteredDoctors = [];
  String? _selectedRegion;
  String? _selectedSpecialty;
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false; // New state variable to toggle filter visibility

  @override
  void initState() {
    super.initState();
    _filteredDoctors = _allDoctors;
    _searchController.addListener(_filterDoctors);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterDoctors() {
    setState(() {
      _filteredDoctors = _allDoctors.where((doctor) {
        final matchesRegion = _selectedRegion == null || doctor.region == _selectedRegion;
        final matchesSpecialty = _selectedSpecialty == null || doctor.specialty == _selectedSpecialty;
        final matchesSearch = doctor.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                            doctor.specialty.toLowerCase().contains(_searchController.text.toLowerCase());
        return matchesRegion && matchesSpecialty && matchesSearch;
      }).toList();
    });
  }

  void _showDoctorDetails(BuildContext context, Doctor doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;
        final cardColor = isDark ? AppPallete.surfaceColor : Colors.white;

        return DraggableScrollableSheet(
          initialChildSize: 0.7, // Start at 70% of screen height
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: AppPallete.greyColor.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.all(20),
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(doctor.imageUrl),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          doctor.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          doctor.specialty,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: AppPallete.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildDetailRow(context, Icons.email_rounded, 'Email', doctor.email),
                        _buildDetailRow(context, Icons.phone_rounded, 'Phone', doctor.phoneNumber),
                        _buildDetailRow(context, Icons.location_on_rounded, 'Address', doctor.address),
                        const SizedBox(height: 20),
                        Text(
                          'About ${doctor.name.split(' ')[1]}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          doctor.bio,
                          style: TextStyle(
                            fontSize: 16,
                            color: textColor.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Implement appointment reservation logic
                              Navigator.pop(context); // Close the modal
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Appointment reserved with ${doctor.name}')),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppPallete.primaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Reserve Appointment',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String title, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppPallete.primaryColor, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor.withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppPallete.whiteColor : AppPallete.backgroundColor;
    final cardColor = isDark ? AppPallete.surfaceColor : Colors.white;
    final borderColor = AppPallete.borderColor;

    final List<String> regions = _allDoctors.map((d) => d.region).toSet().toList();
    final List<String> specialties = _allDoctors.map((d) => d.specialty).toSet().toList();

    return Scaffold(
      appBar: const CustomAppBar(title: 'Find a Doctor'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row( // Wrap search bar and filter icon in a Row
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search doctors by name or specialty...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: isDark ? AppPallete.surfaceColor : Colors.grey[200],
                        ),
                        style: TextStyle(color: textColor),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container( // Shadow line
                      height: 48, // Match TextField height
                      width: 1,
                      color: AppPallete.borderColor.withOpacity(0.5),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        _showFilters ? Icons.filter_alt_off_rounded : Icons.filter_alt_rounded,
                        color: textColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _showFilters = !_showFilters;
                        });
                      },
                    ),
                  ],
                ),
                if (_showFilters) ...[ // Conditionally show filters
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Region',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
                            ),
                            filled: true,
                            fillColor: isDark ? AppPallete.surfaceColor : Colors.grey[200],
                          ),
                          value: _selectedRegion,
                          hint: Text('Select Region', style: TextStyle(color: textColor.withOpacity(0.7))),
                          dropdownColor: isDark ? AppPallete.backgroundColor : Colors.white,
                          style: TextStyle(color: textColor),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('All Regions')),
                            ...regions.map((region) => DropdownMenuItem(value: region, child: Text(region))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRegion = value;
                              _filterDoctors();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Specialty',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
                            ),
                            filled: true,
                            fillColor: isDark ? AppPallete.surfaceColor : Colors.grey[200],
                          ),
                          value: _selectedSpecialty,
                          hint: Text('Select Specialty', style: TextStyle(color: textColor.withOpacity(0.7))),
                          dropdownColor: isDark ? AppPallete.backgroundColor : Colors.white,
                          style: TextStyle(color: textColor),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('All Specialties')),
                            ...specialties.map((specialty) => DropdownMenuItem(value: specialty, child: Text(specialty))),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedSpecialty = value;
                              _filterDoctors();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: _filteredDoctors.isEmpty
                ? Center(
                    child: Text(
                      'No doctors found matching your criteria.',
                      style: TextStyle(color: textColor.withOpacity(0.7), fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _filteredDoctors[index];
                      return GestureDetector(
                        onTap: () => _showDoctorDetails(context, doctor), // Show details on tap
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          color: cardColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: borderColor.withOpacity(0.3)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(doctor.imageUrl),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        doctor.name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        doctor.specialty,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppPallete.primaryColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${doctor.rating}',
                                            style: TextStyle(color: textColor.withOpacity(0.8)),
                                          ),
                                          const SizedBox(width: 8),
                                          Icon(Icons.location_on_rounded, color: AppPallete.greyColor, size: 18),
                                          const SizedBox(width: 4),
                                          Text(
                                            doctor.region,
                                            style: TextStyle(color: textColor.withOpacity(0.8)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded, color: AppPallete.greyColor),
                              ],
                            ),
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