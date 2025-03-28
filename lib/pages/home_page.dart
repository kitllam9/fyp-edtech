import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fyp_edtech/model/content.dart';
import 'package:fyp_edtech/model/paginated_data.dart';
import 'package:fyp_edtech/pages/exercise/exercise_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/utils/misc.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/custom_shimmer_loader.dart';
import 'package:fyp_edtech/widgets/pdf_viewer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool init = true;
  int _page = 1;
  List<Content> contentList = [];

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _search() async {
    try {
      PaginatedData<Content>? response = await Content.search(page: _page);
      List<Content>? content = response?.data;
      if (content!.isEmpty) {
        _refreshController.loadNoData();
      } else {
        setState(() {
          _page++;
          contentList.addAll(content);
          _refreshController.loadComplete();
        });
      }
    } catch (error) {
      //
    }
  }

  Future<void> _refresh() async {
    setState(() {
      contentList.clear();
      _page = 1;
    });
    await _search();
    _refreshController.refreshCompleted(resetFooterState: true);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _search().then((_) {
        setState(() {
          init = false;
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: MaterialScrollBehavior(),
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _refresh,
        onLoading: _search,
        controller: _refreshController,
        child: init || _refreshController.headerStatus == RefreshStatus.refreshing
            ? CustomShimmmerLoader()
            : MasonryGridView.extent(
                maxCrossAxisExtent: Globals.screenWidth! * 0.5,
                itemCount: contentList.length,
                itemBuilder: (context, index) {
                  Content? content = contentList[index];
                  return Box(
                    margin: EdgeInsets.all(5),
                    child: SizedBox(
                      width: Globals.screenWidth! * 0.4,
                      height: init ? 250 : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GenericButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => content.type == ContentType.notes
                                    ? CustomPDFViewer(
                                        id: content.id,
                                        points: content.points,
                                      )
                                    : ExercisePage(
                                        id: content.id,
                                        questions: content.exerciseDetails ?? [],
                                        points: content.points,
                                        mode: ExerciseViewMode.regular,
                                      ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.unselected,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      content.type.name.capitalize(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                content.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                content.description,
                                style: TextStyle(
                                  color: AppColors.text,
                                  fontSize: 12,
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
      ),
    );
  }
}
