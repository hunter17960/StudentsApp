// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:students_app/MainPage/chat_gpt.dart';
import 'package:students_app/MainPage/departements_page.dart';
import 'package:students_app/MainPage/calendar_page.dart';
import 'package:students_app/MainPage/notes_page.dart';
import 'package:students_app/MainPage/search_page.dart';
import '../Auth/login_screen.dart';
import 'stats_page.dart';

Color mainColor = const Color.fromARGB(255, 1, 87, 155);

class MainPage extends StatefulWidget {
  const MainPage(
    this.user, {
    Key? key,
  }) : super(key: key);
  final User user;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 2);

  String _title = "Home";
  final _screens = const [
    CalendarPage(),
    DepartementsPage(),
    HomePage1(),
    SearchPage(),
    NotesPage(),
  ];

  final _navBarItems = [
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.calendar),
      title: ("Calendar"),
      activeColorPrimary: mainColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.text_badge_minus),
      title: ("Departments"),
      activeColorPrimary: mainColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.home),
      title: ("Home"),
      activeColorPrimary: mainColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.search),
      title: ("Search"),
      activeColorPrimary: mainColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(CupertinoIcons.news),
      title: ("Notes"),
      activeColorPrimary: mainColor,
      inactiveColorPrimary: CupertinoColors.systemGrey,
    ),
  ];

  final _auth = FirebaseAuth.instance;
  final messageTextController = TextEditingController();

  bool signOutLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: signOutLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: mainColor,
          title: Text(
            _title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25.0,
            ),
          ),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatGPT()),
                );
              },
              icon: Image.asset(
                'images/ChatGPT.png',
                color: Colors.white70,
              ),
            )
          ],
        ),
        drawer: Drawer(
          child: Column(children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: mainColor),
              currentAccountPicture: FutureBuilder<String?>(
                future: fetchUserPhoto(widget.user),
                builder: (BuildContext context,
                    AsyncSnapshot<String?> photoSnapshot) {
                  if (photoSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    // Display a loading indicator or placeholder while waiting for data
                    return const CircularProgressIndicator();
                  } else if (photoSnapshot.hasData &&
                      photoSnapshot.data != null) {
                    return CircleAvatar(
                      child: ClipOval(
                        child: Image(
                          image: NetworkImage(photoSnapshot.data!),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  } else {
                    // No data available, display the default logo using Image.asset
                    return CircleAvatar(
                      child: ClipOval(
                        child: Image.asset(
                          'images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                },
              ),
              accountName: FutureBuilder<String?>(
                future: fetchUserName(widget.user),
                builder: (BuildContext context,
                    AsyncSnapshot<String?> nameSnapshot) {
                  return Text(nameSnapshot.data ?? 'guest@example.com');
                },
              ),
              accountEmail: FutureBuilder<String?>(
                future: fetchUseremail(widget.user),
                builder: (BuildContext context,
                    AsyncSnapshot<String?> emailSnapshot) {
                  return Text(emailSnapshot.data ?? 'guest@example.com');
                },
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ),
            const Divider(thickness: 1),
            TextButton(
              onPressed: () {},
              child: const ListTile(
                leading: Icon(Icons.settings_accessibility),
                title: Text('About us'),
              ),
            ),
            const Divider(thickness: 1),
            TextButton(
              onPressed: () {},
              child: const ListTile(
                leading: Icon(Icons.help),
                title: Text('Help'),
              ),
            ),
            const Divider(thickness: 1),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Logout"),
                        content: const Text("Are you Sure you want to Logout?"),
                        actions: [
                          IconButton(
                              onPressed: () async {
                                // await LogIn.clearSharedPreferences();
                                // await _auth.signOut();
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: () async {
                                await _auth.signOut();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => const LogIn()),
                                    (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ))
                        ],
                      );
                    });
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ]),
        ),
        body: PersistentTabView(
          context,
          controller: _controller,
          screens: _screens,
          items: _navBarItems,
          navBarStyle: NavBarStyle.style9,
          onItemSelected: (index) {
            setState(() {
              _title = _navBarItems[index].title!;
            });
          },
        ),
      ),
    );
  }

  Future<String?> fetchUserName(User user) async {
    try {
      String uid = user.uid;
      var snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        final nameUser = userData['name'] as String?;
        return nameUser;
      } else {
        // Document with the given UID doesn't exist
        return null;
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      return null;
    }
  }

  Future<String?> fetchUserPhoto(User user) async {
    try {
      String uid = user.uid;
      var snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        final photoUrl = userData['photoURL'] as String?;
        return photoUrl;
      } else {
        // Document with the given UID doesn't exist
        return null;
      }
    } catch (e) {
      // Handle any errors that might occur during the process
      return null;
    }
  }

  Future<String?> fetchUseremail(User user) async {
    try {
      String email = user.email ?? '';
      return email;
    } catch (e) {
      // Handle any errors that might occur during the process
      return null;
    }
  }
}
