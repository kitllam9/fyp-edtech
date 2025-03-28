import 'package:flutter/material.dart';
import 'package:fyp_edtech/model/content.dart';
import 'package:fyp_edtech/model/paginated_data.dart';
import 'package:fyp_edtech/model/user.dart';
import 'package:fyp_edtech/pages/exercise/exercise_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/utils/misc.dart';
import 'package:fyp_edtech/widgets/appbar.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/custom_shimmer_loader.dart';
import 'package:fyp_edtech/widgets/pdf_viewer.dart';
import 'package:fyp_edtech/widgets/placeholder.dart';
import 'package:get_it/get_it.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({super.key});

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  bool init = true;
  int _page = 1;
  List<Content> contentList = [];

  final User user = GetIt.instance.get<User>();

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _getBookmarks() async {
    try {
      PaginatedData<Content>? response = await user.getBookmarks(page: _page);
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
    await _getBookmarks();
    _refreshController.refreshCompleted(resetFooterState: true);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _getBookmarks().then((_) {
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
    return Scaffold(
      appBar: mainAppBar(context, title: 'Bookmarks'),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _refresh,
        onLoading: _getBookmarks,
        controller: _refreshController,
        child: init || _refreshController.headerStatus == RefreshStatus.refreshing
            ? CustomShimmmerLoader(
                col: 1,
                row: 8,
                customLayoutBuilder: (index) => Box(
                  margin: EdgeInsets.all(5),
                  child: SizedBox(
                    width: Globals.screenWidth! * 0.9,
                    // height: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
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
              )
            : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: contentList.length,
                itemBuilder: (context, index) {
                  Content? content = contentList[index];
                  return Box(
                    margin: EdgeInsets.all(5),
                    child: GenericButton(
                      onPressed: () {
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                fontSize: 20,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              content.description,
                              style: TextStyle(
                                color: AppColors.text,
                              ),
                            ),
                          ],
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
