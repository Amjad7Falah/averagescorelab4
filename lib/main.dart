import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: GradesPage(),
      ),
    );
  }
}

class Student {
  final String name;
  int grade;
  Student(this.name, this.grade);
}

class GradesPage extends StatefulWidget {
  const GradesPage({super.key});

  @override
  State<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends State<GradesPage> {
  static const int passGrade = 55;

  final List<Student> students = [
    Student('נועה', 92),
    Student('דנה', 71),
    Student('יוסף', 54),
    Student('עומר', 48),
  ];

  double get average {
    if (students.isEmpty) return 0;
    // map each student to their grade, then sum the grades
    final total = students.map((s) => s.grade).reduce((a, b) => a + b);
    return total / students.length;
  }

  void changeGrade(Student s, int delta) {
    setState(() {
      s.grade = (s.grade + delta).clamp(0, 100);
    });
  }

  void sortByGrade() {
    setState(() {
      students.sort((a, b) => b.grade.compareTo(a.grade));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'ממוצע: ${average.toStringAsFixed(1)}',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  IconButton.filledTonal(
                    icon: const Icon(Icons.sort),
                    tooltip: 'מיין לפי ציון',
                    onPressed: sortByGrade,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  // map each student to a ListTile widget
                  children: students.map((s) {
                    final passed = s.grade >= passGrade;
                    return ListTile(
                      leading: Icon(
                        passed ? Icons.check_circle : Icons.cancel,
                        color: passed ? Colors.green : Colors.red,
                      ),
                      title: Text(s.name),
                      subtitle: Text('ציון: ${s.grade}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => changeGrade(s, -1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => changeGrade(s, 1),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
