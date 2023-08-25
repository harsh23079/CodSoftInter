import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  final String title;
  final String description;
  final int priority;
  const LocalStorage({
    required this.title,
    required this.description,
    required this.priority,
  });
}

Future<void> saveNoteToLocal(LocalStorage note) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final notes = prefs.getStringList('notes') ?? [];
  notes.add('${note.title},${note.description},${note.priority}');
  await prefs.setStringList('notes', notes);
}

Future<List<LocalStorage>> getNotesFromLocal() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final notesList = prefs.getStringList('notes') ?? [];

  List<LocalStorage> notes = notesList.map((noteString) {
    final noteData = noteString.split(',');

    if (noteData.length >= 3) {
      final title = noteData[0];
      final description = noteData[1];
      final priority = int.tryParse(noteData[2]) ?? 1;

      return LocalStorage(
        title: title,
        description: description,
        priority: priority,
      );
    } else {
      return LocalStorage(
        title: 'Invalid Note',
        description: 'Invalid Description',
        priority: 1,
      );
    }
  }).toList();

  notes.sort((a, b) => a.priority.compareTo(b.priority));

  return notes;
}

Future<void> deleteNoteFromLocal(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final notesList = prefs.getStringList('notes') ?? [];

  if (index >= 0 && index < notesList.length) {
    notesList.removeAt(index);
    await prefs.setStringList('notes', notesList);
  } else {
    print("Invalid index");
  }
}

Future<void> updateNoteToLocal(LocalStorage editedNote, int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final notesList = prefs.getStringList('notes') ?? [];

  if (index >= 0 && index < notesList.length) {
    notesList[index] =
        '${editedNote.title},${editedNote.description},${editedNote.priority}';
    await prefs.setStringList('notes', notesList);
  }
}
