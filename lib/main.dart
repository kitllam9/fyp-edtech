import 'package:flutter/material.dart';
import 'package:fyp_edtech/widgets/app_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: const MainApp(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Color.fromARGB(255, 248, 248, 248),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 15, 15, 15),
          onPrimary: Colors.white,
          secondary: Color(0xFFB1B1B1),
          onSecondary: Color.fromARGB(255, 15, 15, 15),
          error: Colors.red,
          onError: Colors.white,
          surface: Color.fromARGB(255, 248, 248, 248),
          onSurface: Color.fromARGB(255, 15, 15, 15),
        ),
      ),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return AppLayout(index: 0);
  }
}
