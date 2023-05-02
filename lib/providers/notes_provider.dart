import 'package:flutter/material.dart';
import 'package:material3/models/notes.dart';

class NotesProvider extends ChangeNotifier {
  List _notes = <Notes>[];
  bool _noteState = false;
  bool _edited = false;
  late Notes _selectedNote;
  late int _selectedNoteIndex;
  String _greeting = '';

  List get notes => _notes;

  bool get noteState => _noteState;

  bool get edited => _edited;

  Notes get selectedNote => _selectedNote;

  int get selectedNoteIndex => _selectedNoteIndex;

  String get greeting => _greeting;

  Future<void> setNoteList() async {
    getNotes().then((value) => _notes = value);
  }

  Future<void> addNote(String title, String content) async {
    await createNote(title, content).then((note) => _notes.add(note));

    notifyListeners();
  }

  Future<void> updateNote(int id, String title, String content) async {
    await editNote(id, title, content)
        .then((note) => notes[_selectedNoteIndex] = note);

    notifyListeners();
  }

  void setNoteState(bool state) {
    _noteState = state;

    notifyListeners();
  }

  void setEdited(bool value) {
    _edited = value;

    notifyListeners();
  }

  void setSelectedNote(Notes note) {
    _selectedNote = note;

    notifyListeners();
  }

  void setSelectedNoteIndex(int index) {
    _selectedNoteIndex = index;

    notifyListeners();
  }

  void removeNote(int id, int index) async {
    await deleteNote(id).then(
      (user) => _notes.remove(
        _notes[index],
      ),
    );

    notifyListeners();
  }

  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'morning';
    } else if (hour < 17) {
      return 'afternoon';
    } else {
      return 'evening';
    }
  }

  void setGreeting() {
    _greeting = getGreeting();
    notifyListeners();
  }
}
