import 'package:flutter/material.dart';
import 'package:fyp_edtech/styles/app_colors.dart';
import 'package:fyp_edtech/widgets/box.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
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
                ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) => Box(
                    margin: EdgeInsets.all(5),
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(
                            width: 15,
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
                                'user$index',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                '${(20 - index) * 1000} points',
                                style: TextStyle(
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) => Box(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
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
