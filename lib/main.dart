import 'package:flutter/material.dart';

void main() {
  runApp(const ProfPortalApp());
}

class ProfPortalApp extends StatelessWidget {
  const ProfPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dr. Ahmad's Portal",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const MainLayoutNavigation(),
    );
  }
}

// In-Memory Local State Simulation
class StudentState {
  final String id;
  final String roll;
  final String name;
  String status;
  final String history;

  StudentState({
    required this.id,
    required this.roll,
    required this.name,
    required this.status,
    required this.history,
  });
}

// Layout Controller: Auto-adapts layout interface between phone screens and desktop browsers
class MainLayoutNavigation extends StatefulWidget {
  const MainLayoutNavigation({super.key});

  @override
  State<MainLayoutNavigation> createState() => _MainLayoutNavigationState();
}

class _MainLayoutNavigationState extends State<MainLayoutNavigation> {
  int _selectedIndex = 0;
  String _activeCourseTitle = "Soil Science 2026";

  final List<StudentState> _mockStudents = [
    StudentState(id: "1", roll: "2026AG01", name: "Alice Vance", status: "Present", history: "94%"),
    StudentState(id: "2", roll: "2026AG02", name: "Bob Miller", status: "Present", history: "88%"),
    StudentState(id: "3", roll: "2026AG03", name: "Charlie Diaz", status: "Absent", history: "72%"),
  ];

  void _navigateToAttendance(String courseTitle) {
    setState(() {
      _activeCourseTitle = courseTitle;
      _selectedIndex = 1; // Switches view to the live tracking list
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 768;

    final List<Widget> screens = [
      TimetableScreen(onClassTap: _navigateToAttendance),
      AttendanceScreen(courseTitle: _activeCourseTitle, students: _mockStudents),
    ];

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(icon: Icon(Icons.calendar_month), label: Text('Schedule')),
                NavigationRailDestination(icon: Icon(Icons.check_circle_outline), label: Text('Attendance')),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(child: screens[_selectedIndex]),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: SafeArea(child: screens[_selectedIndex]),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Schedule'),
            NavigationDestination(icon: Icon(Icons.check_circle_outline), label: 'Attendance'),
          ],
        ),
      );
    }
  }
}

// View Component 1: Weekly Timetable Layout Widget
class TimetableScreen extends StatelessWidget {
  final Function(String) onClassTap;
  const TimetableScreen({super.key, required this.onClassTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Weekly Schedule", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const Text("Select an active class card to manage student registration details.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.count(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 5 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildClassCard(context, "Mon - 09:00 AM", "Soil Science", "Room 302"),
                _buildClassCard(context, "Wed - 09:00 AM", "Soil Science", "Room 302"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, String time, String title, String room) {
    return Card(
      elevation: 0,
      color: const Color(0xFFEFF6FF),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color(0xFFBFDBFE)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => onClassTap("$title ($time)"),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(time, style: const TextStyle(fontSize: 12, color: Colors.blueAccent, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8))),
              const SizedBox(height: 2),
              Text(room, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

// View Component 2: Roster Selection & Live Attendance Dashboard
class AttendanceScreen extends StatefulWidget {
  final String courseTitle;
  final List<StudentState> students;
  const AttendanceScreen({super.key, required this.courseTitle, required this.students});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.courseTitle, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const Text("Tap status badges to quickly toggle rows.", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: widget.students.length,
              itemBuilder: (context, index) {
                final student = widget.students[index];
                bool isPresent = student.status == "Present";
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(student.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Roll: ${student.roll} | Aggregated Attendance: ${student.history}"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPresent ? const Color(0xFF22C55E) : const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        setState(() {
                          student.status = isPresent ? "Absent" : "Present";
                        });
                      },
                      child: Text(student.status),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Simulated Sync Successful!')),
                );
              },
              child: const Text("Save Roster Changes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          )
        ],
      ),
    );
  }
}