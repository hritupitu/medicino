import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_app/home/email_not_verified.dart';
import 'package:hackathon_app/home/home_page.dart';
import 'package:hackathon_app/landingpage/landing_page.dart';
import 'package:hackathon_app/notifier/auth_notifier.dart';
import 'package:hackathon_app/notifier/user_notifier.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthNotifier()),
        ChangeNotifierProvider(create: (context) => UserNotifier()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicino',
      debugShowCheckedModeBanner: false,
      home: Consumer<AuthNotifier>(
        builder: (context, notifier, child) {
          if (notifier.user != null) {
            if (notifier.user.email != null && notifier.user.email.isNotEmpty) {
              return notifier.user.emailVerified
                  ? HomePage()
                  : EmailNotVerifiedPage();
            } else {
              return HomePage();
            }
          } else {
            return LandingPage();
          }
        },
      ),
    );
  }
}
