// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todoapp/ui/addList.dart';

import '../database/localstorage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // var todoItems = [];
  List<LocalStorage> notes = [];
  List<int> selectedIndices = [];
  void initState() {
    super.initState();

    _loadNotes(); // Load notes when the widget is initialized
  }

  Future<void> _loadNotes() async {
    List<LocalStorage> loadedNotes = await getNotesFromLocal();

    setState(() {
      notes = loadedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text("List of Todo"),
        ),
      ),
      body: notes.isEmpty
          ? Center(
              child: Text(
                "No data available.",
                style: TextStyle(fontSize: 30),
              ),
            )
          : Padding(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  bool isSelected = selectedIndices.contains(index);
                  return Container(
                    color: isSelected
                        ? Colors.deepPurple.withOpacity(0.2)
                        : Colors.transparent,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Text(
                          "${index + 1}",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Row(children: [
                        Text(
                          notes[index].title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Spacer(),
                        Text("${priorityCheck(notes[index].priority)}",
                            style: TextStyle(
                                color: priorityColor(notes[index].priority),
                                fontSize: 14)),
                      ]),
                      subtitle: Text(
                        notes[index].description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                            PopupMenuItem<String>(
                              value: 'completed',
                              child:
                                  Text(isSelected ? 'Incomplete' : 'Complete'),
                            ),
                          ];
                        },
                        onSelected: (value) {
                          if (value == 'delete') {
                            setState(() {
                              if (isSelected) {
                                selectedIndices.remove(index);
                              }
                            });

                            _deleteNote(index);
                          } else if (value == 'edit') {
                            _editNote(notes[index], index);
                          } else {
                            setState(() {
                              if (isSelected) {
                                selectedIndices.remove(index);
                              } else {
                                selectedIndices.add(index);
                              }
                            });
                          }
                        },
                      ),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        label: Text("Add Todo"),
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ListAdd()));

          await _loadNotes();
        },
      ),
    );
  }

  String priorityCheck(int priorityValue) {
    if (priorityValue == 3) {
      return "Low Priority";
    } else if (priorityValue == 2) {
      return "Medium Priority";
    } else {
      return "High Priority";
    }
  }

  Color priorityColor(int priorityValue) {
    if (priorityValue == 3) {
      return const Color.fromARGB(255, 4, 107, 7);
    } else if (priorityValue == 2) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Future<void> _deleteNote(int index) async {
    await deleteNoteFromLocal(index);

    setState(() {
      notes.removeAt(index);
    });
  }

  void _editNote(LocalStorage note, int index) async {
    var editedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListAdd(initialNote: note),
      ),
    );
    if (editedNote != null) {
      await updateNoteToLocal(editedNote, index);
      await _loadNotes();
    }
  }
}
