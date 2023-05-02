import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:material3/providers/notes_provider.dart';
import 'package:provider/provider.dart';

String convertDateToString(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

TextEditingController titleController = TextEditingController();
TextEditingController contentController = TextEditingController();
DateTime dateController = DateTime.now();

Future<void> createNote(BuildContext context) async {
  if (titleController.text.length > 1) {
    await context
        .read<NotesProvider>()
        .addNote(titleController.text, contentController.text);
    titleController.clear();
    contentController.clear();
    // ignore: use_build_context_synchronously
    Navigator.pop(context);
  } else {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: Container(
        decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.white24)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Cannot create an empty note',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.white24),
          ),
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

Future<void> deleteNote(BuildContext context) async {
  showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Delete Note?'),
            content: const Text('Are you sure you want to delete this note'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style:
                        OutlinedButton.styleFrom(shape: const StadiumBorder()),
                    onPressed: () {
                      context.read<NotesProvider>().setEdited(false);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(shape: const StadiumBorder()),
                    onPressed: () {
                      context.read<NotesProvider>().removeNote(
                            context.read<NotesProvider>().selectedNote.id,
                            context.read<NotesProvider>().selectedNoteIndex,
                          );
                      context.read<NotesProvider>().setEdited(false);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              )
            ],
          ));
}

class _AddNoteState extends State<AddNote> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (context.read<NotesProvider>().noteState == false) {
        titleController.text =
            Provider.of<NotesProvider>(context, listen: false)
                .selectedNote
                .title!;
        contentController.text =
            Provider.of<NotesProvider>(context, listen: false)
                .selectedNote
                .content!;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<NotesProvider>().setNoteState(false);
                      context.read<NotesProvider>().setEdited(false);
                      titleController.clear();
                      contentController.clear();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  )
                      .animate()
                      .slideX(delay: 500.ms, duration: 500.ms)
                      .fadeIn(delay: 550.ms, begin: 0),
                  context.watch<NotesProvider>().noteState
                      ? TextButton(
                          onPressed: () {
                            createNote(context).then((value) {
                              context.read<NotesProvider>().setNoteList();
                            });
                          },
                          child: Text(
                            'create',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(color: Colors.white),
                          ),
                        )
                          .animate()
                          .slideX(
                              delay: 500.ms, duration: 500.ms, end: 0, begin: 1)
                          .fadeIn(delay: 550.ms)
                      : context.watch<NotesProvider>().noteState == false &&
                              context.watch<NotesProvider>().edited == true
                          ? TextButton(
                              onPressed: () {
                                context.read<NotesProvider>().updateNote(
                                      context
                                          .read<NotesProvider>()
                                          .selectedNote
                                          .id,
                                      titleController.text,
                                      contentController.text,
                                    );
                                context.read<NotesProvider>().setEdited(false);
                                context.read<NotesProvider>().setNoteList();
                                titleController.clear();
                                contentController.clear();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'save',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            )
                              .animate()
                              .slideX(
                                  delay: 500.ms,
                                  duration: 500.ms,
                                  end: 0,
                                  begin: 1)
                              .fadeIn(delay: 550.ms)
                          : context.watch<NotesProvider>().noteState == false &&
                                  context.watch<NotesProvider>().edited == false
                              ? TextButton(
                                  onPressed: () {
                                    deleteNote(context);
                                  },
                                  child: Text(
                                    'delete',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                )
                                  .animate()
                                  .slideX(
                                      delay: 500.ms,
                                      duration: 500.ms,
                                      end: 0,
                                      begin: 1)
                                  .fadeIn(delay: 550.ms)
                              : const SizedBox(),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Divider(),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                convertDateToString(context.watch<NotesProvider>().noteState
                    ? DateTime.now()
                    : context.read<NotesProvider>().selectedNote.date!),
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white24),
              )
                  .animate()
                  .slideX(delay: 500.ms, duration: 500.ms)
                  .fadeIn(delay: 550.ms),
              const SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: ListView(
                  children: [
                    Animate(
                      effects: [
                        SlideEffect(
                            delay: 500.ms,
                            duration: 500.ms,
                            begin: const Offset(0, 1),
                            end: const Offset(0, 0)),
                        FadeEffect(delay: 550.ms),
                      ],
                      child: TextField(
                        onChanged: (val) {
                          context.read<NotesProvider>().setEdited(true);
                        },
                        controller: titleController,
                        style: Theme.of(context).textTheme.displayMedium,
                        maxLines: null,
                        cursorColor: Colors.white,
                        decoration:
                            const InputDecoration.collapsed(hintText: 'Title'),
                      ),
                    ),
                    const SizedBox(
                      height: 30.0,
                    ),
                    Animate(
                      effects: [
                        SlideEffect(
                            delay: 500.ms,
                            duration: 500.ms,
                            begin: const Offset(0, 1),
                            end: const Offset(0, 0)),
                        FadeEffect(delay: 550.ms),
                      ],
                      child: TextField(
                        onChanged: (val) {
                          context.read<NotesProvider>().setEdited(true);
                        },
                        controller: contentController,
                        maxLines: null,
                        cursorColor: Colors.white,
                        style: Theme.of(context).textTheme.titleLarge,
                        decoration: const InputDecoration.collapsed(
                            hintText: 'What\'s on your mind?'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
