// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:todoapp/database/localstorage.dart';
import 'package:todoapp/ui/homescreen.dart';

class ListAdd extends StatefulWidget {
  final LocalStorage? initialNote;
  const ListAdd({this.initialNote, super.key});

  @override
  State<ListAdd> createState() => _ListAddState();
}

class _ListAddState extends State<ListAdd> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String selectedPriorityValue = "Low Priority"; // Default priority value

  Map<String, int> priorityValues = {
    'Low Priority': 3,
    'Medium Priority': 2,
    'High Priority': 1,
  };
  void initState() {
    super.initState();
    if (widget.initialNote != null) {
      titleController.text = widget.initialNote!.title;
      descriptionController.text = widget.initialNote!.description;
      selectedPriorityValue = getPriorityLabel(widget.initialNote!.priority);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Center(
            child:
                Text(widget.initialNote == null ? "Add To do" : "Edit To do"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: titleController,
                maxLength: 15,
                decoration: InputDecoration(
                  hintText: "Title",
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: descriptionController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "Description",
                ),
              ),
              SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedPriorityValue,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedPriorityValue = newValue;
                    });
                  }
                },
                items: priorityValues.keys.map<DropdownMenuItem<String>>(
                  (String priority) {
                    return DropdownMenuItem<String>(
                      value: priority,
                      child: Text(priority),
                    );
                  },
                ).toList(),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                  onPressed: () async {
                    String title = titleController.text;
                    String description = descriptionController.text;
                    int? priorityValue = priorityValues[selectedPriorityValue]!;
                    // String date = DateTime.now().toString();

                    LocalStorage note = LocalStorage(
                      title: title,
                      description: description,
                      priority: priorityValue,
                    );

                    if (widget.initialNote != null) {
                      // Edit mode
                      await updateNoteToLocal(
                          note, widget.initialNote!.priority);
                    } else {
                      // Add mode
                      await saveNoteToLocal(note);
                    }

                    titleController.clear();
                    descriptionController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                            child: widget.initialNote == null
                                ? Text('saved data')
                                : Text('update data')),
                        backgroundColor: Color.fromARGB(207, 10, 209, 56),
                      ),
                    );
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0), // Adjust padding
                    ),
                  ),
                  child: widget.initialNote != Null
                      ? Text(
                          "Update",
                          style: TextStyle(fontSize: 15),
                        )
                      : Text(
                          "Submit",
                          style: TextStyle(fontSize: 15),
                        )),
            ],
          ),
        ));
  }

  String getPriorityLabel(int priority) {
    if (priority == 1) {
      return "High Priority";
    } else if (priority == 2) {
      return "Medium Priority";
    } else {
      return "Low Priority";
    }
  }
}
