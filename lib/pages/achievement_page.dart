import 'package:flutter/material.dart';
import 'package:fyp_edtech/model/badge.dart';
import 'package:fyp_edtech/model/user.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/utils/globals.dart';
import 'package:fyp_edtech/widgets/box.dart';
import 'package:fyp_edtech/widgets/custom_shimmer_loader.dart';
import 'package:fyp_edtech/widgets/placeholder.dart';
import 'package:get_it/get_it.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class AchievementPage extends StatefulWidget {
  const AchievementPage({super.key});

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  final User user = GetIt.instance.get<User>();

  List<MyBadge> badgeList = [];

  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  bool isLoading = true;

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    await user.getUserData();
    await MyBadge.fetchBadges(ids: user.badges ?? []).then((list) {
      setState(() {
        isLoading = false;
        badgeList = list ?? [];
      });
    });
    _refreshController.refreshCompleted(resetFooterState: true);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await MyBadge.fetchBadges(ids: user.badges ?? []).then((list) {
        setState(() {
          badgeList = list ?? [];
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      enablePullDown: true,
      onRefresh: _refresh,
      controller: _refreshController,
      physics: BouncingScrollPhysics(),
      child: isLoading
          ? CustomShimmmerLoader(
              col: 1,
              row: 7,
              customLayoutBuilder: (index) => Box(
                margin: EdgeInsets.all(5),
                child: Container(
                  padding: EdgeInsets.all(15),
                  height: 100,
                  child: Row(
                    children: [
                      Icon(
                        Symbols.workspace_premium,
                        size: 50,
                        color: AppColors.primary,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Shimmer.fromColors(
                        baseColor: AppColors.shimmerBase,
                        highlightColor: AppColors.shimmerHighlight,
                        child: SizedBox(
                          width: Globals.screenWidth! * 0.6,
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
              itemCount: badgeList.length,
              itemBuilder: (context, index) {
                MyBadge? badge = badgeList[index];
                return Box(
                  margin: EdgeInsets.all(5),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    height: 100,
                    child: Row(
                      children: [
                        Icon(
                          Symbols.workspace_premium,
                          size: 50,
                          color: AppColors.primary,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              badge.name,
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              badge.description,
                              style: TextStyle(
                                color: AppColors.text,
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
    );
  }
}
