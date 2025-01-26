import 'package:flutter/material.dart';
import 'package:fyp_edtech/model/member.dart';
import 'package:fyp_edtech/model/paginated_data.dart';
import 'package:fyp_edtech/pages/completed_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/custom_shimmer_loader.dart';
import 'package:fyp_edtech/widgets/placeholder.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shimmer/shimmer.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool init = true;
  int _page = 1;
  List<Member> userList = [];

  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  Future<void> _fetchPage() async {
    try {
      PaginatedData<Member>? response = await Member.getRanking(page: _page);
      List<Member>? users = response?.data;
      if (users!.isEmpty) {
        _refreshController.loadNoData();
      } else {
        setState(() {
          _page++;
          userList.addAll(users);
          _refreshController.loadComplete();
        });
      }
    } catch (e, s) {
      //
    }
  }

  Future<void> _refresh() async {
    setState(() {
      userList.clear();
      _page = 1;
    });
    await _fetchPage();
    _refreshController.refreshCompleted(resetFooterState: true);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchPage().then((_) {
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
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            dividerColor: Colors.transparent,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            indicatorColor: AppColors.primary,
            unselectedLabelColor: AppColors.unselected,
            splashFactory: NoSplash.splashFactory,
            overlayColor: WidgetStatePropertyAll(Colors.transparent),
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: EdgeInsets.symmetric(horizontal: 5),
            tabs: [
              Tab(
                child: Text(
                  'Leaderboard',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Tab(
                child: Text(
                  'Quests',
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: TabBarView(
              children: [
                SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  onRefresh: _refresh,
                  onLoading: _fetchPage,
                  controller: _refreshController,
                  child: init || _refreshController.headerStatus == RefreshStatus.refreshing
                      ? CustomShimmmerLoader(
                          col: 1,
                          row: 7,
                          customLayoutBuilder: (index) => Box(
                            margin: EdgeInsets.all(5),
                            child: Container(
                              height: 95,
                              padding: EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 25,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: AppColors.shimmerBase,
                                    highlightColor: AppColors.shimmerHighlight,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 35,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Shimmer.fromColors(
                                    baseColor: AppColors.shimmerBase,
                                    highlightColor: AppColors.shimmerHighlight,
                                    child: SizedBox(
                                      width: Globals.screenWidth! * 0.53,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          TitlePlaceholder(
                                            height: 12,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          ContentPlaceholder(
                                            lines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            Member? user = userList[index];
                            return Box(
                              margin: EdgeInsets.all(5),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 25,
                                      child: Text(
                                        '${index + 1}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 35,
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.username,
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          '${user.points} points',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => GenericButton(
                    // onPressed: () => Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => CompletedPage(
                    //       contentId: 1,
                    //       type: CompletedType.quest,
                    //     ),
                    //   ),
                    // ),
                    onPressed: () => print('object'),
                    child: Box(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  index == 0 ? 'Daily Quest' : 'Regular Quest',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    color: AppColors.text,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
