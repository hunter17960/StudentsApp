import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:students_app/MainPage/calendar_page.dart';
import 'package:students_app/MainPage/searchPage.dart';
import 'package:students_app/database/appointment_editor.dart';
import 'package:students_app/database/table.dart';
import 'WelcomePages/welPageOfFacultyOfScience.dart';
import 'package:students_app/Auth/login_screen.dart';
import 'package:students_app/Auth/signUpScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: 'facultyOfScience',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'homePage':
            {
              return MaterialPageRoute(builder: (context) {
                return const HomePage();
              });
            }
          case 'tableScreen':
            {
              return MaterialPageRoute(builder: (context) {
                return const TableData();
              });
            }
        }
        return null;
      },
      routes: {
        'facultyOfScience': (context) => const PageViewExample(),
        'logInScreen': (context) => const LogIn(),
        'signUpScreen': (context) => const SignUp(),
        'searchPage': (context) => const SearchPage(),
        'homePage': (context) => const HomePage(),
        'tableScreen': (context) => const TableData(),
      },
    );
  }
}
