import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

Future<Object> navigateToHome(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    context.push('/home');
  });
  return Future.value(true);
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
        logo: Image.asset(
          'assets/images/book.png',
          color: Colors.white,
        ),
        title: Text(
          "Notes",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        durationInSeconds: 3,
        futureNavigator: navigateToHome(context));
  }
}
