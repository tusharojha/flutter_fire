import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/buttons.dart';

import 'models/note.dart';
import 'note_tile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(title: 'Quick Notes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Note>> _notes;
  FirebaseFirestore _firestore;
  TextEditingController _controller = TextEditingController();

  Future<List<Note>> fetchNotes() async {
    var result = await _firestore.collection('notes').get();
    if (result.docs.isEmpty) {
      return [];
    }
    var notes = <Note>[];
    for (var doc in result.docs) {
      notes.add(Note.fromMap(doc.data()));
    }
    return notes;
  }

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
    _notes = fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text("What's the note about?"),
              content: TextField(
                controller: _controller,
              ),
              actions: [
                ChipButton(
                  title: 'Yes',
                  action: () async {
                    // This creates an empty document and returns the auto-gen uid.
                    var uid = _firestore.collection('notes').doc().id;

                    // adding data to the document using the uid we got.
                    await _firestore.collection('notes').doc(uid).set({
                      'title': _controller.text,
                      'uid': uid,
                      'completed': false
                    });
                    Navigator.pop(context);
                    setState(() {
                      _notes = fetchNotes();
                      _controller.clear();
                    });
                  },
                ),
                ChipButton(title: 'No', action: () => Navigator.pop(context)),
              ],
            ),
          );
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _notes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if ((snapshot.data as List).isEmpty) {
                  return Center(
                    child: Text('No Notes Added.'),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _notes = fetchNotes();
                    });
                  },
                  child: ListView.builder(
                    itemCount: (snapshot.data as List).length,
                    itemBuilder: (context, index) {
                      return NoteTile(
                        note: snapshot.data[index],
                        onDelete: () async {
                          await _firestore
                              .collection('notes')
                              .doc((snapshot.data[index] as Note).uid)
                              .delete();
                          setState(() {
                            _notes = fetchNotes();
                          });
                        },
                        onCompleted: (dynamic val) async {
                          await _firestore
                              .collection('notes')
                              .doc((snapshot.data[index] as Note).uid)
                              .update({
                            'completed': val as bool,
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
