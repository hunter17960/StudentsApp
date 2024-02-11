import 'package:flutter/material.dart';
import 'package:students_app/WelcomePages/welPageOfBotany&Microbiology.dart';
import 'package:students_app/WelcomePages/welPageOfChemistry.dart';
import 'package:students_app/WelcomePages/welPageOfGeology.dart';
import 'package:students_app/WelcomePages/welPageOfMathematics.dart';
import 'package:students_app/WelcomePages/welPageOfPhysics.dart';
import 'package:students_app/WelcomePages/welPageOfZoology&Entomology.dart';

class PageViewExample extends StatefulWidget {
  const PageViewExample({Key? key}) : super(key: key);

  @override
  State<PageViewExample> createState() => _PageViewExampleState();
}

class _PageViewExampleState extends State<PageViewExample> {
  final PageController pageController = PageController(initialPage: 0);
  int activePage = 0;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: height,
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (int page) {
                setState(() {
                  activePage = page;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (BuildContext context, index) {
                return _pages[index % _pages.length];
              },
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: List<Widget>.generate(
                      _pages.length,
                      (int index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: InkWell(
                              onTap: () {
                                pageController.animateToPage(index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              child: CircleAvatar(
                                radius: 8,
                                // check if a dot is connected to the current page
                                // if true, give it a different color
                                backgroundColor: activePage == index
                                    ? Colors.blue
                                    : Colors.grey,
                              ),
                            ),
                          )),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('logInScreen');
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Skip',
                        style: TextStyle(fontSize: 19, color: Colors.blue),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.blue,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FacultyOfScience extends StatelessWidget {
  const FacultyOfScience({
    super.key,
    required this.imageName,
    required this.textWelcome,
    required this.textAbout,
  });
  final String imageName;
  final String textWelcome;
  final String textAbout;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("images/$imageName"),
                  fit: BoxFit.cover,
                  opacity: 0.3),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  const SizedBox(height: 50,),
                  Text(
                    textWelcome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Assiut University',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 100),
                  const Text(
                    'Overview                                       ',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    textAbout,
                    style: const TextStyle(color: Colors.white60, fontSize: 20),
                  ),
                ]),
                // TextButton(
                //     onPressed: () {
                //       Navigator.of(context).pushReplacementNamed(routeName);
                //     },
                //     child: const Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         Text(
                //           'Skip',
                //           style: TextStyle(fontSize: 22),
                //         ),
                //         Icon(
                //           Icons.arrow_forward_ios,
                //           size: 20,
                //         )
                //       ],
                //     ))
              ],
            ),
          ),
        )
      ],
    ));
  }
}

final List<Widget> _pages = [
  const FacultyOfScience(
    imageName: 'FacultyOfScience.png',
    textAbout:
        'The University of Assiut was established in October 1957, with only two faculties the faculty of Science and the faculty of Engineering.',
    textWelcome: 'Welcome to',
  ),
  const MathematicsW(),
  const PhysicsW(),
  const ChemistryW(),
  const GeologyW(),
  const BotanyAndMicrobiology(),
  const ZoologyAndEntomology(),
];
