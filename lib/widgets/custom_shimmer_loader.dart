import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/placeholder.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmmerLoader extends StatelessWidget {
  final int? col;
  final int? row;
  const CustomShimmmerLoader({
    super.key,
    this.col,
    this.row,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          for (int i = 0; i < (row ?? 3); i++)
            Row(
              children: [
                for (int j = 0; j < (col ?? 2); j++)
                  Box(
                    margin: EdgeInsets.all(5),
                    child: SizedBox(
                      width: Globals.screenWidth! * 0.42,
                      height: 250,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Shimmer.fromColors(
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
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
