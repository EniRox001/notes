import 'package:go_router/go_router.dart';
import 'package:material3/screens/add_note.dart';

import 'package:material3/screens/homepage.dart';
import 'package:material3/screens/splash_screen.dart';

final appRouter = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/add_note',
      builder: (context, state) => const AddNote(),
    ),
  ],
);
