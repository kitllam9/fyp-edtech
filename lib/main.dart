import 'package:flutter/material.dart';
import 'package:fyp_edtech/config/routes.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/app_layout.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainApp(),
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.scaffold,
        textTheme: GoogleFonts.notoSansTextTheme(),
      ),
      routes: routes,
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
  void didChangeDependencies() {
    Globals.screenWidth = MediaQuery.of(context).size.width;
    Globals.screenHeight = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(index: 0);
  }
}
