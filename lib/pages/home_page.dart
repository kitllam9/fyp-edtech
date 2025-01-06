import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fyp_edtech/model/content.dart';
import 'package:fyp_edtech/model/paginated_data.dart';
import 'package:fyp_edtech/pages/exercise/exercise_page.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/file_io.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/pdf_viewer.dart';
import 'package:fyp_edtech/widgets/placeholder.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  PaginatedData<Content>? contentList;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Content.fetchContent().then((val) {
        if (mounted) {
          setState(() {
            contentList = val;
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
      itemCount: _isLoading ? 6 : contentList?.data.length,
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (context, index) {
        Content? content = contentList?.data[index];
        return Box(
          margin: EdgeInsets.all(5),
          child: SizedBox(
            width: Globals.screenWidth! * 0.42,
            height: _isLoading ? 250 : null,
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
                        context.loaderOverlay.show();
                        File? file;
                        await getPdf(content!.id).then((fileContent) async {
                          setState(() {
                            file = fileContent;
                          });
                        });
                        if (!context.mounted) return;
                        context.loaderOverlay.hide();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => content.type == ContentType.notes
                                ? CustomPDFViewer(
                                    file: file,
                                  )
                                : ExercisePage(),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            content?.title ?? '',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            content?.description ?? '',
                            style: TextStyle(
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
