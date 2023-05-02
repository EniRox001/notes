import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:material3/providers/notes_provider.dart';
import 'package:material3/screens/add_note.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<NotesProvider>(context, listen: false).setGreeting();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<NotesProvider>(context, listen: true).setNoteList();
    List notes = context.watch<NotesProvider>().notes;
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'good,',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(color: Colors.white24),
                              ),
                              TextSpan(
                                  text:
                                      ' ${context.watch<NotesProvider>().greeting}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium)
                            ],
                          ),
                        ),
                      ],
                    )
                        .animate()
                        .slideX(delay: 500.ms, duration: 500.ms)
                        .fadeIn(delay: 550.ms, begin: 0),
                    IconButton(
                      onPressed: () {
                        context.read<NotesProvider>().setNoteState(true);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AddNote(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add, color: Colors.white),
                    )
                        .animate()
                        .slideX(
                            delay: 500.ms, duration: 500.ms, end: 0, begin: 1)
                        .fadeIn(delay: 550.ms)
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Divider(),
                const SizedBox(
                  height: 15.0,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'your',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                        Text(
                          '  notes',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                        .animate()
                        .slideX(delay: 500.ms, duration: 500.ms)
                        .fadeIn(delay: 550.ms),
                    Text(
                      '/${notes.length}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Colors.white24, fontWeight: FontWeight.w400),
                    )
                        .animate()
                        .slideX(
                            delay: 500.ms, duration: 500.ms, end: 0, begin: 1)
                        .fadeIn(delay: 550.ms)
                  ],
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Divider(),
                Expanded(
                  child: notes.isEmpty
                      ? Animate(
                          effects: [
                            SlideEffect(
                                delay: 500.ms,
                                duration: 500.ms,
                                begin: const Offset(0, 1),
                                end: const Offset(0, 0)),
                            FadeEffect(delay: 700.ms),
                          ],
                          child: Center(
                            child: Text(
                              'Write it down before you forget it! 😊',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white24),
                            ),
                          ),
                        )
                      : LiquidPullToRefresh(
                          showChildOpacityTransition: false,
                          color: Colors.blueGrey.shade900,
                          backgroundColor: Colors.white,
                          onRefresh: () async {
                            context.read<NotesProvider>().setNoteList();
                          },
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              return Animate(
                                effects: [
                                  index % 2 == 0
                                      ? SlideEffect(
                                          delay: 500.ms,
                                          duration: 500.ms,
                                          begin: const Offset(-1, 0),
                                          end: const Offset(0, 0),
                                        )
                                      : SlideEffect(
                                          delay: 500.ms,
                                          duration: 500.ms,
                                          begin: const Offset(1, 0),
                                          end: const Offset(0, 0),
                                        ),
                                  FadeEffect(
                                    delay: 550.ms,
                                  )
                                ],
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          index < 9
                                              ? '0${index + 1}/'
                                              : '${index + 1}/',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(color: Colors.white24),
                                        ),
                                        const SizedBox(width: 20.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notes[index].title,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displaySmall,
                                              ),
                                              const SizedBox(height: 20.0),
                                              Text(
                                                notes[index].content,
                                                maxLines: 4,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                        color: Colors.white24),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            context
                                                .read<NotesProvider>()
                                                .setNoteState(false);
                                            context
                                                .read<NotesProvider>()
                                                .setSelectedNote(notes[index]);
                                            context
                                                .read<NotesProvider>()
                                                .setSelectedNoteIndex(index);
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddNote(),
                                              ),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.north_east,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20.0),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: notes.length,
                          ),
                        ),
                ),
              ],
            )),
      ),
    );
  }
}
