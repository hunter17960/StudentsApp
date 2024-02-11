import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/note_reader.dart';
import '../screens/note_editor.dart';
import '../widgets/note_card.dart';

class NOTEScreen extends StatefulWidget {
  const NOTEScreen({Key? key}) : super(key: key);

  @override
  State<NOTEScreen> createState() => _NOTEScreenState();
}

class _NOTEScreenState extends State<NOTEScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String userId = user?.uid ?? '';
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Your Recent Notes",
                  style: TextStyle(
                    color: Color.fromARGB(255, 14, 112, 188),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  )),
              const SizedBox(
                height: 20.0,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("notes")
                      .where('user_id', isEqualTo: userId.toString())
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return GridView(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        children: snapshot.data!.docs
                            .map<Widget>((note) => noteCard(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          NoteReaderScreen(note),
                                    ),
                                  );
                                }, note))
                            .toList(),
                      );
                    }
                    return const Text(
                      "there's no Notes",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NoteEditorScreen()));
          },
          label: const Text("Add Note"),
          icon: const Icon(Icons.add),
        ));
  }
}