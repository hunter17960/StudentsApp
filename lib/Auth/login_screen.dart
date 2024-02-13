
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:students_app/Auth/auth_service.dart';
import 'package:students_app/Auth/button_of_login_signup.dart';
import 'package:students_app/MainPage/main_page.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});
  @override
  State<LogIn> createState() => _LogInState();
}
class _LogInState extends State<LogIn> {
  late String email;
  late String password;
  late String emailGoogle;
  late String userNameGoogle;
  late String profilePictureGoogle;

  bool loginLoading = false;
  bool _obscureAction = true;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: loginLoading,
      opacity: 0,
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/FacultyOfScience.png"),
              fit: BoxFit.cover,
              opacity: 0.2),
        ),
        child: ListView(children: [
          const SizedBox(height: 250),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 30,
            ),
            Form(
              child: Column(children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    email = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'email',
                    labelText: 'email',
                    labelStyle: TextStyle(color: Colors.white70),
                    hintStyle: TextStyle(color: Colors.white70),
                    prefixIcon: Icon(
                      Icons.supervised_user_circle_sharp,
                      color: Colors.white70,
                    ),
                    fillColor: Colors.black38,
                    filled: false,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        borderSide:
                            BorderSide(color: Colors.white54, width: 1.5)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    password = value;
                  },
                  obscureText: _obscureAction,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'password',
                    labelText: 'password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon:
                        const Icon(Icons.password, color: Colors.white70),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureAction = !_obscureAction;
                        });
                      },
                      icon: const Icon(Icons.visibility, color: Colors.white70),
                    ),
                    fillColor: Colors.black38,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.white54, width: 1.5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(color: Colors.blue, width: 1.5),
                    ),
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 1),
            const SizedBox(height: 1),
            Row(children: [
              const SizedBox(width: 15),
              const Text(
                "Don't have an account ?",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white70),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('signUpScreen');
                },
                child: const Text(
                  'SignUp',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              )
            ]),
            ButtonOfLogInSignUp(
              title: 'Log in',
              onPressed: () async {
                setState(() {
                  loginLoading = true;
                });
                try {
                  UserCredential userCredential =
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: email, password: password);
                  User? user = userCredential.user;
                  setState(() {
                    loginLoading = false;
                  });
                  if (context.mounted) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MainPage(user!)));
                  }
                } on SocketException {
                  // ignore: avoid_print
                  print("error connection");
                } catch (e) {
                  setState(() {
                    loginLoading = false;
                  });
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          title: const Text("Error"),
                          titleTextStyle:
                              const TextStyle(color: Colors.redAccent),
                          content: Text(
                            '$e',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black45,
                            ),
                          ),
                          backgroundColor: Colors.white70,
                        );
                      },
                    );
                  }
                  // Only catches an exception of type `Exception`.
                }
              },
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Or connect using',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  child: const Text(
                    'Google',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    setState(() {
                      loginLoading = true;
                    });
                    User? user = await AuthService().signInWithGoogle();
                    
                    setState(() {
                        loginLoading = false;
                      });
                    if (context.mounted) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainPage(user!)));
                      
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 50),
          ]),
        ]),
      ),
    ));
  }
}
