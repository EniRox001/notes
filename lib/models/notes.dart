import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

part 'notes.g.dart';

@collection
class Notes {
  Id id = Isar.autoIncrement;

  String? title;
  String? content;
  DateTime? date;
}

late Isar isar;

Future<void> initializeNotesDB() async {
  final dir = await getApplicationDocumentsDirectory();

  final isarDB = await Isar.open([NotesSchema], directory: dir.path);

  isar = isarDB;
}

Future<List> getNotes() async {
  final notes = await isar.notes.where().findAll();
  return notes;
}

Future<Object> editNote(int id, String title, String content) async {
  final note = Notes()
    ..id = id
    ..title = title
    ..content = content
    ..date = DateTime.now();
  try {
    await isar.writeTxn(() async {
      await isar.notes.put(note);

      //On success return success message
      return note;
    });
  } catch (e) {
    //On fail return error message
    return 'an error occured';
  }
  //On completion return completed message
  return note;
}

Future<Object> createNote(String title, String content) async {
  final note = Notes()
    ..title = title
    ..content = content
    ..date = DateTime.now();
  try {
    await isar.writeTxn(() async {
      await isar.notes.put(note);

      //On success return success message
      return note;
    });
  } catch (e) {
    //On fail return error message
    return 'an error occured';
  }
  //On completion return completed message
  return note;
}

Future deleteNote(int id) async {
  await isar.writeTxn(() async {
    final success = await isar.notes.delete(id);
    return ('Note deleted: $success');
  });
}
