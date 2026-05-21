import 'package:flutter/material.dart';

class WriteReportModule extends StatelessWidget {
  final bool isSidebarCollapsed;
  final VoidCallback onTap;

  const WriteReportModule({
    super.key,
    required this.isSidebarCollapsed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return isSidebarCollapsed
        ? IconButton(
            icon: const Icon(Icons.edit_document, color: Colors.white),
            onPressed: onTap,
            tooltip: 'Write Report',
          )
        : ListTile(
            leading: const Icon(Icons.edit_document, color: Colors.white),
            title: const Text('Write Report', style: TextStyle(color: Colors.white)),
            onTap: onTap,
          );
  }
}
