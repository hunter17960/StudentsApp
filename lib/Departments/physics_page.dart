import 'package:flutter/material.dart';
import 'package:students_app/Departments/pdfbutton.dart';

class PhysicsPage extends StatelessWidget {
  const PhysicsPage({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const PhysicsData(title: 'Physics Department');
  }
}

class PhysicsData extends StatelessWidget {
  final String title;
  const PhysicsData({super.key, required this.title});

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
