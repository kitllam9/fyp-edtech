import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fyp_edtech/widgets/box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      itemCount: 10,
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) => Box(
        margin: EdgeInsets.all(5),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.42,
          height: Random().nextInt(250) + 100,
        ),
      ),
    );
  }
}
