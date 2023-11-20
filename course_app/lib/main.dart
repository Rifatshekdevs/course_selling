import 'package:course_app/auth/provider/auth_provider_state.dart';
import 'package:course_app/auth/provider/course_provider_state.dart';
import 'package:course_app/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=> AuthProviderState()),
      ChangeNotifierProvider(create: (_)=> CourseProviderState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Course App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WelcomePage(),
      ),
    );
  }
}
