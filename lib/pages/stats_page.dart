import 'package:flutter/material.dart';
import 'package:fyp_edtech/model/badge.dart';
import 'package:fyp_edtech/model/member.dart';
import 'package:fyp_edtech/model/paginated_data.dart';
import 'package:fyp_edtech/model/quest.dart';
import 'package:fyp_edtech/model/user.dart';
import 'package:fyp_edtech/pages/completed_page.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/buttons.dart';
import 'package:fyp_edtech/widgets/custom_shimmer_loader.dart';
import 'package:fyp_edtech/widgets/placeholder.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_animation_progress_bar/simple_animation_progress_bar.dart';

final User currentUser = GetIt.instance.get<User>();

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  bool init = true;
  int _page = 1;
  List<Member> userList = [];
  List<Quest> questList = [];

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
    } catch (e) {
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
      await Quest.fetch().then((list) {
        setState(() {
          questList = list ?? [];
        });
      });
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
                                      width: Globals.screenWidth! * 0.48,
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
                      : userList.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'No enough data... \n',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          height: 1.75,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Try completing more content so that we can find users similar to you.',
                                        style: TextStyle(
                                          color: AppColors.primary,
                                          fontStyle: FontStyle.italic,
                                          height: 1.75,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: userList.length,
                              itemBuilder: (context, index) {
                                Member? user = userList[index];
                                bool isCurrentUser = currentUser.username == user.username;
                                return Box(
                                  backgroundColor: isCurrentUser ? AppColors.primary : AppColors.secondary,
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
                                              color: isCurrentUser ? AppColors.secondary : AppColors.primary,
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
                                                color: isCurrentUser ? AppColors.secondary : AppColors.primary,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${user.points} points',
                                              style: TextStyle(
                                                color: isCurrentUser ? AppColors.secondary : AppColors.primary,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 10),
                      child: Text(
                        'Quests will be refreshed every day!',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: questList.length,
                        itemBuilder: (context, index) {
                          Quest quest = questList[index];
                          return Stack(
                            children: [
                              GenericButton(
                                disabled: !quest.completed || (quest.claimed ?? false),
                                onPressed: () async {
                                  await quest.complete().then((success) async {
                                    if (success) {
                                      await currentUser.checkBadges(points: quest.reward).then((map) {
                                        if (!context.mounted) return;
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) => CompletedPage(
                                              type: CompletedType.quest,
                                              targets: List<int>.from(map!['targets']),
                                              currentPoints: map['current_points'],
                                              targetPoints: map['target_points'],
                                              earnedBadges: [
                                                for (var json in map['earned_badges']) MyBadge.fromJson(json)
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                    }
                                  });
                                },
                                child: Box(
                                  backgroundColor: AppColors.secondary.withAlpha((quest.claimed ?? false) ? 140 : 255),
                                  margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                quest.name,
                                                style: TextStyle(
                                                  color:
                                                      AppColors.primary.withAlpha((quest.claimed ?? false) ? 100 : 255),
                                                  fontSize: 20,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                quest.description,
                                                style: TextStyle(
                                                  color: AppColors.text.withAlpha((quest.claimed ?? false) ? 175 : 255),
                                                  height: 1.7,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              SimpleAnimationProgressBar(
                                                ratio: (quest.progress / quest.target) >= 1
                                                    ? 1
                                                    : (quest.progress / quest.target),
                                                width: Globals.screenWidth! * 0.85,
                                                height: 8,
                                                borderRadius: BorderRadius.circular(8),
                                                direction: Axis.horizontal,
                                                backgroundColor: AppColors.unselected.withAlpha(100),
                                                foregrondColor:
                                                    AppColors.primary.withAlpha((quest.claimed ?? false) ? 10 : 255),
                                                duration: Duration.zero,
                                                curve: Curves.easeInOutCubic,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '${quest.progress > quest.target ? quest.target : quest.progress}/${quest.target}',
                                                    style: TextStyle(
                                                      color: AppColors.text,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (quest.completed && !(quest.claimed ?? false))
                                Positioned(
                                  top: Globals.screenHeight! * 0.023,
                                  right: Globals.screenWidth! * 0.025,
                                  child: Icon(
                                    Symbols.exclamation,
                                    color: AppColors.primary,
                                    size: 30,
                                  ),
                                )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
