import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fyp_edtech/model/content.dart';
import 'package:fyp_edtech/model/paginated_data.dart';
import 'package:fyp_edtech/pages/exercise/exercise_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/pdf_viewer.dart';
import 'package:fyp_edtech/widgets/placeholder.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:shimmer/shimmer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode inputFocusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  PaginatedData<Content>? contentList;

  bool _isLoading = true;
  int page = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Content.fetchContent(page: page).then((val) {
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(3, 0, 3, 8),
          child: TextField(
            cursorColor: AppColors.primary,
            controller: _textEditingController,
            focusNode: inputFocusNode,
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(15),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.unselected,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: AppColors.primary,
                ),
              ),
              hintText: 'Explore...',
              hintStyle: TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.w400,
              ),
              suffixIcon: GenericButton(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Symbols.close,
                    color: AppColors.primary,
                  ),
                ),
                onPressed: () {
                  _textEditingController.clear();
                },
              ),
              suffixIconConstraints: BoxConstraints(
                maxHeight: double.infinity,
              ),
            ),
          ),
        ),
        Expanded(
          child: MasonryGridView.builder(
            physics: _isLoading ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
            itemCount: _isLoading ? 6 : contentList?.data.length,
            gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, index) {
              Content? content = contentList?.data[index];
              return Box(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => content?.type == ContentType.notes
                                      ? CustomPDFViewer(
                                          id: content!.id,
                                          points: content.points,
                                        )
                                      : ExercisePage(
                                          id: content!.id,
                                          questions: content.exerciseDetails ?? [],
                                        ),
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
          ),
        )
      ],
    );
  }
}
