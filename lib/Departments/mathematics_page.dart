import 'package:flutter/material.dart';
import 'package:students_app/Departments/pdfbutton.dart';

class MathematicsPage extends StatelessWidget {
  const MathematicsPage({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MathematicsData(title: 'Mathematics Department');
  }
}

class MathematicsData extends StatelessWidget {
  final String title;
  const MathematicsData({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: const [
          Chapter1(),
          Chapter2(),
          Chapter3(),
          Chapter4(),
          Chapter5(),
          Chapter6(),
        ],
      ),
    );
  }
}
