import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fyp_edtech/pages/exercise/exercise_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/pdf_viewer.dart';
import 'package:fyp_edtech/widgets/placeholder.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 1)).then((val) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      physics: _isLoading ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
      itemCount: 10,
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) => Box(
        margin: EdgeInsets.all(5),
        child: SizedBox(
          width: Globals.screenWidth! * 0.42,
          height: _isLoading ? 250 : Random().nextInt(250) + 100,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading
                ? Shimmer.fromColors(
                    baseColor: AppColors.shimmerBase,
                    highlightColor: AppColors.shimmerHighlight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitlePlaceholder(
                          height: 24,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        ContentPlaceholder(
                          lines: 3,
                        ),
                      ],
                    ),
                  )
                : GenericButton(
                    onPressed: () async {
                      // var url = 'http://10.0.2.2:8000/test';
                      // var response = await http.get(Uri.parse(url));
                      // print(response.body);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => !index.isEven
                              ? PDFViewer(
                                  pdfAssetPath: 'assets/sample.pdf',
                                )
                              : ExercisePage(),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index.isEven ? 'Exercise' : 'Article',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Description',
                          style: TextStyle(
                            color: AppColors.text,
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
