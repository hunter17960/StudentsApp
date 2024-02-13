import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:students_app/MainPage/calendar_page.dart';
import 'package:students_app/MainPage/main_page.dart';
import 'package:students_app/MainPage/search_page.dart';
import 'package:students_app/database/table.dart';
import 'MainPage/welcome_pages.dart';
import 'package:students_app/Auth/login_screen.dart';
import 'package:students_app/Auth/sign_up_screen.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? user = FirebaseAuth.instance.currentUser;
  runApp( MyApp(user));
}
class MyApp extends StatelessWidget {
  final User? user;
  const MyApp(this.user, {Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: user!=null ?  MainPage(user!):const WelcomePage(),
      routes: {
        'facultyOfScience': (context) => const WelcomePage(),
        'logInScreen': (context) => const LogIn(),
        'signUpScreen': (context) => const SignUp(),
        'searchPage': (context) => const SearchPage(),
        'homePage': (context) => const CalendarPage(),
        'tableScreen': (context) => const TableData(),
        // 'mainpage':(context) => const MainPage(),
      },
    );
  }
}