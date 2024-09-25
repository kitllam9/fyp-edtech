import 'package:flutter/material.dart';
import 'package:fyp_edtech/widgets/box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('bruh'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Box(
              child: Text('data'),
            ),
            Box(
              child: Text('data'),
            ),
          ],
        ),
      ),
    );
  }
}
