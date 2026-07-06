import 'package:flutter/material.dart';

void main() {
  runApp(const ProfPortalApp());
}

class ProfPortalApp extends StatelessWidget {
  const ProfPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dr. Saad's Portal",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      // App starts at Login, then transitions to Main Layout on Success
      home: const LoginScreen(),
    );
  }
}

// ==========================================
// NEW MODULE: SECURE LOGIN SCREEN INTERFACE
// ==========================================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulation of Secure Handshake Verification Network Delay
      Future.delayed(const Duration(milliseconds: 1200), () {
        setState(() {
          _isLoading = false;
        });

        // Routing transition to the main schedule matrix dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayoutNavigation()),
        );
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 440),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.school, size: 48, color: Color(0xFF2563EB)),
                    const SizedBox(height: 16),
                    const Text(
                      "Welcome Back",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                    const Text(
                      "Sign in to manage academic rows & rosters.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email Address",
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid academic email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        prefixIcon: Icon(Icons.lock_outline),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty || value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: _isLoading ? null : _handleLogin,
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text("Sign In", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// CORE APP SCHEDULER & ATTENDANCE DASHBOARD
// ==========================================
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
      _selectedIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 768;

    final List<Widget> screens = [
      TimetableScreen(onClassTap: _navigateToAttendance),
      AttendanceScreen(courseTitle: _activeCourseTitle, students: _mockStudents),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Dr. Saad's Portal", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          )
        ],
      ),
      body: Row(
        children: [
          if (isDesktop) ...[
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
          ],
          Expanded(child: screens[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
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